# 测试文件

# market_maker.py 测试
# tests/test_market_maker.py

import pytest
from unittest.mock import Mock, patch
from engine.market_maker import MarketMaker
from engine.web3_helper import Web3Helper
from engine.constants import HOODFLOW_CONFIG


@pytest.fixture
def mock_helper():
    """Mock Web3Helper"""
    helper = Mock(spec=Web3Helper)

    # Mock analyze_liquidity_depth
    helper.analyze_liquidity_depth = Mock(return_value={
        "token_address": "0x...",
        "token_reserves": 1000000,
        "eth_reserves": 500000,
        "depth_tokens": 100000,
        "depth_eth": 50000,
        "liquidity_score": 2.0
    })

    # Mock calculate_optimal_price
    helper.calculate_optimal_price = Mock(return_value={
        "token_address": "0x...",
        "risk_tolerance": 0.8,
        "min_profit_margin": 0.01,
        "reserves_ratio": 2.0,
        "optimal_price": 1.5,
        "liquidity_score": 2.0,
        "recommendation": "BUY"
    })

    # Mock buy_meme_coin
    helper.buy_meme_coin = Mock(return_value={
        "tx_hash": "0x...",
        "output_amount": 1500
    })

    # Mock sell_meme_coin
    helper.sell_meme_coin = Mock(return_value={
        "tx_hash": "0x...",
        "output_amount": 333.33
    })

    return helper


@pytest.fixture
def market_maker(mock_helper):
    """创建MarketMaker实例"""
    return MarketMaker(mock_helper)


def test_calculate_optimal_price(market_maker, mock_helper):
    """测试最优价格计算"""
    result = market_maker.calculate_optimal_price("0x...")

    assert result["token_address"] == "0x..."
    assert result["optimal_price"] == 1.5
    assert result["recommendation"] == "BUY"
    assert mock_helper.analyze_liquidity_depth.called


def test_execute_market_maker_trade_buy(market_maker, mock_helper):
    """测试执行做市交易（买入）"""
    result = market_maker.execute_market_maker_trade(
        token_address="0x...",
        trade_type="buy",
        amount=0.1
    )

    assert mock_helper.buy_meme_coin.called
    assert result["optimal_price"] == 1.5


def test_execute_market_maker_trade_sell(market_maker, mock_helper):
    """测试执行做市交易（卖出）"""
    result = market_maker.execute_market_maker_trade(
        token_address="0x...",
        trade_type="sell",
        amount=1000
    )

    assert mock_helper.sell_meme_coin.called
    assert result["optimal_price"] == 1.5


def test_execute_market_maker_trade_invalid_type(market_maker):
    """测试无效的交易类型"""
    with pytest.raises(ValueError):
        market_maker.execute_market_maker_trade(
            token_address="0x...",
            trade_type="invalid",
            amount=0.1
        )


def test_scan_and_trade_buy(market_maker, mock_helper):
    """测试扫描并做市（买入）"""
    market_maker.scan_and_trade("0x...")

    assert mock_helper.calculate_optimal_price.called
    assert mock_helper.buy_meme_coin.called


def test_scan_and_trade_sell(market_maker, mock_helper):
    """测试扫描并做市（卖出）"""
    mock_helper.calculate_optimal_price.return_value = {
        "token_address": "0x...",
        "risk_tolerance": 0.8,
        "min_profit_margin": 0.01,
        "reserves_ratio": 0.5,
        "optimal_price": 0.5,
        "liquidity_score": 2.0,
        "recommendation": "SELL"
    }

    market_maker.scan_and_trade("0x...")

    assert mock_helper.sell_meme_coin.called
