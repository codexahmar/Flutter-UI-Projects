import 'package:flutter/material.dart';

import '../models/crypto_asset.dart';

enum ChartTimeframe {
  h24('24H', 'Past 24 Hours'),
  w1('1W', 'Past Week'),
  m1('1M', 'Past Month'),
  y1('1Y', 'Past Year'),
  all('ALL', 'All Time');

  const ChartTimeframe(this.label, this.description);
  final String label;
  final String description;
}

class ChartDataModel {
  const ChartDataModel({
    required this.timeframe,
    required this.points,
    required this.labels,
    required this.changePercent,
    required this.changeAmount,
    required this.high,
    required this.low,
  });

  final ChartTimeframe timeframe;
  final List<double> points;
  final List<String> labels;
  final double changePercent;
  final double changeAmount;
  final double high;
  final double low;
}

class MockCryptoDataService {
  const MockCryptoDataService();

  static const String defaultWalletAddress =
      '0x71C824a68C3202C26e3860F5f7FE0F4bCd3149B2';
  static const String truncatedWalletAddress = '0x71C8...49B2';

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

  double get btcEquivalent {
    final btcPrice = _portfolioAssets
        .firstWhere((a) => a.symbol == 'BTC')
        .price;
    return totalBalance / btcPrice;
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
    final base = totalBalance / 1000;
    return [
      base * 0.965,
      base * 0.978,
      base * 0.972,
      base * 0.995,
      base * 0.988,
      base * 1.015,
      base,
    ];
  }

  ChartDataModel getChartData(ChartTimeframe timeframe) {
    final base = totalBalance;
    switch (timeframe) {
      case ChartTimeframe.h24:
        final raw = [
          base * 0.987,
          base * 0.984,
          base * 0.989,
          base * 0.992,
          base * 0.998,
          base * 0.995,
          base * 1.004,
          base * 1.012,
          base,
        ];
        final pts = raw.map((v) => v / 1000).toList();
        return ChartDataModel(
          timeframe: timeframe,
          points: pts,
          labels: const [
            '00:00',
            '03:00',
            '06:00',
            '09:00',
            '12:00',
            '15:00',
            '18:00',
            '21:00',
            'Now',
          ],
          changePercent: 1.32,
          changeAmount: base * 0.0132,
          high: pts.reduce((a, b) => a > b ? a : b),
          low: pts.reduce((a, b) => a < b ? a : b),
        );

      case ChartTimeframe.w1:
        final raw = [
          base * 0.962,
          base * 0.975,
          base * 0.968,
          base * 0.988,
          base * 0.982,
          base * 1.014,
          base,
        ];
        final pts = raw.map((v) => v / 1000).toList();
        return ChartDataModel(
          timeframe: timeframe,
          points: pts,
          labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
          changePercent: 3.95,
          changeAmount: base * 0.0395,
          high: pts.reduce((a, b) => a > b ? a : b),
          low: pts.reduce((a, b) => a < b ? a : b),
        );

      case ChartTimeframe.m1:
        final raw = [
          base * 0.912,
          base * 0.934,
          base * 0.928,
          base * 0.956,
          base * 0.982,
          base,
        ];
        final pts = raw.map((v) => v / 1000).toList();
        return ChartDataModel(
          timeframe: timeframe,
          points: pts,
          labels: const ['W1', 'W2', 'W3', 'W4', 'W5', 'Current'],
          changePercent: 9.65,
          changeAmount: base * 0.0965,
          high: pts.reduce((a, b) => a > b ? a : b),
          low: pts.reduce((a, b) => a < b ? a : b),
        );

      case ChartTimeframe.y1:
        final raw = [
          base * 0.680,
          base * 0.720,
          base * 0.790,
          base * 0.840,
          base * 0.910,
          base * 0.960,
          base,
        ];
        final pts = raw.map((v) => v / 1000).toList();
        return ChartDataModel(
          timeframe: timeframe,
          points: pts,
          labels: const ['Jan', 'Mar', 'May', 'Jul', 'Sep', 'Nov', 'Now'],
          changePercent: 47.06,
          changeAmount: base * 0.4706,
          high: pts.reduce((a, b) => a > b ? a : b),
          low: pts.reduce((a, b) => a < b ? a : b),
        );

      case ChartTimeframe.all:
        final raw = [
          base * 0.240,
          base * 0.410,
          base * 0.580,
          base * 0.720,
          base * 0.880,
          base,
        ];
        final pts = raw.map((v) => v / 1000).toList();
        return ChartDataModel(
          timeframe: timeframe,
          points: pts,
          labels: const ['2022', '2023', '2024', '2025', '2026', 'Now'],
          changePercent: 316.67,
          changeAmount: base * 3.1667,
          high: pts.reduce((a, b) => a > b ? a : b),
          low: pts.reduce((a, b) => a < b ? a : b),
        );
    }
  }

  List<CryptoAsset> get marketMovers {
    final items = [..._portfolioAssets];
    items.sort((a, b) => b.change.compareTo(a.change));
    return items;
  }
}
