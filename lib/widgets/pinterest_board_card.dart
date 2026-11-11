import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';

/// Authentic Pinterest Board Collage Card (1 large image on left, 2 stacked on right)
class PinterestBoardCard extends StatelessWidget {
  final PinterestBoard board;

  const PinterestBoardCard({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Collage Container
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTokens.radiusBoard),
              color: AppTokens.lightPill,
            ),
            child: Row(
              children: [
                // Left Large Image
                Expanded(
                  flex: 2,
                  child: Image.network(
                    board.mainImage,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => Image.asset(
                      AppAssets.image5,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 2),

                // Right 2 Stacked Images
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          board.subImage1,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Image.asset(
                            AppAssets.image1,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Expanded(
                        child: Image.network(
                          board.subImage2,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Image.asset(
                            AppAssets.image2,
                            fit: BoxFit.cover,
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
        const SizedBox(height: 6),

        // Board Title & Pin Count
        Row(
          children: [
            Expanded(
              child: Text(
                board.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            if (board.isSecret)
              const Icon(Icons.lock_rounded, size: 12),
          ],
        ),
        Text(
          '${board.pinCount} Pins · ${board.updatedTime}',
          style: const TextStyle(
            fontSize: 11,
            color: AppTokens.lightTextTertiary,
          ),
        ),
      ],
    );
  }
}

