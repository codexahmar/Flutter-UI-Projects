import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/design_tokens.dart';

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
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppTokens.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTokens.radiusPin)),
      ),
      padding: const EdgeInsets.fromLTRB(AppTokens.space20, AppTokens.space12, AppTokens.space20, AppTokens.space32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppTokens.space16),
          Text(
            'Start creating now',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppTokens.space16),
          _CreateOption(
            icon: Icons.push_pin_outlined,
            title: 'Pin',
            subtitle: 'Upload photos, design inspirations, or clips',
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
          const SizedBox(height: AppTokens.space12),
          _CreateOption(
            icon: Icons.dashboard_customize_outlined,
            title: 'Board',
            subtitle: 'Group related pins into aesthetic collections',
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
          const SizedBox(height: AppTokens.space12),
          _CreateOption(
            icon: Icons.auto_awesome_mosaic_outlined,
            title: 'Collage',
            subtitle: 'Cutout and mix images into a visual moodboard',
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
        ],
      ),
    );
  }
}

class _CreateOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CreateOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(AppTokens.radiusPin),
      child: Container(
        padding: const EdgeInsets.all(AppTokens.space12),
        decoration: BoxDecoration(
          color: AppTokens.lightPill,
          borderRadius: BorderRadius.circular(AppTokens.radiusPin),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(width: AppTokens.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTokens.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
