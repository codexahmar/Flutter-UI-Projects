import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTokens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The Pin Image Container
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppTokens.radiusPin),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTokens.radiusPin),
              child: AspectRatio(
                aspectRatio: pin.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Dynamic Network Image with Asset Fallback
                    Image.network(
                      pin.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        pin.assetFallback,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Quick Save Button (Pinterest Red Pill)
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: pin.isSaved
                                ? (isDark ? Colors.white : Colors.black)
                                : AppTokens.pinterestRed,
                            borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            pin.isSaved ? 'Saved' : 'Save',
                            style: TextStyle(
                              color: pin.isSaved
                                  ? (isDark ? Colors.black : Colors.white)
                                  : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Three Dots Options Button
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
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
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.25,
                color: theme.colorScheme.onSurface,
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
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: isDark ? AppTokens.darkTextSecondary : AppTokens.lightTextSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
