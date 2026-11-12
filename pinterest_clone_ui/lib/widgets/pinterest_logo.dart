import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_assets.dart';
import '../themes/design_tokens.dart';
import 'pinterest_icons.dart';

/// Official Pinterest Logo (Image Asset)
class PinterestLogo extends StatelessWidget {
  final double size;

  const PinterestLogo({super.key, this.size = 28.0});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        AppAssets.pinterestLogo,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

/// Official Pinterest Home Header Bar (Left: Logo + "Pinterest", Right: "+" and Inbox with unread dot)
class PinterestOfficialHeader extends StatelessWidget {
  final VoidCallback onCreateTap;
  final VoidCallback onChatTap;

  const PinterestOfficialHeader({
    super.key,
    required this.onCreateTap,
    required this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTokens.space16,
        AppTokens.space8,
        AppTokens.space12,
        AppTokens.space8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Official Logo + Pinterest wordmark
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PinterestLogo(size: 28),
              const SizedBox(width: AppTokens.space8),
              Text(
                'Pinterest',
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppTokens.lightTextPrimary,
                ),
              ),
            ],
          ),

          // Right: Uniform-stroke Create (+) and Updates/Inbox actions (44px tap targets)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: 'Create Pin',
                child: TactileScaleTap(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onCreateTap();
                  },
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: PinterestCreateIcon(
                        color: AppTokens.lightTextPrimary,
                        size: 23,
                        strokeWidth: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: 'Inbox & updates',
                child: TactileScaleTap(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onChatTap();
                  },
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const PinterestInboxIcon(
                            active: false,
                            color: AppTokens.lightTextPrimary,
                            size: 23,
                          ),
                          Positioned(
                            top: -1,
                            right: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTokens.pinterestRed,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTokens.lightBg,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
