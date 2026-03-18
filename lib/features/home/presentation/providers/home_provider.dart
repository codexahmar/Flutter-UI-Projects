import 'package:flutter/foundation.dart';

import '../../../../shared/models/crypto_asset.dart';
import '../../../../shared/services/mock_crypto_data_service.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({MockCryptoDataService? dataService})
    : _dataService = dataService ?? const MockCryptoDataService();

  final MockCryptoDataService _dataService;

  bool _isLoading = false;
  List<CryptoAsset> _assets = const [];

  bool get isLoading => _isLoading;
  List<CryptoAsset> get assets => _assets;

  double get totalBalance => _dataService.totalBalance;
  double get investedCapital => _dataService.investedCapital;
  double get unrealizedPnl => _dataService.unrealizedPnl;
  double get roiPercent => _dataService.roiPercent;
  double get dailyPnl => _dataService.dailyPnl;
  List<double> get analyticsSeriesK => _dataService.analyticsSeriesK;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 120));
    _assets = _dataService.portfolioAssets;

    _isLoading = false;
    notifyListeners();
  }
}
