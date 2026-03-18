import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/models/crypto_asset.dart';
import '../../../../shared/widgets/crypto_icon_avatar.dart';

class AssetHoldingsList extends StatelessWidget {
  const AssetHoldingsList({super.key, required this.assets});

  final List<CryptoAsset> assets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: assets
          .take(6)
          .map(
            (asset) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _AssetRow(asset: asset),
            ),
          )
          .toList(),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({required this.asset});

  final CryptoAsset asset;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final value = asset.price * asset.holdings;
    final isGain = asset.change >= 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          CryptoIconAvatar(
            symbol: asset.symbol,
            brandColor: asset.color,
            iconUrl: asset.iconUrl,
            size: 44,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(asset.name, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '${asset.holdings.toStringAsFixed(2)} ${asset.symbol}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatCompactCurrency(value),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(
                '${isGain ? '+' : ''}${asset.change.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isGain ? AppColors.success : AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
