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
    ),
    CryptoAsset(
      name: 'Ethereum',
      symbol: 'ETH',
      price: 3324.20,
      change: 2.2,
      holdings: 4.8,
      color: const Color(0xFF627EEA),
    ),
    CryptoAsset(
      name: 'Solana',
      symbol: 'SOL',
      price: 174.30,
      change: -0.9,
      holdings: 34.4,
      color: const Color(0xFF00FFA3),
    ),
    CryptoAsset(
      name: 'Chainlink',
      symbol: 'LINK',
      price: 19.42,
      change: 3.6,
      holdings: 224.0,
      color: const Color(0xFF2A5ADA),
    ),
  ];

  static double get totalBalance {
    return portfolioAssets.fold(
      0,
      (sum, asset) => sum + asset.price * asset.holdings,
    );
  }

  static List<CryptoAsset> get marketMovers {
    final items = [...portfolioAssets];
    items.sort((a, b) => b.change.compareTo(a.change));
    return items;
  }
}
