import 'package:flutter/material.dart';
import '../themes/design_tokens.dart';

/// Lightweight native shimmer pulse for initial feed loading.
class ShimmerLoading extends StatefulWidget {
  final Widget child;

  const ShimmerLoading({super.key, required this.child});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.45, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Masonry loading placeholder aligned pixel-for-pixel with PinterestMasonryGrid.
class PinterestMasonrySkeleton extends StatelessWidget {
  const PinterestMasonrySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerLoading(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: AppTokens.space8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _SkeletonPin(aspectRatio: 0.84),
                  _SkeletonPin(aspectRatio: 0.72),
                  _SkeletonPin(aspectRatio: 0.88),
                ],
              ),
            ),
            SizedBox(width: AppTokens.space8),
            Expanded(
              child: Column(
                children: [
                  _SkeletonPin(aspectRatio: 0.75),
                  _SkeletonPin(aspectRatio: 0.86),
                  _SkeletonPin(aspectRatio: 0.70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonPin extends StatelessWidget {
  final double aspectRatio;

  const _SkeletonPin({required this.aspectRatio});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTokens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              decoration: BoxDecoration(
                color: AppTokens.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(AppTokens.radiusPin),
              ),
            ),
          ),
          const SizedBox(height: AppTokens.space8),
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTokens.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(AppTokens.space8),
            ),
          ),
          const SizedBox(height: AppTokens.space4),
          Container(
            height: 12,
            width: 96,
            decoration: BoxDecoration(
              color: AppTokens.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(AppTokens.space8),
            ),
          ),
        ],
      ),
    );
  }
}
