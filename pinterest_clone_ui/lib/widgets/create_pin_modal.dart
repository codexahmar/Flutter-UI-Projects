import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/design_tokens.dart';

/// Authentic Pinterest 3-tile squircle bottom sheet ("Start creating now")
class CreatePinModal extends StatelessWidget {
  const CreatePinModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CreatePinModal(),
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
        AppTokens.space20,
        AppTokens.space12,
        AppTokens.space20,
        AppTokens.space32,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 36,
              height: AppTokens.space4,
              decoration: BoxDecoration(
                color: AppTokens.lightPillHover,
                borderRadius: BorderRadius.circular(AppTokens.space2),
              ),
            ),
            const SizedBox(height: AppTokens.space12),

            // Header with close button aligned cleanly
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 22,
                    color: AppTokens.lightTextPrimary,
                  ),
                  tooltip: 'Close',
                ),
                Expanded(
                  child: Text(
                    'Start creating now',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: AppTokens.space20),

            // Authentic 3-column horizontal Pinterest Create grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CreateTile(
                  icon: Icons.push_pin_outlined,
                  label: 'Pin',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Select an image from gallery to create pin'),
                        duration: Duration(milliseconds: 1200),
                      ),
                    );
                  },
                ),
                _CreateTile(
                  icon: Icons.auto_awesome_mosaic_outlined,
                  label: 'Collage',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Collage canvas editor'),
                        duration: Duration(milliseconds: 1200),
                      ),
                    );
                  },
                ),
                _CreateTile(
                  icon: Icons.dashboard_customize_outlined,
                  label: 'Board',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New board creation dialog'),
                        duration: Duration(milliseconds: 1200),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppTokens.space12),
          ],
        ),
      ),
    );
  }
}

class _CreateTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CreateTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(AppTokens.radiusTile),
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.space8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTokens.lightPill,
                borderRadius: BorderRadius.circular(AppTokens.radiusTile),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 26,
                color: AppTokens.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppTokens.space8),
            Text(
              label,
              style: textTheme.titleSmall?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
