import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';

/// Top-down vehicle marker rendered once and GPU-transformed along the route.
class CarMarker extends StatelessWidget {
  const CarMarker({super.key});

  static const double size = 48;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Driver vehicle',
      excludeSemantics: true,
      child: const SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _CarPainter()),
      ),
    );
  }
}

class _CarPainter extends CustomPainter {
  const _CarPainter();

  static final _shadowPaint = Paint()..color = RideColors.shadow;
  static final _bodyPaint = Paint()..color = RideColors.textPrimary;
  static final _cabinPaint = Paint()..color = RideColors.canvas;
  static final _lightPaint = Paint()..color = RideColors.accent;
  static final _tirePaint = Paint()..color = RideColors.surfaceSubtle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + 2),
          width: 36,
          height: 20,
        ),
        const Radius.circular(8),
      ),
      _shadowPaint,
    );

    const wheelOffsets = [
      Offset(-11, -11),
      Offset(-11, 8),
      Offset(5, -11),
      Offset(5, 8),
    ];
    for (final offset in wheelOffsets) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(center.dx + offset.dx, center.dy + offset.dy, 7, 3),
          const Radius.circular(2),
        ),
        _tirePaint,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 34, height: 18),
        const Radius.circular(8),
      ),
      _bodyPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + 2, center.dy),
          width: 16,
          height: 12,
        ),
        const Radius.circular(5),
      ),
      _cabinPaint,
    );

    canvas.drawCircle(Offset(center.dx + 14.5, center.dy - 5), 1.6, _lightPaint);
    canvas.drawCircle(Offset(center.dx + 14.5, center.dy + 5), 1.6, _lightPaint);
  }

  @override
  bool shouldRepaint(covariant _CarPainter oldDelegate) => false;
}
