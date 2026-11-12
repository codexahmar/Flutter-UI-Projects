import 'package:flutter/material.dart';

class AnimatedSection extends StatelessWidget {
  const AnimatedSection({
    super.key,
    required this.progress,
    required this.start,
    required this.end,
    required this.child,
  });

  final Animation<double> progress;
  final double start;
  final double end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fadeCurve = CurvedAnimation(
      parent: progress,
      curve: Interval(start, end, curve: Curves.easeOutQuart),
    );
    final dropCurve = CurvedAnimation(
      parent: progress,
      curve: Interval(start, end, curve: Curves.easeOutBack),
    );

    return AnimatedBuilder(
      animation: progress,
      child: child,
      builder: (context, animatedChild) {
        final fadeT = fadeCurve.value;
        final dropT = dropCurve.value;
        const dropDistance = -78.0;
        const initialScale = 0.93;
        final scale = initialScale + (1 - initialScale) * fadeT;
        final dy = dropDistance * (1 - dropT);

        return Opacity(
          opacity: fadeT,
          child: Transform.translate(
            offset: Offset(0, dy),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: animatedChild,
            ),
          ),
        );
      },
    );
  }
}
