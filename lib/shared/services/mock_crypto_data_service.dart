import 'package:flutter/material.dart';

import '../models/crypto_asset.dart';

class MockCryptoDataService {
  const MockCryptoDataService();

  static const List<CryptoAsset> _portfolioAssets = [
    CryptoAsset(
      name: 'Bitcoin',
      symbol: 'BTC',
      price: 63452.75,
      change: 1.8,
      holdings: 0.52,
      color: Color(0xFFF7931A),
      iconUrl: 'https://assets.coincap.io/assets/icons/btc@2x.png',
    ),
    CryptoAsset(
      name: 'Ethereum',
      symbol: 'ETH',
      price: 3324.20,
      change: 2.2,
      holdings: 4.8,
      color: Color(0xFF627EEA),
      iconUrl: 'https://assets.coincap.io/assets/icons/eth@2x.png',
    ),
    CryptoAsset(
      name: 'Solana',
      symbol: 'SOL',
      price: 174.30,
      change: -0.9,
      holdings: 34.4,
      color: Color(0xFF00FFA3),
      iconUrl: 'https://assets.coincap.io/assets/icons/sol@2x.png',
    ),
    CryptoAsset(
      name: 'Chainlink',
      symbol: 'LINK',
      price: 19.42,
      change: 3.6,
      holdings: 224.0,
      color: Color(0xFF2A5ADA),
      iconUrl: 'https://assets.coincap.io/assets/icons/link@2x.png',
    ),
    CryptoAsset(
      name: 'BNB',
      symbol: 'BNB',
      price: 582.90,
      change: 1.1,
      holdings: 12.4,
      color: Color(0xFFF3BA2F),
      iconUrl: 'https://assets.coincap.io/assets/icons/bnb@2x.png',
    ),
    CryptoAsset(
      name: 'XRP',
      symbol: 'XRP',
      price: 0.67,
      change: -1.7,
      holdings: 6200,
      color: Color(0xFF23292F),
      iconUrl: 'https://assets.coincap.io/assets/icons/xrp@2x.png',
    ),
    CryptoAsset(
      name: 'Cardano',
      symbol: 'ADA',
      price: 0.58,
      change: 0.8,
      holdings: 8400,
      color: Color(0xFF0033AD),
      iconUrl: 'https://assets.coincap.io/assets/icons/ada@2x.png',
    ),
    CryptoAsset(
      name: 'Dogecoin',
      symbol: 'DOGE',
      price: 0.14,
      change: 4.3,
      holdings: 12000,
      color: Color(0xFFC2A633),
      iconUrl: 'https://assets.coincap.io/assets/icons/doge@2x.png',
    ),
  ];

  List<CryptoAsset> get portfolioAssets => List.unmodifiable(_portfolioAssets);

  double get totalBalance {
    return _portfolioAssets.fold(
      0,
      (sum, asset) => sum + asset.price * asset.holdings,
    );
  }

  double get investedCapital {
    return _portfolioAssets.fold(0, (sum, asset) {
      final currentValue = asset.price * asset.holdings;
      final base = currentValue / (1 + asset.change / 100);
      return sum + base;
    });
  }

  double get unrealizedPnl => totalBalance - investedCapital;

  double get roiPercent {
    if (investedCapital == 0) {
      return 0;
    }
    return (unrealizedPnl / investedCapital) * 100;
  }

  double get dailyPnl => totalBalance * 0.0124;

  List<double> get analyticsSeriesK {
    final base = investedCapital / 1000;
    return [
      base * 0.97,
      base * 0.985,
      base * 0.98,
      base * 1.012,
      base * 1.006,
      base * 1.026,
      totalBalance / 1000,
    ];
  }

  List<CryptoAsset> get marketMovers {
    final items = [..._portfolioAssets];
    items.sort((a, b) => b.change.compareTo(a.change));
    return items;
  }
}
