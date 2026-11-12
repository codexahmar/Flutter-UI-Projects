import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import 'cached_pin_image.dart';

/// Modal bottom sheet for pin options (Copy link, Download, Hide, Report)
class PinOptionsSheet extends StatelessWidget {
  final PinItem pin;

  const PinOptionsSheet({super.key, required this.pin});

  static Future<void> show(BuildContext context, {required PinItem pin}) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PinOptionsSheet(pin: pin),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        color: AppTokens.lightSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTokens.radiusSheet),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppTokens.space16,
        AppTokens.space12,
        AppTokens.space16,
        AppTokens.space24,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 36,
                height: AppTokens.space4,
                decoration: BoxDecoration(
                  color: AppTokens.lightPillHover,
                  borderRadius: BorderRadius.circular(AppTokens.space2),
                ),
              ),
            ),
            const SizedBox(height: AppTokens.space16),

            // Pin Preview Info
            Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CachedPinImage(
                    imageUrl: pin.imageUrl,
                    assetFallback: pin.assetFallback,
                    isStudioCutout: pin.isStudioCutout,
                    borderRadius: AppTokens.radiusSm,
                    cutoutPadding: AppTokens.space4,
                  ),
                ),
                const SizedBox(width: AppTokens.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pin.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: AppTokens.space2),
                      Text(
                        pin.author,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.space16),
            const Divider(height: 1, color: AppTokens.lightBorder),
            const SizedBox(height: AppTokens.space8),

            // Clean borderless typographic action list (no decorative icon circles)
            _ActionTile(
              icon: Icons.link_rounded,
              title: 'Copy link',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pin link copied to clipboard'),
                    duration: Duration(milliseconds: 1000),
                  ),
                );
              },
            ),
            _ActionTile(
              icon: Icons.download_outlined,
              title: 'Download image',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image saved to photos'),
                    duration: Duration(milliseconds: 1000),
                  ),
                );
              },
            ),
            _ActionTile(
              icon: Icons.visibility_off_outlined,
              title: 'Hide Pin',
              subtitle: 'See fewer Pins like this',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pin hidden from your feed'),
                    duration: Duration(milliseconds: 1000),
                  ),
                );
              },
            ),
            _ActionTile(
              icon: Icons.flag_outlined,
              title: 'Report Pin',
              subtitle: 'This goes against our Community Guidelines',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you. We will review this Pin.'),
                    duration: Duration(milliseconds: 1200),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final foreground =
        isDestructive ? AppTokens.pinterestRedDark : AppTokens.lightTextPrimary;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppTokens.space12,
          horizontal: AppTokens.space4,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Icon(
                icon,
                size: 22,
                color: foreground,
              ),
            ),
            const SizedBox(width: AppTokens.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: foreground,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppTokens.space2),
                    Text(
                      subtitle!,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
