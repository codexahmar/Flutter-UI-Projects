import 'package:flutter/material.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Fixed-frame network photo with subtle loading state and optional bottom scrim.
class FoodNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final BorderRadius borderRadius;
  final bool showBottomScrim;

  const FoodNetworkImage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    this.borderRadius = const BorderRadius.all(Radius.circular(FoodRadius.md)),
    this.showBottomScrim = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, imageChild, progress) {
              if (progress == null) return imageChild;
              return const ColoredBox(color: FoodColors.surfaceSubtle);
            },
            errorBuilder: (_, _, _) => const ColoredBox(
              color: FoodColors.surfaceSubtle,
              child: Center(
                child: Icon(
                  Icons.restaurant_rounded,
                  color: FoodColors.textSecondary,
                  size: 24,
                ),
              ),
            ),
          ),
          if (showBottomScrim)
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x880C0E12)],
                ),
              ),
            ),
        ],
      ),
    );

    return Hero(tag: heroTag, child: child);
  }
}

