import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_assets.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import '../widgets/cached_pin_image.dart';
import '../widgets/pin_detail_modal.dart';

class PinterestUpdatesScreen extends StatelessWidget {
  final List<PinItem> pins;
  final VoidCallback? onToggleSave;

  const PinterestUpdatesScreen({
    super.key,
    this.pins = const [],
    this.onToggleSave,
  });

  PinItem? _findPin(String id) {
    for (final p in pins) {
      if (p.id == id) return p;
    }
    return pins.isNotEmpty ? pins.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final pFlora = _findPin('p1');
    final pMac = _findPin('p4');
    final pMonstera = _findPin('p5');
    final pDesk = _findPin('p12');

    final newUpdates = [
      _UpdateEntry(
        actor: 'Studio Flora',
        action: 'shared 4 minimalist ceramic plant pins',
        time: '2h',
        pin: pFlora,
        fallbackAsset: AppAssets.image5,
        unread: true,
      ),
      _UpdateEntry(
        actor: 'Minimal Desk',
        action: 'curated clean MacBook & coding workspaces for you',
        time: '5h',
        pin: pMac,
        fallbackAsset: AppAssets.image4,
        unread: true,
      ),
    ];

    final earlierUpdates = [
      _UpdateEntry(
        actor: 'Leaf & Clay',
        action: 'saved your Monstera deliciosa pin to Minimal Botanicals',
        time: '1d',
        pin: pMonstera,
        fallbackAsset: AppAssets.image1,
      ),
      _UpdateEntry(
        actor: 'DeskInspo',
        action: 'added an ultrawide developer setup to Tech & Gadgets',
        time: '2d',
        pin: pDesk,
        fallbackAsset: AppAssets.image2,
      ),
    ];

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppTokens.space16,
        AppTokens.space16,
        AppTokens.space16,
        AppTokens.space24,
      ),
      children: [
        Text(
          'Updates',
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: AppTokens.space20),

        Text(
          'New',
          style: textTheme.titleSmall?.copyWith(
            color: AppTokens.lightTextSecondary,
          ),
        ),
        const SizedBox(height: AppTokens.space12),
        ...newUpdates.map((item) => _buildUpdateRow(context, item)),

        const SizedBox(height: AppTokens.space16),
        Text(
          'Earlier',
          style: textTheme.titleSmall?.copyWith(
            color: AppTokens.lightTextSecondary,
          ),
        ),
        const SizedBox(height: AppTokens.space12),
        ...earlierUpdates.map((item) => _buildUpdateRow(context, item)),
      ],
    );
  }

  Widget _buildUpdateRow(BuildContext context, _UpdateEntry item) {
    final textTheme = Theme.of(context).textTheme;
    final pin = item.pin;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTokens.space12),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.radiusPin),
        onTap: () {
          HapticFeedback.lightImpact();
          if (pin != null && pins.isNotEmpty) {
            PinDetailModal.show(
              context,
              pin: pin,
              allPins: pins,
              onToggleSave: onToggleSave ?? () {},
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTokens.space4),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: pin != null
                    ? CachedPinImage(
                        imageUrl: pin.imageUrl,
                        assetFallback: pin.assetFallback,
                        isStudioCutout: pin.isStudioCutout,
                        borderRadius: AppTokens.radiusSm,
                        cutoutPadding: AppTokens.space4,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
                        child: Image.asset(item.fallbackAsset, fit: BoxFit.cover),
                      ),
              ),
              const SizedBox(width: AppTokens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${item.actor} ',
                            style: textTheme.titleSmall?.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: item.action,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppTokens.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTokens.space4),
                    Text(
                      item.time,
                      style: textTheme.labelSmall?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              if (item.unread) ...[
                const SizedBox(width: AppTokens.space8),
                Container(
                  width: AppTokens.space8,
                  height: AppTokens.space8,
                  decoration: const BoxDecoration(
                    color: AppTokens.pinterestRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _UpdateEntry {
  final String actor;
  final String action;
  final String time;
  final PinItem? pin;
  final String fallbackAsset;
  final bool unread;

  _UpdateEntry({
    required this.actor,
    required this.action,
    required this.time,
    required this.pin,
    required this.fallbackAsset,
    this.unread = false,
  });
}
