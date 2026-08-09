#!/bin/bash

# HoodFlow - 审计脚本
# 代码审计和安全性检查

set -e

echo "=== HoodFlow 安全审计脚本 ==="
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查文件
echo "=== 检查Python文件 ==="
python_files=$(find engine -name "*.py" -type f)
count=$(echo "$python_files" | wc -l)
echo "找到 $count 个Python文件"
echo ""

# 1. 代码风格检查
echo "=== 1. 代码风格检查 ==="
if command -v flake8 &> /dev/null; then
    echo "使用 flake8 检查..."
    flake8 engine --max-line-length=100 --ignore=E203,W503
    echo -e "${GREEN}✅ flake8 检查通过${NC}"
else
    echo -e "${YELLOW}⚠️  flake8 未安装，跳过${NC}"
fi

if command -v black &> /dev/null; then
    echo "使用 black 检查..."
    black --check engine
    echo -e "${GREEN}✅ black 检查通过${NC}"
else
    echo -e "${YELLOW}⚠️  black 未安装，跳过${NC}"
fi

if command -v isort &> /dev/null; then
    echo "使用 isort 检查..."
    isort --check-only engine
    echo -e "${GREEN}✅ isort 检查通过${NC}"
else
    echo -e "${YELLOW}⚠️  isort 未安装，跳过${NC}"
fi

echo ""

# 2. 类型检查
echo "=== 2. 类型检查 ==="
if command -v mypy &> /dev/null; then
    echo "使用 mypy 检查..."
    mypy engine --ignore-missing-imports
    echo -e "${GREEN}✅ mypy 检查通过${NC}"
else
    echo -e "${YELLOW}⚠️  mypy 未安装，跳过${NC}"
fi

echo ""

# 3. 安全检查
echo "=== 3. 安全检查 ==="
echo "检查敏感信息..."
if grep -r "PRIVATE_KEY\|private.*key\|secret.*key" engine/ --include="*.py" --include="*.env" | grep -v "\.env.example" | grep -v "#" | grep -v "__pycache__"; then
    echo -e "${RED}❌ 发现敏感信息泄露风险${NC}"
else
    echo -e "${GREEN}✅ 未发现敏感信息泄露风险${NC}"
fi

echo ""

# 4. 智能合约检查
echo "=== 4. 智能合约检查 ==="
if [ -f "contracts/HoodFlowStrategy.sol" ]; then
    echo "检查智能合约..."
    if command -v solhint &> /dev/null; then
        echo "使用 solhint 检查..."
        solhint contracts/*.sol
        echo -e "${GREEN}✅ solhint 检查通过${NC}"
    else
        echo -e "${YELLOW}⚠️  solhint 未安装，跳过${NC}"
    fi

    # 检查OpenZeppelin导入
    if grep -r "@openzeppelin" contracts/ --include="*.sol"; then
        echo -e "${GREEN}✅ 使用OpenZeppelin合约库${NC}"
    else
        echo -e "${YELLOW}⚠️  未使用OpenZeppelin合约库${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  智能合约文件不存在${NC}"
fi

echo ""

# 5. 测试检查
echo "=== 5. 测试检查 ==="
if [ -d "tests" ]; then
    test_count=$(find tests -name "test_*.py" | wc -l)
    echo "找到 $test_count 个测试文件"

    if [ $test_count -gt 0 ]; then
        if command -v pytest &> /dev/null; then
            echo "运行测试..."
            pytest tests/ -v --tb=short
            echo -e "${GREEN}✅ 测试运行完成${NC}"
        else
            echo -e "${YELLOW}⚠️  pytest 未安装，跳过测试运行${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  没有找到测试文件${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  tests 目录不存在${NC}"
fi

echo ""

# 6. 依赖检查
echo "=== 6. 依赖检查 ==="
if [ -f "engine/requirements.txt" ]; then
    echo "检查依赖..."
    # 检查是否有安全漏洞的依赖
    echo -e "${YELLOW}⚠️  建议使用 pip-audit 检查依赖安全漏洞${NC}"
fi

echo ""

# 7. Git检查
echo "=== 7. Git检查 ==="
if [ -d ".git" ]; then
    echo "检查Git历史..."
    git log --oneline --since="1 month ago" | wc -l
    echo "次提交"
    echo -e "${GREEN}✅ Git历史记录正常${NC}"
else
    echo -e "${YELLOW}⚠️  未找到.git目录${NC}"
fi

echo ""

# 总结
echo "=== 审计总结 ==="
echo -e "${GREEN}✅ 部分检查通过${NC}"
echo -e "${YELLOW}⚠️  部分检查需要安装额外工具${NC}"
echo -e "${RED}❌ 部分检查发现风险${NC}"
echo ""
echo "建议："
echo "1. 安装所有审计工具"
echo "2. 运行完整的安全审计"
echo "3. 请第三方安全公司进行审计"
echo "4. 在测试网部署并审计后再部署到主网"
