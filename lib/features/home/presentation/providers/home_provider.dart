import 'package:flutter/foundation.dart';

import '../../../../shared/models/crypto_asset.dart';
import '../../../../shared/services/mock_crypto_data_service.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({MockCryptoDataService? dataService})
    : _dataService = dataService ?? const MockCryptoDataService();

  final MockCryptoDataService _dataService;

  bool _isLoading = false;
  bool _isBalanceHidden = false;
  ChartTimeframe _selectedTimeframe = ChartTimeframe.w1;
  List<CryptoAsset> _assets = const [];

  bool get isLoading => _isLoading;
  bool get isBalanceHidden => _isBalanceHidden;
  ChartTimeframe get selectedTimeframe => _selectedTimeframe;
  List<CryptoAsset> get assets => _assets;

  double get totalBalance => _dataService.totalBalance;
  double get btcEquivalent => _dataService.btcEquivalent;
  double get investedCapital => _dataService.investedCapital;
  double get unrealizedPnl => _dataService.unrealizedPnl;
  double get roiPercent => _dataService.roiPercent;
  double get dailyPnl => _dataService.dailyPnl;
  String get walletAddress => MockCryptoDataService.truncatedWalletAddress;
  String get fullWalletAddress => MockCryptoDataService.defaultWalletAddress;

  ChartDataModel get chartData => _dataService.getChartData(_selectedTimeframe);
  List<double> get analyticsSeriesK => chartData.points;

  void toggleBalanceVisibility() {
    _isBalanceHidden = !_isBalanceHidden;
    notifyListeners();
  }

  void setTimeframe(ChartTimeframe timeframe) {
    if (_selectedTimeframe == timeframe) {
      return;
    }
    _selectedTimeframe = timeframe;
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 120));
    _assets = _dataService.portfolioAssets;

    _isLoading = false;
    notifyListeners();
  }
}
