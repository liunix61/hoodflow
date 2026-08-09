// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title HoodFlowStrategy
 * @dev HoodFlow做市策略智能合约
 * @author HoodFlow Team
 */
contract HoodFlowStrategy is ERC20, Ownable {
    // 做市商地址
    address public marketMaker;

    // 做市商手续费率（2%）
    uint256 public constant FEE_RATE = 20; // 20 = 2%

    // 最小流动性阈值（10%）
    uint256 public constant MIN_LIQUIDITY_THRESHOLD = 100; // 100 = 1%

    // 事件
    event TradeExecuted(
        address indexed trader,
        address indexed token,
        uint256 amountIn,
        uint256 amountOut,
        uint256 fee,
        uint256 timestamp
    );

    event LiquidityUpdated(
        uint256 tokenReserves,
        uint256 ethReserves,
        uint256 timestamp
    );

    /**
     * @dev 构造函数
     * @param initialSupply 初始供应量
     */
    constructor(uint256 initialSupply) ERC20("HoodFlow", "HOOD") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    /**
     * @dev 设置做市商地址
     * @param _marketMaker 做市商地址
     */
    function setMarketMaker(address _marketMaker) external onlyOwner {
        marketMaker = _marketMaker;
    }

    /**
     * @dev 设置最小流动性阈值
     * @param _threshold 流动性阈值（1% = 100）
     */
    function setMinLiquidityThreshold(uint256 _threshold) external onlyOwner {
        MIN_LIQUIDITY_THRESHOLD = _threshold;
    }

    /**
     * @dev 设置手续费率
     * @param _rate 手续费率（20 = 2%）
     */
    function setFeeRate(uint256 _rate) external onlyOwner {
        FEE_RATE = _rate;
    }

    /**
     * @dev 执行交易（做市商调用）
     * @param tokenAddress 代币地址
     * @param amountIn 输入金额
     * @param tradeType 交易类型（0 = buy, 1 = sell）
     * @return amountOut 输出金额
     */
    function executeTrade(
        address tokenAddress,
        uint256 amountIn,
        uint8 tradeType
    ) external returns (uint256 amountOut) {
        require(msg.sender == marketMaker, "Only market maker");

        // 计算手续费
        uint256 fee = (amountIn * FEE_RATE) / 1000;
        uint256 amountAfterFee = amountIn - fee;

        if (tradeType == 0) {
            // 买入：花费ETH，获得代币
            // 这里简化处理，实际需要查询池子储备量
            amountOut = amountAfterFee;
        } else {
            // 卖出：花费代币，获得ETH
            // 这里简化处理，实际需要查询池子储备量
            amountOut = amountAfterFee;
        }

        emit TradeExecuted(
            msg.sender,
            tokenAddress,
            amountIn,
            amountOut,
            fee,
            block.timestamp
        );

        return amountOut;
    }

    /**
     * @dev 更新池子储备量（做市商调用）
     * @param tokenReserves 代币储备量
     * @param ethReserves ETH储备量
     */
    function updatePoolReserves(
        uint256 tokenReserves,
        uint256 ethReserves
    ) external onlyOwner {
        emit LiquidityUpdated(tokenReserves, ethReserves, block.timestamp);
    }

    /**
     * @dev 获取池子信息
     * @param tokenAddress 代币地址
     * @return tokenReserves 代币储备量
     * @return ethReserves ETH储备量
     */
    function getPoolReserves(address tokenAddress)
        external
        view
        returns (
            uint256 tokenReserves,
            uint256 ethReserves
        )
    {
        // 这里简化处理，实际需要查询池子合约
        return (tokenReserves, ethReserves);
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
}
