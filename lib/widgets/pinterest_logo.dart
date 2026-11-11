import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../themes/design_tokens.dart';

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

/// Official Pinterest Home Header Bar (Left: Logo + "Pinterest", Right: "+" and Chat with red dot)
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppTokens.space16, AppTokens.space8, AppTokens.space16, AppTokens.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Official Logo + Pinterest text
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PinterestLogo(size: 32),
              SizedBox(width: AppTokens.space8),
              Text(
                'Pinterest',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
            ],
          ),

          // Right: Plus (+) icon and Chat icon with red dot
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Plus Icon
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.add_rounded,
                  size: 28,
                  color: Colors.black,
                ),
                tooltip: 'Create Pin',
                onPressed: onCreateTap,
              ),
              const SizedBox(width: 4),

              // Chat Icon with Red Notification Dot Badge
              InkWell(
                onTap: onChatTap,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.chat_outlined,
                        size: 24,
                        color: Colors.black,
                      ),
                      // Red notification dot
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTokens.pinterestRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
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

