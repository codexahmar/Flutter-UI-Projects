import 'package:flutter/material.dart';

/// Synchronized card reveal driven by a shared grid Animation<double>.
class StaggeredPinAnimation extends StatelessWidget {
  final int index;
  final Animation<double> progress;
  final Widget child;

  const StaggeredPinAnimation({
    super.key,
    required this.index,
    required this.progress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Cascade across the first 4 masonry rows cleanly, while items below finish
    // within the same ~600ms wave so scrolled content is immediately ready.
    final clampedIndex = index.clamp(0, 7);
    final start = clampedIndex * 0.055;
    final fadeEnd = (start + 0.36).clamp(0.0, 1.0);
    final motionEnd = (start + 0.56).clamp(0.0, 1.0);
    const motionCurve = Cubic(0.22, 1.0, 0.36, 1.0);

    final opacity = CurvedAnimation(
      parent: progress,
      curve: Interval(start, fadeEnd, curve: Curves.easeOut),
    );
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.045),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: progress,
        curve: Interval(start, motionEnd, curve: motionCurve),
      ),
    );
    final scale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: progress,
        curve: Interval(start, motionEnd, curve: motionCurve),
      ),
    );

    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: slide,
        child: ScaleTransition(
          scale: scale,
          child: child,
        ),
      ),
    );
  }
}
