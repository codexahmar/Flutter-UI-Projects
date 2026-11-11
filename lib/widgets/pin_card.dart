import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import 'pin_options_sheet.dart';

class PinCard extends StatelessWidget {
  final PinItem pin;
  final VoidCallback onTap;
  final VoidCallback onToggleSave;

  const PinCard({
    super.key,
    required this.pin,
    required this.onTap,
    required this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTokens.space12),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        onLongPress: () {
          PinOptionsSheet.show(context, pin: pin);
        },
        borderRadius: BorderRadius.circular(AppTokens.radiusPin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The Pin Image Container
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTokens.radiusPin),
              child: AspectRatio(
                aspectRatio: pin.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Cached Network Image with Smooth Placeholder & Asset Fallback
                    CachedNetworkImage(
                      imageUrl: pin.imageUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 180),
                      fadeOutDuration: const Duration(milliseconds: 120),
                      placeholder: (_, __) => Container(
                        color: AppTokens.lightPill,
                      ),
                      errorWidget: (_, __, ___) => Image.asset(
                        pin.assetFallback,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Quick Save Button (Identical to Pinterest Official App)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onToggleSave();
                        },
                        borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: pin.isSaved ? 10 : 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: pin.isSaved
                                ? Colors.black
                                : AppTokens.pinterestRed,
                            borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.22),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (pin.isSaved) ...[
                                const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 3),
                              ],
                              Text(
                                pin.isSaved ? 'Saved' : 'Save',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Three Dots Options Button
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          PinOptionsSheet.show(context, pin: pin);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.more_horiz_rounded,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Title & Author below pin (Pinterest Style)
            if (pin.title.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                pin.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 1.25,
                  letterSpacing: -0.1,
                  color: AppTokens.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      pin.authorAvatar,
                      width: 18,
                      height: 18,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      pin.author,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppTokens.lightTextSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
