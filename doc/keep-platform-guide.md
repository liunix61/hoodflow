# Keep平台使用指南

> 文档创建时间：2026-08-06
> 最后更新：2026-08-06

---

## 📋 目录

1. [平台概述](#平台概述)
2. [Token Launch流程](#token-launch流程)
3. [Keepedia项目发现](#keepedia项目发现)
4. [钱包连接](#钱包连接)
5. [创建项目](#创建项目)
6. [Launch参数详解](#launch参数详解)
7. [价格保护机制](#价格保护机制)
8. [常见问题](#常见问题)

---

## 平台概述

### 🎯 Keep是什么？

**Keep** 是一个面向AI构建者的代币发行平台，基于 **Solana** 区块链。

**核心功能**：
- ✅ Token Launch（代币发行）
- ✅ Keepedia（项目发现与社区估值）
- ✅ Points（积分系统）

**关键特性**：
- 🛡️ Backer退款保护（价格保护）
- 🔒 参数不可变（deploy时锁定）
- 💰 Liquidity不可撤回
- 📝 每次编辑可追溯

---

## Token Launch流程

### 🚀 完整流程

```
1. 连接钱包（Solana）
   ↓
2. 填写项目信息
   ↓
3. 选择Access模式
   ↓
4. 设置Launch时间
   ↓
5. 确认Fixed Parameters
   ↓
6. 部署（~0.33 SOL）
   ↓
7. 开始融资（24h窗口）
   ↓
8. 价格保护检查（D+7, D+30）
   ↓
9. 交易/退款
```

---

## Keepedia项目发现

### 📊 平台统计

- **总项目数**：356个
- **Robinhood标签项目**：约20个
- **估值范围**：$1M - $50M

### 🔍 项目列表

**Robinhood标签下的热门项目**：

| 项目 | 估值 | 状态 | Claimed by | 描述 |
|------|------|------|------------|------|
| IN | $50M | ✅ Claimed | @insidersdotbot | Polymarket交易AI agent |
| Moonlist | $8.9M | ❌ Unclaimed | - | 机构级AI加密分析 |
| SmartSentinels | $2.0M | ❌ Unclaimed | - | AI agents去中心化劳动力 |
| Wrkr | $1.0M | ✅ Claimed | @wrkrdev | VibeOps computer |
| Monvera | $1.0M | ✅ Claimed | @monvera_best | AI broker代币化资产 |
| Wizz | - | ❌ Unclaimed | - | 超智能agent基础设施 |

---

## 钱包连接

### 🔗 连接步骤

1. **访问Keep**：https://keep.coffee
2. **点击Connect wallet**
3. **选择钱包**：
   - Phantom
   - Solflare
   - Backpack
   - Math Wallet
4. **授权连接**

### ⚠️ 注意事项

- ✅ 必须连接Solana钱包
- ✅ 钱包需要有SOL余额（用于部署）
- ✅ 建议使用主网钱包

---

## 创建项目

### 📝 表单填写步骤

#### **Step 1: Token信息**

| 字段 | 说明 | 示例 |
|------|------|------|
| **Name** | Token名称 | HoodFlow |
| **Symbol** | Token符号（8字符以内，大写） | HOOD |
| **Tagline** | 一句话介绍（80字符） | The self-healing liquidity engine for Robinhood Chain |

**重要规则**：
- ✅ Symbol必须以字母开头
- ✅ Max 8字符
- ✅ 只能包含字母和数字
- ✅ 所有字符大写

---

#### **Step 2: Identity信息**

**Logo上传**：
- 格式：PNG / SVG / WebP / JPEG
- 尺寸：512×512
- 最大文件大小：10MB

**Description（Markdown支持）**：
- 最大长度：4000字符
- 支持Markdown语法
- 可插入图片

**Links**：
- Website（必填）
- X / Twitter（必填）
- Telegram（可选）
- Discord（可选）

**示例Markdown**：
```markdown
# HoodFlow

The self-healing liquidity engine for Robinhood Chain.

## Features
- AI-driven market making
- Automated arbitrage
- Real-time price discovery

## Roadmap
- [x] Phase 1: Launchpad
- [ ] Phase 2: Cross-chain bridge
- [ ] Phase 3: DAO governance
```

---

#### **Step 3: Access模式**

| 模式 | 说明 | 适用场景 |
|------|------|----------|
| **Public** | 任何人可deposit | 公开融资 |
| **Private** | 白名单仅 | 独家融资 |
| **Hybrid** | 先白名单，后public | 限量+放量 |

**Hybrid模式参数**：
- Whitelist allocation：白名单额度（最多20,000 USDC）
- Whitelist max / wallet：白名单单钱包上限
- Public max / wallet：公开单钱包上限
- Whitelist addresses：白名单地址列表

---

#### **Step 4: Launch时间**

| 选项 | 说明 |
|------|------|
| **Immediately** | 立即开始融资 |
| **In 1 day** | 1天后开始 |
| **In 3 days** | 3天后开始 |
| **In 7 days** | 7天后开始 |
| **Custom** | 自定义天数（0-7天） |

---

#### **Step 5: Founder**

- **Receive funding on success + token vest**
- 自动从连接的钱包填充
- 不可修改

---

#### **Step 6: Fixed Parameters（不可修改）**

| 参数 | 默认值 | 说明 |
|------|--------|------|
| **Raise target** | 20,000 USDC | 融资目标 |
| **Window** | 24h max | 融资窗口期 |
| **Token supply** | 1,000,000,000 | 代币总供应量 |
| **Allocation** | 60% / 30% / 10% | 分配比例 |
| **Price checks** | D+7, D+30 | 价格检查日期 |
| **Threshold** | TWAP-1h ≥ 0.85× | 价格阈值 |

**分配比例说明**：
- **60%**: Backers（投资者）
- **30%**: Team（团队）
- **10%**: Treasury（国库）

---

#### **Step 7: Token mint address**

- ✅ **自动生成**
- ✅ **必须以.keep结尾**
- ✅ **Reserving your mint…**

**示例**：
```
HoodFlow…keep
```

---

#### **Step 8: Deploy**

**部署成本**：
- **~0.33 SOL**
  - 0.3 deposit（可退款，扣除设置租金）
  - ~0.03 network

**部署后**：
- ✅ Mint authority撤销
- ✅ 所有参数不可变
- ✅ Liquidity无法撤回
- ✅ 开始融资窗口

---

## Launch参数详解

### 💰 融资目标

**Raise target**: 20,000 USDC

**说明**：
- 最小融资目标：20,000 USDC
- 最大融资目标：20,000 USDC（固定）
- 超额认购：不限制
- 未达标：退款所有backer

---

### ⏱️ 融资窗口

**Window**: 24h max

**说明**：
- 融资窗口期：24小时
- 超过24小时：融资自动结束
- 未达标：退款所有backer

---

### 🪙 代币供应量

**Token supply**: 1,000,000,000

**说明**：
- 总供应量：10亿
- Mint authority：已撤销
- 无通胀：固定供应

---

### 📊 分配比例

**Allocation**: 60% / 30% / 10%

| 分配 | 数量 | 说明 |
|------|------|------|
| **Backers** | 600,000,000 | 投资者获得 |
| **Team** | 300,000,000 | 团队获得 |
| **Treasury** | 100,000,000 | 国库保留 |

---

### 📅 价格检查

**Price checks**: D+7, D+30

**说明**：
- **D+7**：第7天价格检查
- **D+30**：第30天价格检查
- **TWAP-1h ≥ 0.85×**：1小时TWAP ≥ 85% Launch Price

**价格检查结果**：
- ✅ 两个检查都通过：继续交易
- ❌ 任意检查失败：退款所有backer（USDC）

---

### 🎯 价格阈值

**Threshold**: TWAP-1h ≥ 0.85×

**说明**：
- **TWAP-1h**：过去1小时简单移动平均价
- **0.85×**：Launch Price的85%
- **≥**：至少达到85%

**示例**：
- Launch Price: $1.00
- D+7 TWAP-1h: $0.90（90%）→ ✅ 通过
- D+30 TWAP-1h: $0.80（80%）→ ❌ 失败（退款）

---

## 价格保护机制

### 🛡️ Backer退款保护

**机制说明**：

1. **Deposit阶段**：
   - Backer deposit USDC
   - 获得Token份额（基于融资进度）

2. **价格检查阶段**：
   - D+7检查：TWAP-1h ≥ 0.85× Launch Price
   - D+30检查：TWAP-1h ≥ 0.85× Launch Price

3. **退款条件**：
   - ❌ 任意一个检查失败
   - ✅ 全额退款USDC（无手续费）

4. **退款池**：
   - Liquidity无法撤回
   - USDC退款从流动性池中提取

**退款流程**：
```
Backer deposit USDC
   ↓
融资完成
   ↓
价格检查
   ↓
通过？→ 继续交易
   ↓
失败？→ 退款USDC
```

---

## 常见问题

### ❓ Q1: 部署成本是多少？

**A**: ~0.33 SOL
- 0.3 deposit（可退款）
- ~0.03 network

---

### ❓ Q2: 如果融资未达标怎么办？

**A**: 所有backer全额退款USDC

---

### ❓ Q3: 参数部署后可以修改吗？

**A**: 不可以，所有参数不可变

---

### ❓ Q4: Token mint authority是否保留？

**A**: 不，deploy时立即撤销

---

### ❓ Q5: Liquidity可以撤回吗？

**A**: 不可以，liquidity被锁定

---

### ❓ Q6: Keep和Keepedia有什么区别？

**A**:
- **Keep**: Token Launch平台
- **Keepedia**: 项目发现与社区估值平台

---

### ❓ Q7: 需要什么条件才能创建项目？

**A**:
- ✅ 连接Solana钱包
- ✅ 钱包有SOL余额（0.33 SOL）
- ✅ 填写完整项目信息

---

### ❓ Q8: 可以修改项目信息吗？

**A**: 部署后可以，但会记录版本历史

---

### ❓ Q9: Token symbol有什么限制？

**A**:
- ✅ 最大8字符
- ✅ 只能字母和数字
- ✅ 必须大写
- ✅ 必须以字母开头

---

### ❓ Q10: Access模式如何选择？

**A**:
- **Public**: 公开融资，适合大多数项目
- **Private**: 白名单，适合独家融资
- **Hybrid**: 先白名单，后公开，适合限量+放量

---

## 📚 相关链接

- **Keep官网**: https://keep.coffee
- **Keepedia**: https://keep.coffee/keepedia
- **Solana**: https://solana.com
- **Phantom钱包**: https://phantom.app
- **Solflare钱包**: https://solflare.com

---

## 📞 获取帮助

- **Twitter**: @keepdotcoffee
- **Telegram**: @keepcoffeenow
- **GitHub**: https://github.com/keep-coffee
- **Status**: https://status.keep.coffee

---

**文档版本**: 1.0
**维护者**: HoodFlow团队
