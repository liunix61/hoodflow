# 测试文件

# risk_manager.py 测试
# tests/test_risk_manager.py

import pytest
from unittest.mock import Mock
from engine.risk_manager import RiskManager
from engine.web3_helper import Web3Helper
from engine.constants import HOODFLOW_CONFIG


@pytest.fixture
def mock_helper():
    """Mock Web3Helper"""
    helper = Mock(spec=Web3Helper)

    # Mock calculate_optimal_price
    helper.calculate_optimal_price = Mock(return_value={
        "optimal_price": 1.5,
        "liquidity_score": 2.0
    })

    # Mock analyze_liquidity_depth
    helper.analyze_liquidity_depth = Mock(return_value={
        "token_reserves": 1000000,
        "eth_reserves": 500000,
        "liquidity_score": 2.0
    })

    return helper


@pytest.fixture
def risk_manager(mock_helper):
    """创建RiskManager实例"""
    return RiskManager(mock_helper)


def test_check_slippage_buy(mock_helper, risk_manager):
    """测试买入滑点检查（通过）"""
    result = risk_manager.check_slippage(
        token_address="0x...",
        trade_type="buy",
        amount=0.1,
        max_slippage=0.01
    )

    assert result is True
    assert mock_helper.calculate_optimal_price.called


def test_check_slippage_sell(mock_helper, risk_manager):
    """测试卖出滑点检查（通过）"""
    result = risk_manager.check_slippage(
        token_address="0x...",
        trade_type="sell",
        amount=1000,
        max_slippage=0.01
    )

    assert result is True


def test_check_slippage_fail(mock_helper, risk_manager):
    """测试滑点检查（失败）"""
    # 设置滑点超过阈值
    mock_helper.calculate_optimal_price.return_value = {
        "optimal_price": 1.05,
        "liquidity_score": 2.0
    }

    result = risk_manager.check_slippage(
        token_address="0x...",
        trade_type="buy",
        amount=0.1,
        max_slippage=0.01
    )

    assert result is False


def test_check_profit_margin_buy(mock_helper, risk_manager):
    """测试买入利润边际检查（通过）"""
    result = risk_manager.check_profit_margin(
        token_address="0x...",
        trade_type="buy",
        amount=0.1,
        min_profit_margin=0.01
    )

    assert result is True


def test_check_profit_margin_sell(mock_helper, risk_manager):
    """测试卖出利润边际检查（通过）"""
    result = risk_manager.check_profit_margin(
        token_address="0x...",
        trade_type="sell",
        amount=1000,
        min_profit_margin=0.01
    )

    assert result is True


def test_check_profit_margin_buy_fail(mock_helper, risk_manager):
    """测试利润边际检查（失败）"""
    # 设置利润边际低于阈值
    mock_helper.calculate_optimal_price.return_value = {
        "optimal_price": 1.005,
        "liquidity_score": 2.0
    }

    result = risk_manager.check_profit_margin(
        token_address="0x...",
        trade_type="buy",
        amount=0.1,
        min_profit_margin=0.01
    )

    assert result is False


def test_check_liquidity(mock_helper, risk_manager):
    """测试流动性检查（通过）"""
    result = risk_manager.check_liquidity(
        token_address="0x...",
        min_liquidity_threshold=0.1
    )

    assert result is True
    assert mock_helper.analyze_liquidity_depth.called


def test_check_liquidity_fail(mock_helper, risk_manager):
    """测试流动性检查（失败）"""
    # 设置流动性评分低于阈值
    mock_helper.analyze_liquidity_depth.return_value = {
        "token_reserves": 100000,
        "eth_reserves": 50000,
        "liquidity_score": 0.05
    }

    result = risk_manager.check_liquidity(
        token_address="0x...",
        min_liquidity_threshold=0.1
    )

    assert result is False


def test_pre_trade_check_pass(mock_helper, risk_manager):
    """测试交易前综合检查（全部通过）"""
    # Mock所有检查通过
    mock_helper.calculate_optimal_price.return_value = {
        "optimal_price": 1.5,
        "liquidity_score": 2.0
    }
    mock_helper.analyze_liquidity_depth.return_value = {
        "token_reserves": 1000000,
        "eth_reserves": 500000,
        "liquidity_score": 2.0
    }

    result = risk_manager.pre_trade_check(
        token_address="0x...",
        trade_type="buy",
        amount=0.1
    )

    assert result["passed"] is True


def test_pre_trade_check_fail(mock_helper, risk_manager):
    """测试交易前综合检查（部分失败）"""
    # Mock滑点检查失败
    mock_helper.calculate_optimal_price.return_value = {
        "optimal_price": 1.05,
        "liquidity_score": 2.0
    }

    result = risk_manager.pre_trade_check(
        token_address="0x...",
        trade_type="buy",
        amount=0.1
    )

    assert result["passed"] is False
