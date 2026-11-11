import 'package:flutter/material.dart';
import '../themes/design_tokens.dart';

/// Lightweight, native Flutter shimmer effect (Zero external packages needed)
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

    _animation = Tween<double>(begin: 0.35, end: 0.85).animate(
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

/// The Pinterest Masonry Skeleton Feed shown on startup
class PinterestMasonrySkeleton extends StatelessWidget {
  const PinterestMasonrySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    const baseColor = AppTokens.lightPill;

    return const ShimmerLoading(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppTokens.space8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Skeleton Column
            Expanded(
              child: Column(
                children: [
                  _SkeletonPin(height: 200, color: baseColor),
                  _SkeletonPin(height: 150, color: baseColor),
                  _SkeletonPin(height: 220, color: baseColor),
                ],
              ),
            ),
            const SizedBox(width: AppTokens.space8),

            // Right Skeleton Column
            Expanded(
              child: Column(
                children: [
                  _SkeletonPin(height: 160, color: baseColor),
                  _SkeletonPin(height: 220, color: baseColor),
                  _SkeletonPin(height: 170, color: baseColor),
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
  final double height;
  final Color color;

  const _SkeletonPin({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTokens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppTokens.radiusPin),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 10,
            width: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}
