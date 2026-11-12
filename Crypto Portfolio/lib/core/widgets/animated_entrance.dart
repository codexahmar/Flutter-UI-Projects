import 'package:flutter/material.dart';

class AnimatedEntrance extends StatelessWidget {
  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 520),
    this.offset = const Offset(0, 20),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final totalMs = duration.inMilliseconds + delay.inMilliseconds;
    final begin = totalMs == 0 ? 0.0 : delay.inMilliseconds / totalMs;
    final intervalStart = begin.clamp(0.0, 1.0).toDouble();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: totalMs),
      curve: Interval(intervalStart, 1, curve: Curves.easeOutCubic),
      child: child,
      builder: (context, value, animatedChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(offset.dx * (1 - value), offset.dy * (1 - value)),
            child: animatedChild,
          ),
        );
      },
    );
  }
}
