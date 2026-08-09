# HoodFlow - AI驱动的Web3做市商

> 基于robinhood-evm-mcp的Python MCP Client

**版本**: 1.0
**创建时间**: 2026-08-06
**最后更新**: 2026-08-06

---

## 📋 目录

1. [项目概述](#项目概述)
2. [核心价值](#核心价值)
3. [技术架构](#技术架构)
4. [快速开始](#快速开始)
5. [使用示例](#使用示例)
6. [文档](#文档)
7. [工程化](#工程化)
8. [路线图](#路线图)
9. [经济模型](#经济模型)
10. [社区共识](#社区共识)
11. [风险与治理](#风险与治理)
12. [联系与贡献](#联系与贡献)

---

## 项目概述

### 🎯 HoodFlow是什么？

**HoodFlow** 是一个基于 **robinhood-evm-mcp** 的 **Python MCP Client**，专门为 **Web3做市** 设计。

**核心思路**：
- ✅ **直接调用robinhood-evm-mcp的MCP工具**
- ✅ **无需重复开发MCP Server**
- ✅ **Python脚本实现做市逻辑**
- ✅ **在robinhood-evm-mcp仓库基础上开发测试**

---

### 📊 核心价值

| 价值维度 | 说明 |
|---------|------|
| **经济价值** | 降低门槛、提高效率、增加收益 |
| **社区价值** | 治理参与、策略贡献、生态建设 |
| **技术价值** | Python MCP Client、直接调用MCP工具、快速原型 |

---

### 🎯 关键特性

**基于robinhood-evm-mcp的核心能力**：

1. ✅ **16个MCP工具** - 完整的Web3交互能力
2. ✅ **跨链套利** - Robinhood Chain + Solana + Ethereum
3. ✅ **自动交易** - AI Agent自动执行买卖
4. ✅ **风险管理** - 滑点检查、利润阈值
5. ✅ **实时行情** - 历史价格图表、流动性深度

---

## 技术架构

### 🏗️ 架构设计

```
┌─────────────────────────────────────────────────────────────┐
│                    HoodFlow 架构                              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   Python做市商脚本                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  做市逻辑    │  │  套利检测    │  │  风险管理    │         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
└─────────┼────────────────┼────────────────┼─────────────────┘
          │                │                │
┌─────────▼────────────────▼────────────────▼─────────────────┐
│              robinhood-evm-mcp MCP Server                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ 16个MCP工具  │  │ Web3交互    │  │ 跨链桥接    │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└────────────────────────┼────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                    Robinhood Chain                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  MemeFactory │  │  ERC20      │  │  USDG       │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

---

## 快速开始

### 🚀 环境准备

**前置条件**：
- ✅ Python >= 3.9
- ✅ pip
- ✅ Git
- ✅ Robinhood Chain RPC URL
- ✅ 私钥（用于交易）

---

### 📦 安装依赖

```bash
# 方式1: 使用Makefile
make install

# 方式2: 手动安装
cd engine && pip install -r requirements.txt
```

---

### 🔧 配置环境变量

```bash
# 复制环境变量示例
cp engine/.env.example engine/.env

# 编辑环境变量文件
nano engine/.env
```

```env
# Robinhood Chain RPC
ROBINHOOD_CHAIN_RPC_URL="https://rpc.mainnet.chain.robinhood.com"

# 私钥
ROBINHOOD_CHAIN_PRIVATE_KEY="0x..."

# 做市商配置
MIN_PROFIT_MARGIN=0.01
RISK_TOLERANCE=0.8
MIN_LIQUIDITY_THRESHOLD=0.1
```

---

### 🚀 启动做市商

```bash
# 方式1: 使用Makefile
make run-market-maker

# 方式2: 使用启动脚本
cd engine && ./start.sh

# 方式3: 直接运行
cd engine && python3 market_maker.py
```

---

### 🧪 运行测试

```bash
# 运行所有测试
make test

# 运行特定测试
cd engine && pytest tests/test_market_maker.py -v

# 代码风格检查
make lint

# 代码格式化
make format
```

---

### 🔍 代码审计

```bash
# 运行代码审计脚本
./scripts/audit.sh

# 审计内容：
# - 代码风格检查（flake8、black、isort）
# - 类型检查（mypy）
# - 安全检查（敏感信息）
# - 智能合约检查（solhint）
# - 测试检查（pytest）
# - 依赖检查
# - Git检查
```

---

### 📦 部署智能合约

```bash
# 部署Solana版本
./scripts/deploy.sh

# 部署Uniswap V2版本（使用Hardhat）
npx hardhat run scripts/deploy-uniswap.js --network mainnet

# 或使用Remix IDE部署
# 1. 打开 Remix IDE: https://remix.ethereum.org/
# 2. 选择 File Browser -> contracts -> HoodFlowUniswapV2Strategy.sol
# 3. 点击 Compile -> Compile HoodFlowUniswapV2Strategy.sol
# 4. 点击 Deploy -> Deploy to Environment -> Injected Provider - MetaMask
# 5. 连接 Ethereum 钱包
# 6. 点击 Deploy
```

---

## 使用示例

### 示例1: 查询余额

```python
from web3_helper import Web3Helper

# 初始化
helper = Web3Helper()

# 查询ETH余额
balance = helper.get_evm_balance("0x...")
print(f"ETH Balance: {balance}")

# 查询USDG余额
usdg_balance = helper.get_evm_balance("0x...", "USDG")
print(f"USDG Balance: {usdg_balance}")
```

---

### 示例2: 计算最优价格

```python
from web3_helper import Web3Helper

# 初始化
helper = Web3Helper()

# 计算最优价格
optimal_price = helper.calculate_optimal_price("0x...")
print(f"Optimal Price: {optimal_price}")
```

---

### 示例3: 执行做市交易

```python
from web3_helper import Web3Helper

# 初始化
helper = Web3Helper()

# 执行做市交易
result = helper.execute_market_maker_trade(
    token_address="0x...",
    trade_type="buy",
    amount=0.1
)
print(f"Trade Result: {result}")
```

---

### 示例4: 扫描并做市

```python
from web3_helper import Web3Helper

# 初始化
helper = Web3Helper()

# 扫描并做市
result = helper.scan_and_trade("0x...")
print(f"Scan Result: {result}")
```

---

## 文档

### 📚 核心文档

1. **[Keep平台使用指南](doc/keep-platform-guide.md)**
   - Keep平台完整使用指南
   - Token Launch流程
   - 价格保护机制

2. **[HoodFlow系统架构文档](doc/hoodflow-architecture.md)**
   - 系统架构设计
   - 16个MCP工具详解
   - AI做市商设计
   - 自动化套利系统
   - 经济模型

3. **[MCP Tools Reference](doc/mcp-tools-reference.md)**
   - robinhood-evm-mcp的16个工具详解
   - 使用示例
   - 参数说明

---

### 🌐 Vercel自动化部署

#### 方式1: 使用Vercel CLI

```bash
# 1. 安装Vercel CLI
npm i -g vercel

# 2. 登录Vercel
vercel login

# 3. 部署到Vercel
vercel --prod

# 4. 配置环境变量
vercel env add DATABASE_URL
vercel env add API_KEY
```

#### 方式2: 使用GitHub集成

1. **连接GitHub仓库**：
   - 访问 https://vercel.com/new
   - 导入 `liunix61/hoodflow` 仓库

2. **配置项目**：
   - Framework Preset: Vite
   - Root Directory: `.` (根目录)
   - Build Command: `npm run build`
   - Output Directory: `dist`

3. **设置环境变量**：
   - `DATABASE_URL`: PostgreSQL连接字符串
   - `API_KEY`: API密钥
   - `ROBINHOOD_CHAIN_RPC_URL`: Robinhood Chain RPC地址

4. **部署**：
   - 点击 "Deploy"
   - Vercel自动部署到全球CDN

#### 方式3: 使用Vercel Dashboard

1. **创建新项目**：
   - 访问 https://vercel.com/dashboard
   - 点击 "Add New Project"

2. **导入GitHub仓库**：
   - 选择 `liunix61/hoodflow`
   - 点击 "Import"

3. **配置设置**：
   - Framework: Vite
   - Root Directory: `.`
   - Build Command: `npm run build`
   - Output Directory: `dist`

4. **部署**：
   - 点击 "Deploy"
   - 等待部署完成

#### 部署优势

- ✅ **自动CI/CD**: 每次push到main分支自动部署
- ✅ **全球CDN**: 自动分发到全球节点
- ✅ **HTTPS**: 自动配置SSL证书
- ✅ **域名绑定**: 支持自定义域名
- ✅ **环境管理**: 支持多环境（开发/测试/生产）
- ✅ **性能监控**: 内置性能监控和分析

#### 环境变量配置

在Vercel Dashboard中配置以下环境变量：

```bash
# 数据库配置
DATABASE_URL=postgresql://user:***@host:5432/database

# API配置
API_KEY=your_a...n
# Web3配置
ROBINHOOD_CHAIN_RPC_URL=https://rpc.mainnet.chain.robinhood.com

# Node.js版本
NODE_VERSION=18
```

#### 自定义域名

1. **添加域名**：
   - 在Vercel Dashboard中点击 "Domains"
   - 添加 `hoodflow.ai` 或自定义域名

2. **配置DNS**：
   - 在域名注册商处添加DNS记录
   - 类型: CNAME
   - 值: `cname.vercel-dns.com`

3. **验证**：
   - Vercel自动验证域名配置
   - 等待SSL证书自动配置

---

## 工程化

### 🛠️ 项目结构

```
hoodflow/
├── README.md               # 项目说明文档
├── CONTRIBUTING.md         # 贡献指南
├── LICENSE                 # MIT许可证
├── .gitignore              # Git忽略文件
├── Makefile                # 工程化构建脚本
├── STRUCTURE_FIX.md        # 结构修正说明
├── engine/                 # 核心引擎目录
│   ├── market_maker.py     # AI做市商
│   ├── arbitrage_bot.py    # 多链套利机器人
│   ├── risk_manager.py     # 风险管理器
│   ├── requirements.txt    # 依赖列表
│   ├── .env.example        # 环境变量示例
│   ├── start.sh            # 启动脚本
│   ├── mcp_server.py       # MCP Server
│   ├── constants.py        # 常量配置
│   ├── web3_helper.py      # Web3工具
│   └── abi_manager.py      # ABI管理
├── doc/                    # 文档目录
│   ├── keep-platform-guide.md
│   ├── hoodflow-architecture.md
│   └── mcp-tools-reference.md
├── contracts/              # 智能合约目录
│   └── HoodFlowStrategy.sol
├── scripts/                # 脚本目录
│   ├── deploy.sh
│   └── audit.sh
└── tests/                  # 测试目录
    ├── test_market_maker.py
    ├── test_arbitrage_bot.py
    └── test_risk_manager.py
```

### 📦 Makefile命令

```bash
make help          # 显示帮助信息
make install       # 安装依赖
make test          # 运行测试
make lint          # 代码风格检查
make format        # 代码格式化
make clean         # 清理构建文件
make docker-build  # 构建Docker镜像
make docker-run    # 运行Docker容器
```

### 🧪 测试

```bash
# 运行所有测试
make test

# 运行覆盖率测试
make test --cov=engine --cov-report=html
```

---

## 路线图

### 📅 Phase 1: 创世启动（Month 1）

- [x] 项目设计（基于robinhood-evm-mcp）
- [x] MCP Client开发
- [x] 做市商脚本开发
- [x] 套利机器人开发
- [x] 风险管理器开发
- [x] 工程化配置（Makefile、.gitignore等）
- [ ] 测试网部署
- [ ] 社区测试

---

### 📅 Phase 2: 主网启动（Month 2）

- [ ] 主网部署
- [ ] Keep Launchpad融资
- [ ] 激励计划启动
- [ ] 社区建设
- [ ] 媒体推广

---

### 📅 Phase 3: 生态扩张（Month 3-6）

- [ ] 跨链桥接
- [ ] 多链支持
- [ ] DAO治理启动
- [ ] 策略贡献系统
- [ ] Bug Bounty计划
- [ ] 全球合作伙伴

---

## 经济模型

### 💰 代币经济

| 代币类型 | 总供应量 | 分配比例 |
|---------|---------|---------|
| **$HOOD** | 1,000,000,000 | 100% |
| - 创始人 | 10% | 100,000,000 |
| - 团队 | 15% | 150,000,000 |
| - 治理 | 20% | 200,000,000 |
| - 流动性挖矿 | 20% | 200,000,000 |
| - 奖励池 | 20% | 200,000,000 |
| - 基金会 | 10% | 100,000,000 |

---

### 📈 收益分成

- ✅ **交易手续费**：2% → 20%归$HOOD池
- ✅ **套利利润**：10%归$HOOD池
- ✅ **流动性奖励**：LP token奖励$HOOD
- ✅ **质押奖励**：质押$HOOD获得额外收益

---

## 社区共识

### 🎯 策略1: 开源透明

- ✅ 代码GitHub开源
- ✅ 链上验证
- ✅ 实时监控
- ✅ 透明报告

### 🎯 策略2: 治理参与

- ✅ DAO治理
- ✅ 策略贡献
- ✅ Bug Bounty
- ✅ 大使计划

### 🎯 策略3: 激励机制

- ✅ 流动性挖矿
- ✅ 交易奖励
- ✅ 质押奖励
- ✅ 推荐奖励

---

## 风险与治理

### ⚠️ 风险评估

| 风险类型 | 缓解措施 |
|---------|---------|
| 市场风险 | 多链分散、智能风控、社区共识 |
| 技术风险 | 多重审计、多层备份、快速响应 |
| 监管风险 | 合规设计、KYC/AML、法律顾问 |
| 安全风险 | 多重审计、Bug Bounty、安全监控 |

---

## 联系与贡献

### 📞 联系方式

- **Website**: https://hoodflow.io
- **Twitter**: @hoodflow
- **Telegram**: @hoodflow
- **Discord**: discord.gg/hoodflow
- **GitHub**: https://github.com/hoodflow
- **文档**: https://docs.hoodflow.io

### 🤝 贡献

欢迎贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详情。

---

## 许可证

MIT License

---

## 致谢

感谢以下开源项目和社区：

- [robinhood-evm-mcp](https://github.com/aashu91/robinhood-evm-mcp) - 核心技术基础
- [web3.py](https://github.com/ethereum/web3.py) - Web3 Python库
- [MCP Protocol](https://modelcontextprotocol.io) - 模型上下文协议
- [OpenZeppelin](https://openzeppelin.com) - 智能合约库
- [Solana](https://solana.com) - 跨链支持

---

**版本**: 1.0
**维护者**: HoodFlow团队
**最后更新**: 2026-08-06
**重要说明**：HoodFlow是基于robinhood-evm-mcp的Python MCP Client，直接调用MCP工具实现Web3做市！
