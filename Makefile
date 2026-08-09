# HoodFlow - Makefile
# 工程化构建脚本

.PHONY: help install test lint format clean docker-build docker-run

# 默认目标
help:
	@echo "HoodFlow - Makefile 命令"
	@echo ""
	@echo "使用方法: make <target>"
	@echo ""
	@echo "可用命令:"
	@echo "  install      - 安装依赖"
	@echo "  test         - 运行测试"
	@echo "  lint         - 代码风格检查"
	@echo "  format       - 代码格式化"
	@echo "  clean        - 清理构建文件"
	@echo "  docker-build - 构建Docker镜像"
	@echo "  docker-run   - 运行Docker容器"

# 安装依赖
install:
	@echo "安装依赖..."
	cd engine && pip install -r requirements.txt

# 运行测试
test:
	@echo "运行测试..."
	cd engine && pytest tests/ -v --cov=. --cov-report=html --cov-report=term

# 代码风格检查
lint:
	@echo "代码风格检查..."
	cd engine && flake8 . --max-line-length=100 --ignore=E203,W503
	cd engine && mypy . --ignore-missing-imports

# 代码格式化
format:
	@echo "代码格式化..."
	cd engine && black .
	cd engine && isort .

# 清理构建文件
clean:
	@echo "清理构建文件..."
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	find . -type f -name "*.pyo" -delete 2>/dev/null || true
	find . -type f -name ".coverage" -delete 2>/dev/null || true

# 构建Docker镜像
docker-build:
	@echo "构建Docker镜像..."
	docker build -t hoodflow:latest .

# 运行Docker容器
docker-run:
	@echo "运行Docker容器..."
	docker run --rm -it -v $(PWD)/engine:/app -e ROBINHOOD_CHAIN_RPC_URL="https://rpc.mainnet.chain.robinhood.com" hoodflow:latest python market_maker.py
