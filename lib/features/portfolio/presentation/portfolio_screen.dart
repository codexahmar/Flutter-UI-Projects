import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/mock/crypto_assets_mock.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assets = CryptoAssetsMock.portfolioAssets;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Portfolio', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Allocation by asset and current holdings.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        ...assets.map(
          (asset) => Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              title: Text(asset.name),
              subtitle: Text('${asset.holdings} ${asset.symbol}'),
              trailing: Text(
                '\$${(asset.price * asset.holdings).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
