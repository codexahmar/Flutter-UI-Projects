import 'package:flutter/material.dart';

import '../../../core/widgets/animated_entrance.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/services/mock_crypto_data_service.dart';
import '../../../shared/widgets/crypto_asset_tile.dart';

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movers = const MockCryptoDataService().marketMovers;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AnimatedEntrance(
          child: Text(
            'Markets',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 70),
          child: Text(
            'Track top daily movers and current prices.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...movers.take(10).toList().asMap().entries.map((entry) {
          final index = entry.key;
          final asset = entry.value;
          return AnimatedEntrance(
            delay: Duration(milliseconds: 110 + (index * 35)),
            child: CryptoAssetTile(
              asset: asset,
              subtitle: asset.symbol,
              primaryValue: '\$${asset.price.toStringAsFixed(2)}',
              secondaryValue:
                  '${asset.change >= 0 ? '+' : ''}${asset.change.toStringAsFixed(1)}%',
              secondaryColor: asset.change >= 0 ? Colors.green : Colors.red,
            ),
          );
        }),
      ],
    );
  }
}
