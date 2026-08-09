# 测试文件

# arbitrage_bot.py 测试
# tests/test_arbitrage_bot.py

import pytest
from unittest.mock import Mock, patch
from engine.arbitrage_bot import ArbitrageBot
from engine.web3_helper import Web3Helper
from engine.constants import HOODFLOW_CONFIG, CROSS_CHAIN_CONFIG


@pytest.fixture
def mock_helper():
    """Mock Web3Helper"""
    helper = Mock(spec=Web3Helper)

    # Mock get_cross_chain_swap_quote
    helper.get_cross_chain_swap_quote = Mock(return_value={
        "src_chain_id": 7565164,
        "src_token": "SOL",
        "dest_chain_id": 4663,
        "dest_token": "ETH",
        "amount_raw": "1000000000",
        "estimated_output": "980000000",
        "estimated_fee": "20000000",
        "profit": "960000000",
        "profit_percentage": 9.6,
        "min_profit_threshold": 3.0,
        "quote": {}
    })

    # Mock execute_cross_chain_bridge
    helper.execute_cross_chain_bridge = Mock(return_value={
        "tx_hash": "0x...",
        "src_chain": "Solana",
        "dest_chain": "Robinhood Chain",
        "profit": 960000000,
        "profit_percentage": 9.6
    })

    return helper


@pytest.fixture
def arbitrage_bot(mock_helper):
    """创建ArbitrageBot实例"""
    return ArbitrageBot(mock_helper)


def test_detect_arbitrage_opportunity_found(mock_helper, arbitrage_bot):
    """测试检测到套利机会"""
    opportunity = arbitrage_bot.detect_arbitrage_opportunity(
        src_chain_id=7565164,
        src_token="SOL",
        dest_chain_id=4663,
        dest_token="ETH",
        amount_raw="1000000000",
        recipient="0x..."
    )

    assert opportunity["opportunity_found"] is True
    assert opportunity["src_token"] == "SOL"
    assert opportunity["dest_token"] == "ETH"
    assert opportunity["profit_percentage"] == 9.6
    assert opportunity["min_profit_threshold"] == 3.0
    assert mock_helper.get_cross_chain_swap_quote.called


def test_detect_arbitrage_opportunity_not_found(mock_helper, arbitrage_bot):
    """测试未检测到套利机会"""
    # 设置利润率低于阈值
    mock_helper.get_cross_chain_swap_quote.return_value = {
        "src_chain_id": 7565164,
        "src_token": "SOL",
        "dest_chain_id": 4663,
        "dest_token": "ETH",
        "amount_raw": "1000000000",
        "estimated_output": "970000000",
        "estimated_fee": "30000000",
        "profit": "940000000",
        "profit_percentage": 9.4,
        "min_profit_threshold": 3.0,
        "quote": {}
    }

    opportunity = arbitrage_bot.detect_arbitrage_opportunity(
        src_chain_id=7565164,
        src_token="SOL",
        dest_chain_id=4663,
        dest_token="ETH",
        amount_raw="1000000000",
        recipient="0x..."
    )

    assert opportunity["opportunity_found"] is False
    assert opportunity["profit_percentage"] == 9.4


def test_execute_arbitrage(mock_helper, arbitrage_bot):
    """测试执行套利"""
    opportunity = {
        "opportunity_found": True,
        "src_chain_id": 7565164,
        "src_token": "SOL",
        "dest_chain_id": 4663,
        "dest_token": "ETH",
        "amount_raw": "1000000000",
        "estimated_output": "980000000",
        "estimated_fee": "20000000",
        "profit": "960000000",
        "profit_percentage": 9.6,
        "min_profit_threshold": 3.0,
        "quote": {}
    }

    result = arbitrage_bot.execute_arbitrage(opportunity)

    assert mock_helper.execute_cross_chain_bridge.called
    assert result["src_chain"] == "Solana"
    assert result["profit_percentage"] == 9.6


def test_execute_arbitrage_no_opportunity(mock_helper, arbitrage_bot):
    """测试无套利机会时执行套利"""
    opportunity = {
        "opportunity_found": False,
        "profit_percentage": 1.0,
        "min_profit_threshold": 3.0
    }

    result = arbitrage_bot.execute_arbitrage(opportunity)

    assert result["status"] == "No opportunity found"
    assert result["profit_percentage"] == 1.0


def test_scan_all_chains(mock_helper, arbitrage_bot):
    """测试扫描所有链"""
    # Mock get_cross_chain_swap_quote
    mock_helper.get_cross_chain_swap_quote.return_value = {
        "src_chain_id": 7565164,
        "src_token": "SOL",
        "dest_chain_id": 4663,
        "dest_token": "ETH",
        "amount_raw": "1000000000",
        "estimated_output": "980000000",
        "estimated_fee": "20000000",
        "profit": "960000000",
        "profit_percentage": 9.6,
        "min_profit_threshold": 3.0,
        "quote": {}
    }

    # Mock execute_cross_chain_bridge
    mock_helper.execute_cross_chain_bridge.return_value = {
        "tx_hash": "0x...",
        "src_chain": "Solana",
        "dest_chain": "Robinhood Chain",
        "profit": 960000000,
        "profit_percentage": 9.6
    }

    # 异步运行扫描
    import asyncio
    asyncio.run(arbitrage_bot.scan_all_chains())
