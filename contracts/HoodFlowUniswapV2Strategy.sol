// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title HoodFlowUniswapV2Strategy
 * @dev HoodFlow做市策略智能合约（Uniswap V2版本）
 * @author HoodFlow Team
 * @notice 基于Uniswap V2的做市策略，支持多池做市
 */
contract HoodFlowUniswapV2Strategy is ERC20, Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    // ========== 状态变量 ==========

    // Uniswap V2 Factory地址
    address public uniswapV2Factory;

    // Uniswap V2 Router地址
    address public uniswapV2Router;

    // 做市商地址
    address public marketMaker;

    // 代币池列表（最大100个池子）
    address[] public pools;

    // 池子映射（代币对 -> 池子地址）
    mapping(address => address) public poolForPair;

    // 代币对映射（tokenA -> tokenB -> pair）
    mapping(address => mapping(address => address)) public pairForTokens;

    // 做市商手续费率（2%）
    uint256 public constant FEE_RATE = 20; // 20 = 2%

    // 最小流动性阈值（10%）
    uint256 public constant MIN_LIQUIDITY_THRESHOLD = 100; // 100 = 1%

    // 最小做市金额（1 ETH）
    uint256 public constant MIN_LIQUIDITY_AMOUNT = 1 * 1e18;

    // ========== 事件 ==========

    event PoolAdded(address indexed pool, address indexed token0, address indexed token1);
    event PoolRemoved(address indexed pool, address indexed token0, address indexed token1);
    event TradeExecuted(
        address indexed trader,
        address indexed token,
        address indexed pair,
        uint256 amountIn,
        uint256 amountOut,
        uint256 fee,
        uint256 timestamp
    );
    event LiquidityUpdated(
        address indexed pair,
        uint256 token0Reserves,
        uint256 token1Reserves,
        uint256 timestamp
    );
    event MarketMakerUpdated(address indexed marketMaker);

    // ========== 错误 ==========

    error InvalidPool();
    error InsufficientLiquidity();
    error InvalidTradeType();

    // ========== 不可变变量 ==========

    IERC20 public immutable WETH;

    // ========== 构造函数 ==========

    /**
     * @dev 构造函数
     * @param initialSupply 初始供应量
     * @param _uniswapV2Factory Uniswap V2 Factory地址
     * @param _uniswapV2Router Uniswap V2 Router地址
     * @param _weth WETH地址
     */
    constructor(
        uint256 initialSupply,
        address _uniswapV2Factory,
        address _uniswapV2Router,
        address _weth
    ) ERC20("HoodFlow", "HOOD") Ownable(msg.sender) ReentrancyGuard() {
        _mint(msg.sender, initialSupply);
        uniswapV2Factory = _uniswapV2Factory;
        uniswapV2Router = _uniswapV2Router;
        WETH = IERC20(_weth);
    }

    // ========== 外部函数 ==========

    /**
     * @dev 设置做市商地址
     * @param _marketMaker 做市商地址
     */
    function setMarketMaker(address _marketMaker) external onlyOwner {
        marketMaker = _marketMaker;
        emit MarketMakerUpdated(_marketMaker);
    }

    /**
     * @dev 设置最小流动性阈值
     * @param _threshold 流动性阈值（1% = 100）
     */
    function setMinLiquidityThreshold(uint256 _threshold) external onlyOwner {
        MIN_LIQUIDITY_THRESHOLD = _threshold;
    }

    /**
     * @dev 设置最小做市金额
     * @param _amount 最小做市金额（单位：WETH）
     */
    function setMinLiquidityAmount(uint256 _amount) external onlyOwner {
        MIN_LIQUIDITY_AMOUNT = _amount;
    }

    /**
     * @dev 添加代币对池子
     * @param tokenA 代币A地址
     * @param tokenB 代币B地址
     * @param amountA 代币A数量
     * @param amountB 代币B数量
     * @param deadline 交易截止时间
     * @return pair 池子地址
     */
    function addPool(
        address tokenA,
        address tokenB,
        uint256 amountA,
        uint256 amountB,
        uint256 deadline
    ) external nonReentrant returns (address pair) {
        require(msg.sender == marketMaker, "Only market maker");

        // 确保tokenA < tokenB（避免重复添加）
        if (tokenA > tokenB) {
            (tokenA, tokenB) = (tokenB, tokenA);
        }

        // 检查池子是否已存在
        address existingPair = pairForTokens[tokenA][tokenB];
        if (existingPair != address(0)) {
            return existingPair;
        }

        // 创建池子
        pair = uniswapV2Factory.createPair(tokenA, tokenB);

        // 检查池子是否创建成功
        require(pair != address(0), "Failed to create pair");

        // 存储池子映射
        pairForTokens[tokenA][tokenB] = pair;
        poolForTokens[pair] = tokenA; // tokenA是token0

        // 添加流动性
        IERC20(tokenA).safeTransferFrom(msg.sender, pair, amountA);
        IERC20(tokenB).safeTransferFrom(msg.sender, pair, amountB);

        emit PoolAdded(pair, tokenA, tokenB);
        emit LiquidityUpdated(pair, amountA, amountB, block.timestamp);

        return pair;
    }

    /**
     * @dev 移除代币对池子
     * @param tokenA 代币A地址
     * @param tokenB 代币B地址
     * @param minAmountA 最小代币A数量
     * @param minAmountB 最小代币B数量
     * @param deadline 交易截止时间
     * @return amountA 返回的代币A数量
     * @return amountB 返回的代币B数量
     */
    function removePool(
        address tokenA,
        address tokenB,
        uint256 minAmountA,
        uint256 minAmountB,
        uint256 deadline
    ) external nonReentrant returns (uint256 amountA, uint256 amountB) {
        require(msg.sender == marketMaker, "Only market maker");

        // 确保tokenA < tokenB
        if (tokenA > tokenB) {
            (tokenA, tokenB) = (tokenB, tokenA);
        }

        // 获取池子地址
        address pair = pairForTokens[tokenA][tokenB];
        require(pair != address(0), "Pool not found");

        // 获取池子储备量
        (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pair).getReserves();

        // 计算返回数量
        amountA = (reserve0 * minAmountB) / reserve1;
        amountB = (reserve1 * minAmountA) / reserve0;

        require(amountA >= minAmountA && amountB >= minAmountB, "Insufficient output");

        // 移除流动性
        IUniswapV2Pair(pair).removeLiquidity(
            tokenA,
            tokenB,
            amountA,
            amountB,
            msg.sender,
            deadline
        );

        emit PoolRemoved(pair, tokenA, tokenB);
        emit LiquidityUpdated(pair, amountA, amountB, block.timestamp);

        return (amountA, amountB);
    }

    /**
     * @dev 执行交易（做市商调用）
     * @param pair 池子地址
     * @param amountIn 输入数量
     * @param amountOutMin 最小输出数量
     * @param deadline 交易截止时间
     * @return amountOut 输出数量
     */
    function executeTrade(
        address pair,
        uint256 amountIn,
        uint256 amountOutMin,
        uint256 deadline
    ) external nonReentrant returns (uint256 amountOut) {
        require(msg.sender == marketMaker, "Only market maker");

        // 获取池子信息
        (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pair).getReserves();

        // 确定token0和token1
        address token0 = poolForTokens[pair];
        address token1 = token0 == WETH.address ? msg.sender : WETH.address;

        // 计算手续费
        uint256 fee = (amountIn * FEE_RATE) / 1000;
        uint256 amountInAfterFee = amountIn - fee;

        // 执行交易
        if (token0 == WETH.address) {
            // 花费ETH，获得代币
            WETH.safeTransferFrom(msg.sender, pair, amountInAfterFee);
            amountOut = IUniswapV2Router02(uniswapV2Router).swapExactETHForTokens(
                amountOutMin,
                token0,
                token1,
                msg.sender,
                deadline
            );
        } else {
            // 花费代币，获得ETH
            IERC20(token0).safeTransferFrom(msg.sender, pair, amountInAfterFee);
            amountOut = IUniswapV2Router02(uniswapV2Router).swapExactTokensForETH(
                amountInAfterFee,
                amountOutMin,
                token0,
                token1,
                msg.sender,
                deadline
            );
        }

        emit TradeExecuted(
            msg.sender,
            token0,
            pair,
            amountIn,
            amountOut,
            fee,
            block.timestamp
        );

        return amountOut;
    }

    /**
     * @dev 更新池子储备量（做市商调用）
     * @param pair 池子地址
     * @param reserve0 token0储备量
     * @param reserve1 token1储备量
     */
    function updatePoolReserves(
        address pair,
        uint256 reserve0,
        uint256 reserve1
    ) external onlyOwner {
        emit LiquidityUpdated(pair, reserve0, reserve1, block.timestamp);
    }

    /**
     * @dev 获取池子信息
     * @param pair 池子地址
     * @return token0 token0地址
     * @return token1 token1地址
     * @return reserve0 token0储备量
     * @return reserve1 token1储备量
     */
    function getPoolInfo(address pair)
        external
        view
        returns (
            address token0,
            address token1,
            uint256 reserve0,
            uint256 reserve1
        )
    {
        (reserve0, reserve1, ) = IUniswapV2Pair(pair).getReserves();
        token0 = poolForTokens[pair];
        token1 = token0 == WETH.address ? address(0) : WETH.address;
    }

    /**
     * @dev 获取做市商地址
     */
    function getMarketMaker() external view returns (address) {
        return marketMaker;
    }

    /**
     * @dev 获取手续费率
     */
    function getFeeRate() external view returns (uint256) {
        return FEE_RATE;
    }

    /**
     * @dev 获取最小流动性阈值
     */
    function getMinLiquidityThreshold() external view returns (uint256) {
        return MIN_LIQUIDITY_THRESHOLD;
    }

    /**
     * @dev 获取最小做市金额
     */
    function getMinLiquidityAmount() external view returns (uint256) {
        return MIN_LIQUIDITY_AMOUNT;
    }

    /**
     * @dev 获取池子数量
     */
    function getPoolCount() external view returns (uint256) {
        return pools.length;
    }

    /**
     * @dev 获取所有池子
     */
    function getPools() external view returns (address[] memory) {
        return pools;
    }
}

// ========== 接口 ==========

/**
 * @dev Uniswap V2 Pair Interface
 */
interface IUniswapV2Pair {
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountA,
        uint256 amountB,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address tokenOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address tokenIn,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

/**
 * @dev Uniswap V2 Factory Interface
 */
interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

/**
 * @dev Uniswap V2 Router02 Interface
 */
interface IUniswapV2Router02 {
    function swapExactETHForTokens(
        uint256 amountOutMin,
        address tokenOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address tokenIn,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}
