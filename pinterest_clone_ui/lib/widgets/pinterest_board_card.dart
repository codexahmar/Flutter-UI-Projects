import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import 'cached_pin_image.dart';

/// Authentic Pinterest Board Collage Card (1 large left + 2 stacked right)
class PinterestBoardCard extends StatelessWidget {
  final PinterestBoard board;

  const PinterestBoardCard({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 3-photo collage with subtle hairline frame
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTokens.radiusBoard),
              color: AppTokens.lightSurfaceSubtle,
            ),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTokens.radiusBoard),
              border: Border.all(
                color: AppTokens.lightImageHairline,
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox.expand(
                    child: CachedPinImage(
                      imageUrl: board.mainImage,
                      assetFallback: AppAssets.image5,
                      borderRadius: 0,
                      showHairline: false,
                    ),
                  ),
                ),
                const SizedBox(width: AppTokens.space2),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: SizedBox.expand(
                          child: CachedPinImage(
                            imageUrl: board.subImage1,
                            assetFallback: AppAssets.image1,
                            borderRadius: 0,
                            showHairline: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTokens.space2),
                      Expanded(
                        child: SizedBox.expand(
                          child: CachedPinImage(
                            imageUrl: board.subImage2,
                            assetFallback: AppAssets.image2,
                            borderRadius: 0,
                            showHairline: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTokens.space8),

        // Board Title & Lock indicator
        Row(
          children: [
            Expanded(
              child: Text(
                board.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(fontSize: 14),
              ),
            ),
            if (board.isSecret) ...[
              const SizedBox(width: AppTokens.space4),
              const Icon(
                Icons.lock_outline_rounded,
                size: 14,
                color: AppTokens.lightTextSecondary,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppTokens.space2),
        Text(
          '${board.pinCount} Pins · ${board.updatedTime}',
          style: textTheme.labelSmall?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
