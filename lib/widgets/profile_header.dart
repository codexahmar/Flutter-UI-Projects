import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_assets.dart';
import '../themes/design_tokens.dart';

/// Clean profile header component (avatar, name, bio, handles, actions)
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTokens.space16, AppTokens.space24, AppTokens.space16, 0),
      child: Column(
        children: [
          // 1. Centered User Avatar
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTokens.lightBorder,
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

          // 2. User Name & Verified Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ahmaryar khan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppTokens.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 6),
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
          const Text(
            'Software Engineer. I build cool stuff.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.3,
              color: AppTokens.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.link_rounded, size: 14, color: AppTokens.lightTextPrimary),
              SizedBox(width: 4),
              Text(
                'github.com/codexahmar',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '142 Pins · 12.8k followers · 420 following',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTokens.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppTokens.space16),

          // 4. Action Buttons (Share, Edit profile in crisp Pinterest light mode)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile link copied'),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTokens.lightPillBorder, width: 1.0),
                    borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                  ),
                  child: const Text(
                    'Share',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: -0.2,
                      color: AppTokens.lightTextPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTokens.space12),
              InkWell(
                borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit profile settings'),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTokens.lightPillBorder, width: 1.0),
                    borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                  ),
                  child: const Text(
                    'Edit profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: -0.2,
                      color: AppTokens.lightTextPrimary,
                    ),
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
