import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_assets.dart';
import '../themes/design_tokens.dart';

/// Clean Pinterest profile header (avatar, name, handle, bio, tabular stats, soft neutral capsules)
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTokens.space16,
        AppTokens.space24,
        AppTokens.space16,
        0,
      ),
      child: Column(
        children: [
          // 1. Centered User Avatar with hairline edge
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTokens.lightImageHairline,
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

          // 2. Display Name & Verified Mark
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ahmaryar khan',
                style: textTheme.headlineMedium,
              ),
              const SizedBox(width: AppTokens.space4),
              const Icon(
                Icons.verified_rounded,
                color: AppTokens.pinterestRed,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space4),

          // 3. Handle & Bio
          Text(
            '@codexahmar',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: AppTokens.space8),
          Text(
            'Software Engineer. I build cool stuff.',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: AppTokens.space8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.link_rounded,
                size: 15,
                color: AppTokens.lightTextSecondary,
              ),
              const SizedBox(width: AppTokens.space4),
              Text(
                'github.com/codexahmar',
                style: textTheme.labelMedium?.copyWith(
                  color: AppTokens.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space8),
          Text(
            '142 Pins · 12.8k followers · 420 following',
            style: textTheme.bodyMedium?.copyWith(
              color: AppTokens.lightTextPrimary,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: AppTokens.space16),

          // 4. Authentic Pinterest Profile Action Capsules (Borderless #EFEFEF soft fill)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ProfileActionPill(
                label: 'Share',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile link copied'),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
              ),
              const SizedBox(width: AppTokens.space12),
              _ProfileActionPill(
                label: 'Edit profile',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit profile settings'),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppTokens.space20),
        ],
      ),
    );
  }
}

class _ProfileActionPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ProfileActionPill({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppTokens.radiusButton),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.space24,
          vertical: AppTokens.space12,
        ),
        decoration: BoxDecoration(
          color: AppTokens.lightPill,
          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTokens.lightTextPrimary,
          ),
        ),
      ),
    );
  }
}
