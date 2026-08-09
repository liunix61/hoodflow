#!/bin/bash

# HoodFlow - 部署脚本
# 部署智能合约到Robinhood Chain

set -e

echo "=== HoodFlow 智能合约部署脚本 ==="
echo ""

# 检查环境变量
if [ -z "$ROBINHOOD_CHAIN_RPC_URL" ]; then
    echo "错误: ROBINHOOD_CHAIN_RPC_URL 未设置"
    echo "请设置环境变量: export ROBINHOOD_CHAIN_RPC_URL='https://rpc.mainnet.chain.robinhood.com'"
    exit 1
fi

if [ -z "$PRIVATE_KEY" ]; then
    echo "错误: PRIVATE_KEY 未设置"
    echo "请设置环境变量: export PRIVATE_KEY='0x...'"
    exit 1
fi

# 检查编译工具
if ! command -v solc &> /dev/null; then
    echo "错误: solc 未安装"
    echo "请安装 solc: https://docs.soliditylang.org/"
    exit 1
fi

# 检查Node.js（用于部署工具）
if ! command -v node &> /dev/null; then
    echo "错误: node 未安装"
    echo "请安装 Node.js: https://nodejs.org/"
    exit 1
fi

# 检查truffle或hardhat
if ! command -v truffle &> /dev/null && ! command -v npx &> /dev/null; then
    echo "警告: truffle 或 hardhat 未安装"
    echo "建议安装 hardhat: npm install -g hardhat"
fi

# 编译智能合约
echo "编译智能合约..."
cd contracts
solc --bin --abi --optimize --optimize-runs 200 HoodFlowStrategy.sol -o build/
cd ..

# 检查编译结果
if [ ! -f "contracts/build/HoodFlowStrategy.bin" ] || [ ! -f "contracts/build/HoodFlowStrategy.abi" ]; then
    echo "错误: 智能合约编译失败"
    exit 1
fi

echo "✅ 智能合约编译成功"
echo ""

# 显示ABI
echo "=== ABI ==="
cat contracts/build/HoodFlowStrategy.abi
echo ""

# 显示二进制
echo "=== Binary ==="
cat contracts/build/HoodFlowStrategy.bin
echo ""

# 部署选项
echo "=== 部署选项 ==="
echo "1. 使用 Hardhat 部署（推荐）"
echo "2. 使用 Truffle 部署"
echo "3. 手动部署"
echo "4. 退出"
echo ""
read -p "请选择部署方式 (1-4): " choice

case $choice in
    1)
        echo ""
        echo "使用 Hardhat 部署..."
        if [ -f "hardhat.config.js" ]; then
            npx hardhat run scripts/deploy.js --network robinhood
        else
            echo "错误: hardhat.config.js 不存在"
            echo "请创建 hardhat.config.js 配置文件"
            exit 1
        fi
        ;;
    2)
        echo ""
        echo "使用 Truffle 部署..."
        if [ -f "truffle-config.js" ]; then
            truffle deploy --network robinhood
        else
            echo "错误: truffle-config.js 不存在"
            echo "请创建 truffle-config.js 配置文件"
            exit 1
        fi
        ;;
    3)
        echo ""
        echo "手动部署..."
        echo "请使用 Remix IDE: https://remix.ethereum.org/"
        echo "1. 打开 Remix IDE"
        echo "2. 选择 File Browser -> contracts -> HoodFlowStrategy.sol"
        echo "3. 点击 Compile -> Compile HoodFlowStrategy.sol"
        echo "4. 点击 Deploy -> Deploy to Environment -> Injected Provider - MetaMask"
        echo "5. 连接 Robinhood Chain 钱包"
        echo "6. 点击 Deploy"
        echo ""
        read -p "部署完成？(y/n): " confirm
        if [ "$confirm" = "y" ]; then
            echo "✅ 部署完成！"
        fi
        ;;
    4)
        echo "退出"
        exit 0
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac

echo ""
echo "=== 部署完成 ==="
