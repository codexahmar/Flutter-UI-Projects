import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/mock/crypto_assets_mock.dart';
import '../../../shared/widgets/crypto_icon_avatar.dart';

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movers = CryptoAssetsMock.marketMovers;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Markets', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Track top daily movers and current prices.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        ...movers.map(
          (asset) => Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              leading: CryptoIconAvatar(
                symbol: asset.symbol,
                brandColor: asset.color,
                iconUrl: asset.iconUrl,
              ),
              title: Text(asset.name),
              subtitle: Text(asset.symbol),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${asset.price.toStringAsFixed(2)}'),
                  Text(
                    '${asset.change >= 0 ? '+' : ''}${asset.change.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: asset.change >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
