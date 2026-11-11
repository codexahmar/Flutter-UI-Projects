import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';

/// Modal bottom sheet for pin options (Hide, Download, Copy Link, Report)
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
    return Container(
      decoration: const BoxDecoration(
        color: AppTokens.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTokens.radiusPin)),
      ),
      padding: const EdgeInsets.fromLTRB(AppTokens.space16, AppTokens.space12, AppTokens.space16, AppTokens.space24),
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
                height: 4,
                decoration: BoxDecoration(
                  color: AppTokens.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTokens.space16),

            // Pin Preview Info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: pin.imageUrl,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 44,
                      height: 44,
                      color: AppTokens.lightPill,
                    ),
                    errorWidget: (_, __, ___) => Image.asset(
                      pin.assetFallback,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          letterSpacing: -0.2,
                          color: AppTokens.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pin.author,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTokens.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.space16),
            const Divider(height: 1, color: AppTokens.lightBorder),
            const SizedBox(height: AppTokens.space8),

            // Action Items
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
              icon: Icons.download_rounded,
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
    final primaryColor = isDestructive ? AppTokens.pinterestRed : AppTokens.lightTextPrimary;
    final circleBg = isDestructive ? const Color(0xFFFEECEE) : const Color(0xFFF7F7F7);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: circleBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: primaryColor),
            ),
            const SizedBox(width: AppTokens.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                      color: primaryColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTokens.lightTextSecondary,
                      ),
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

