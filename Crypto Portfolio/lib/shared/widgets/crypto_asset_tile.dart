import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../models/crypto_asset.dart';
import 'crypto_icon_avatar.dart';

class CryptoAssetTile extends StatelessWidget {
  const CryptoAssetTile({
    super.key,
    required this.asset,
    required this.subtitle,
    required this.primaryValue,
    this.secondaryValue,
    this.secondaryColor,
  });

  final CryptoAsset asset;
  final String subtitle;
  final String primaryValue;
  final String? secondaryValue;
  final Color? secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Card(
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
        subtitle: Text(subtitle),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(primaryValue, style: Theme.of(context).textTheme.titleSmall),
            if (secondaryValue != null)
              Text(
                secondaryValue!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: secondaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
