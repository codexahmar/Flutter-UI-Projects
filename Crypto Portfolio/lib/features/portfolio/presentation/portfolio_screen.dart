import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/animated_entrance.dart';
import '../../../shared/services/mock_crypto_data_service.dart';
import '../../../shared/widgets/crypto_asset_tile.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assets = const MockCryptoDataService().portfolioAssets;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AnimatedEntrance(
          child: Text(
            'Portfolio',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 70),
          child: Text(
            'Allocation by asset and current holdings.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...assets.take(10).toList().asMap().entries.map((entry) {
          final index = entry.key;
          final asset = entry.value;

          return AnimatedEntrance(
            delay: Duration(milliseconds: 110 + (index * 35)),
            child: CryptoAssetTile(
              asset: asset,
              subtitle: '${asset.holdings.toStringAsFixed(2)} ${asset.symbol}',
              primaryValue:
                  '\$${(asset.price * asset.holdings).toStringAsFixed(2)}',
            ),
          );
        }),
      ],
    );
  }
}
