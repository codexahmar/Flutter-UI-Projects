import 'package:flutter/cupertino.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Network food photo with consistent placeholder, error fallback, and optional scrim.
class FoodNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Color? scrimColor;

  const FoodNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.scrimColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const ColoredBox(color: FoodColors.surfaceSubtle);
            },
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(
                color: FoodColors.surfaceSubtle,
                child: Center(
                  child: Icon(
                    CupertinoIcons.photo,
                    color: FoodColors.textSecondary,
                    size: 22,
                  ),
                ),
              );
            },
          ),
          if (scrimColor != null) ColoredBox(color: scrimColor!),
        ],
      ),
    );
  }
}
