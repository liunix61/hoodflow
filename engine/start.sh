#!/bin/bash

# HoodFlow - 一键启动脚本
# 基于robinhood-evm-mcp的Python做市商

echo "=== HoodFlow 启动脚本 ==="
echo ""

# 检查Python版本
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "Python版本: $python_version"

# 检查pip
if ! command -v pip3 &> /dev/null; then
    echo "错误: pip3未安装"
    exit 1
fi

# 安装依赖
echo ""
echo "安装依赖..."
pip3 install -r requirements.txt

# 检查环境变量
if [ ! -f .env ]; then
    echo ""
    echo "警告: .env文件不存在，使用.env.example创建..."
    cp .env.example .env
    echo "请编辑.env文件，填入正确的RPC URL和私钥！"
fi

# 运行做市商
echo ""
echo "启动做市商..."
python3 market_maker.py

# 如果需要运行套利机器人
# echo ""
# echo "启动套利机器人..."
# python3 arbitrage_bot.py

# 如果需要运行风险管理器
# echo ""
# echo "启动风险管理器..."
# python3 risk_manager.py
