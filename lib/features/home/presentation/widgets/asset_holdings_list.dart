import 'package:flutter/material.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final value = asset.price * asset.holdings;
    final isGain = asset.change >= 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${asset.name} (${asset.symbol}) selected'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            color: colorScheme.surface,
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: isDark ? 0.3 : 0.6),
            ),
          ),
          child: Row(
            children: [
              CryptoIconAvatar(
                symbol: asset.symbol,
                brandColor: asset.color,
                iconUrl: asset.iconUrl,
                size: 42,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${asset.holdings.toStringAsFixed(asset.holdings < 10 ? 4 : 2)} ${asset.symbol} • ${formatCompactCurrency(asset.price)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCurrency(value),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isGain
                          ? const Color(0xFF10B981).withValues(alpha: 0.14)
                          : const Color(0xFFEF4444).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${isGain ? '+' : ''}${asset.change.toStringAsFixed(2)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isGain
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
