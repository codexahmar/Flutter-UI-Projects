import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Soft overhead studio rim wash that tracks horizontal swipe progress.
class StudioRimLight extends StatelessWidget {
  final Color accentColor;
  final double page;

  const StudioRimLight({
    super.key,
    required this.accentColor,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalFocus = 0.72 - 0.55 * math.sin((page / 3.0) * math.pi);

    return IgnorePointer(
      child: RepaintBoundary(
        child: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(horizontalFocus, -1.18),
                radius: 1.18,
                colors: [
                  accentColor.withValues(alpha: 0.14),
                  accentColor.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.44, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

