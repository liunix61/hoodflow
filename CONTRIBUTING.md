# Contributing to HoodFlow

感谢您对HoodFlow的兴趣！我们欢迎所有形式的贡献。

---

## 📋 目录

1. [行为准则](#行为准则)
2. [开发流程](#开发流程)
3. [代码规范](#代码规范)
4. [提交规范](#提交规范)
5. [Pull Request流程](#pull-request流程)

---

## 行为准则

- ✅ 尊重所有贡献者
- ✅ 使用礼貌和建设性的语言
- ✅ 接受批评但不进行人身攻击
- ✅ 关注对社区最有利的事情

---

## 开发流程

### 1. Fork项目
```bash
git clone https://github.com/your-username/hoodflow.git
cd hoodflow
```

### 2. 创建分支
```bash
git checkout -b feature/your-feature-name
```

### 3. 安装依赖
```bash
make install
# 或
cd engine && pip install -r requirements.txt
```

### 4. 开发和测试
```bash
# 运行测试
make test

# 代码风格检查
make lint

# 代码格式化
make format
```

### 5. 提交更改
```bash
git add .
git commit -m "feat: add your feature"
git push origin feature/your-feature-name
```

### 6. 创建Pull Request
在GitHub上创建Pull Request，详细描述你的更改。

---

## 代码规范

### Python代码规范

**1. 使用Black格式化**
```bash
make format
```

**2. 遵循PEP 8规范**
- 每行不超过100个字符
- 使用4个空格缩进
- 导入语句分组：标准库 -> 第三方库 -> 本地模块

**3. 添加类型提示**
```python
def calculate_optimal_price(token_address: str) -> dict:
    """计算最优价格"""
    # 实现
    pass
```

**4. 添加文档字符串**
```python
def calculate_optimal_price(token_address: str) -> dict:
    """
    计算最优做市价格

    Args:
        token_address: 代币地址

    Returns:
        最优价格信息

    Example:
        >>> helper = Web3Helper()
        >>> price = calculate_optimal_price("0x...")
        >>> print(price)
    """
    pass
```

**5. 错误处理**
```python
try:
    result = helper.execute_market_maker_trade(...)
except Exception as e:
    logger.error(f"交易失败: {e}")
    raise
```

---

## 提交规范

使用Conventional Commits规范：

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 类型（Type）

- `feat`: 新功能
- `fix`: 错误修复
- `docs`: 文档更新
- `style`: 代码格式（不影响功能）
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建/工具相关

### 示例

```bash
# 新功能
git commit -m "feat(market-maker): add support for multi-chain arbitrage"

# 错误修复
git commit -m "fix(risk-manager): correct slippage calculation"

# 文档更新
git commit -m "docs: update README with new features"

# 代码重构
git commit -m "refactor(engine): improve code structure"

# 测试
git commit -m "test(market-maker): add unit tests for price calculation"

# 构建
git commit -m "chore: update dependencies"
```

---

## Pull Request流程

### 1. 确保通过所有检查

```bash
# 运行测试
make test

# 代码风格检查
make lint
```

### 2. 描述PR

在PR描述中包含：
- ✅ 问题描述
- ✅ 解决方案
- ✅ 测试计划
- ✅ 截图（如果适用）

### 3. 等待审核

- 维护者会审核你的PR
- 可能需要修改
- 审核通过后会合并

### 4. 更新文档

如果更改涉及功能或API，更新相关文档。

---

## 测试

### 运行测试

```bash
# 运行所有测试
make test

# 运行特定测试
cd engine && pytest tests/test_market_maker.py -v

# 运行覆盖率测试
make test
```

### 测试要求

- ✅ 所有测试必须通过
- ✅ 新功能需要添加测试
- ✅ 测试覆盖率 > 80%

---

## 智能合约开发

### 合约规范

1. **使用OpenZeppelin合约库**
2. **遵循Solidity最佳实践**
3. **添加详细的注释**
4. **通过测试**

### 合约示例

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HoodFlowStrategy is ERC20, Ownable {
    constructor() ERC20("HoodFlow", "HOOD") Ownable(msg.sender) {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }
}
```

---

## 联系方式

- **GitHub Issues**: https://github.com/hoodflow/hoodflow/issues
- **Discord**: discord.gg/hoodflow
- **Twitter**: @hoodflow
- **Email**: dev@hoodflow.io

---

**感谢你的贡献！** 🎉
