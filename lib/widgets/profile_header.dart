import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_assets.dart';
import '../themes/design_tokens.dart';

/// Clean profile header component (avatar, name, bio, handles, actions)
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTokens.space16, AppTokens.space8, AppTokens.space16, 0),
      child: Column(
        children: [
          // 1. Top Bar: Share & Settings
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 22),
                tooltip: 'Share profile',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile link copied to clipboard'),
                      duration: Duration(milliseconds: 1200),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 22),
                tooltip: 'Settings',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pinterest settings & preferences'),
                      duration: Duration(milliseconds: 1200),
                    ),
                  );
                },
              ),
            ],
          ),

          // 2. Centered User Avatar
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                AppAssets.profile,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: AppTokens.space12),

          // 3. User Name & Verified Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ahmaryar khan',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.verified_rounded,
                color: AppTokens.pinterestRed,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            '@codexahmar',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTokens.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Software Engineer. I build cool stuff.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.3,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.link_rounded, size: 14, color: theme.colorScheme.onSurface),
              const SizedBox(width: 4),
              Text(
                'github.com/codexahmar',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '142 Pins · 12.8k followers · 420 following',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTokens.space16),

          // 4. Action Buttons (Share, Edit profile)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: AppTokens.lightPill,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile link copied'),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
                child: Text(
                  'Share',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: AppTokens.space12),
              FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: AppTokens.lightPill,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit profile settings'),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
                child: Text(
                  'Edit profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space20),
        ],
      ),
    );
  }
}
