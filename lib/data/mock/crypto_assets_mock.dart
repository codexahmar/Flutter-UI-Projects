import 'package:flutter/material.dart';

import '../../models/crypto_asset.dart';

class CryptoAssetsMock {
  CryptoAssetsMock._();

  static final List<CryptoAsset> portfolioAssets = [
    CryptoAsset(
      name: 'Bitcoin',
      symbol: 'BTC',
      price: 63452.75,
      change: 1.8,
      holdings: 0.52,
      color: const Color(0xFFF7931A),
      iconUrl: 'https://assets.coincap.io/assets/icons/btc@2x.png',
    ),
    CryptoAsset(
      name: 'Ethereum',
      symbol: 'ETH',
      price: 3324.20,
      change: 2.2,
      holdings: 4.8,
      color: const Color(0xFF627EEA),
      iconUrl: 'https://assets.coincap.io/assets/icons/eth@2x.png',
    ),
    CryptoAsset(
      name: 'Solana',
      symbol: 'SOL',
      price: 174.30,
      change: -0.9,
      holdings: 34.4,
      color: const Color(0xFF00FFA3),
      iconUrl: 'https://assets.coincap.io/assets/icons/sol@2x.png',
    ),
    CryptoAsset(
      name: 'Chainlink',
      symbol: 'LINK',
      price: 19.42,
      change: 3.6,
      holdings: 224.0,
      color: const Color(0xFF2A5ADA),
      iconUrl: 'https://assets.coincap.io/assets/icons/link@2x.png',
    ),
    CryptoAsset(
      name: 'BNB',
      symbol: 'BNB',
      price: 582.90,
      change: 1.1,
      holdings: 12.4,
      color: const Color(0xFFF3BA2F),
      iconUrl: 'https://assets.coincap.io/assets/icons/bnb@2x.png',
    ),
    CryptoAsset(
      name: 'XRP',
      symbol: 'XRP',
      price: 0.67,
      change: -1.7,
      holdings: 6200,
      color: const Color(0xFF23292F),
      iconUrl: 'https://assets.coincap.io/assets/icons/xrp@2x.png',
    ),
    CryptoAsset(
      name: 'Cardano',
      symbol: 'ADA',
      price: 0.58,
      change: 0.8,
      holdings: 8400,
      color: const Color(0xFF0033AD),
      iconUrl: 'https://assets.coincap.io/assets/icons/ada@2x.png',
    ),
    CryptoAsset(
      name: 'Dogecoin',
      symbol: 'DOGE',
      price: 0.14,
      change: 4.3,
      holdings: 12000,
      color: const Color(0xFFC2A633),
      iconUrl: 'https://assets.coincap.io/assets/icons/doge@2x.png',
    ),
  ];

  static double get totalBalance {
    return portfolioAssets.fold(
      0,
      (sum, asset) => sum + asset.price * asset.holdings,
    );
  }

  static double get investedCapital {
    return portfolioAssets.fold(0, (sum, asset) {
      final currentValue = asset.price * asset.holdings;
      final base = currentValue / (1 + asset.change / 100);
      return sum + base;
    });
  }

  static double get unrealizedPnl {
    return totalBalance - investedCapital;
  }

  static double get roiPercent {
    if (investedCapital == 0) {
      return 0;
    }
    return (unrealizedPnl / investedCapital) * 100;
  }

  static double get dailyPnl {
    return totalBalance * 0.0124;
  }

  static List<double> get analyticsSeriesK {
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

  static List<CryptoAsset> get marketMovers {
    final items = [...portfolioAssets];
    items.sort((a, b) => b.change.compareTo(a.change));
    return items;
  }
}
