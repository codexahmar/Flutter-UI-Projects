import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Cached network food image displaying a warm ivory skeleton shimmer while loading.
class FoodNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Color? scrimColor;
  final IconData fallbackIcon;

  const FoodNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.scrimColor,
    this.fallbackIcon = CupertinoIcons.photo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: fit,
            memCacheWidth: width != null ? (width! * 2).round() : 720,
            fadeInDuration: const Duration(milliseconds: 180),
            fadeOutDuration: const Duration(milliseconds: 100),
            placeholder: (_, _) => const _ImageSkeletonShimmer(),
            errorWidget: (_, _, _) => ColoredBox(
              color: FoodColors.surfaceSubtle,
              child: Center(
                child: Icon(
                  fallbackIcon,
                  color: FoodColors.textSecondary,
                  size: 20,
                ),
              ),
            ),
          ),
          if (scrimColor != null) ColoredBox(color: scrimColor!),
        ],
      ),
    );
  }
}

class _ImageSkeletonShimmer extends StatefulWidget {
  const _ImageSkeletonShimmer();

  @override
  State<_ImageSkeletonShimmer> createState() => _ImageSkeletonShimmerState();
}

class _ImageSkeletonShimmerState extends State<_ImageSkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1350),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final slide = (_controller.value * 2.6) - 1.3;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(slide - 0.8, -0.35),
              end: Alignment(slide + 0.8, 0.35),
              colors: const [
                FoodColors.surfaceSubtle,
                FoodColors.canvas,
                FoodColors.surfaceSubtle,
              ],
            ),
          ),
        );
      },
    );
  }
}
