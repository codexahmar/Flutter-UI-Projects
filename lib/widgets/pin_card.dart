import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import 'cached_pin_image.dart';
import 'pin_options_sheet.dart';

class PinCard extends StatelessWidget {
  final PinItem pin;
  final VoidCallback onTap;
  final VoidCallback? onToggleSave;
  final bool showSaveButton;
  final String? heroTag;

  const PinCard({
    super.key,
    required this.pin,
    required this.onTap,
    this.onToggleSave,
    this.showSaveButton = true,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTokens.space16),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        onLongPress: () => PinOptionsSheet.show(context, pin: pin),
        borderRadius: BorderRadius.circular(AppTokens.radiusPin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unobstructed pin image with hairline border and smooth Hero support
            AspectRatio(
              aspectRatio: pin.aspectRatio,
              child: CachedPinImage(
                imageUrl: pin.imageUrl,
                assetFallback: pin.assetFallback,
                isStudioCutout: pin.isStudioCutout,
                cutoutPadding: AppTokens.space8,
                heroTag: heroTag,
                overlay: (showSaveButton && onToggleSave != null)
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(AppTokens.space8),
                          child: _QuickSavePill(
                            isSaved: pin.isSaved,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              onToggleSave!();
                            },
                          ),
                        ),
                      )
                    : null,
              ),
            ),

            // Authentic Pinterest footer below pin: title + creator + flush "..." menu
            Padding(
              padding: const EdgeInsets.only(
                top: AppTokens.space8,
                left: AppTokens.space2,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pin.title.isNotEmpty) ...[
                          Text(
                            pin.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTokens.lightTextPrimary,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: AppTokens.space4),
                        ],
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTokens.lightImageHairline,
                                  width: 0.6,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  pin.authorAvatar,
                                  width: 18,
                                  height: 18,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTokens.space8),
                            Expanded(
                              child: Text(
                                pin.author,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.labelSmall?.copyWith(
                                  color: AppTokens.lightTextSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      PinOptionsSheet.show(context, pin: pin);
                    },
                    borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: AppTokens.space8,
                        right: AppTokens.space2,
                        bottom: AppTokens.space8,
                      ),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        color: AppTokens.lightTextSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickSavePill extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const _QuickSavePill({
    required this.isSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusButton),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: isSaved ? AppTokens.space12 : AppTokens.space16,
          vertical: AppTokens.space8,
        ),
        decoration: BoxDecoration(
          color: isSaved ? AppTokens.lightTextPrimary : AppTokens.pinterestRed,
          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
          boxShadow: AppTokens.shadowBar,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSaved) ...[
              const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 14,
              ),
              const SizedBox(width: AppTokens.space4),
            ],
            Text(
              isSaved ? 'Saved' : 'Save',
              style: textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
