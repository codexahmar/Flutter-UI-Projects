import 'package:flutter/material.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Realistic top-down delivery motorcycle & rider marker pointing east (+X) at angle 0.
class DeliveryScooterMarker extends StatelessWidget {
  final double size;
  final bool isMoving;

  const DeliveryScooterMarker({
    super.key,
    this.size = 54,
    this.isMoving = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ScooterTopDownPainter(isMoving: isMoving),
      ),
    );
  }
}

class _ScooterTopDownPainter extends CustomPainter {
  final bool isMoving;

  const _ScooterTopDownPainter({required this.isMoving});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = size.width / 54.0;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.scale(scale);

    // Subtle ground halo & contact shadow.
    canvas.drawCircle(
      Offset.zero,
      20,
      Paint()..color = FoodColors.surface.withValues(alpha: 0.72),
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-1, 2.5), width: 34, height: 15),
      Paint()
        ..color = const Color(0x36141518)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Subtle warm headlight beam when actively riding.
    if (isMoving) {
      final beamPath = Path()
        ..moveTo(15, -2.5)
        ..lineTo(27, -7.5)
        ..lineTo(27, 7.5)
        ..lineTo(15, 2.5)
        ..close();
      canvas.drawPath(
        beamPath,
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0x66FFE8A3), Color(0x00FFE8A3)],
          ).createShader(const Rect.fromLTWH(15, -8, 12, 16)),
      );
    }

    // Rear and front tires.
    final tirePaint = Paint()..color = const Color(0xFF1F2228);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(-12.5, 0), width: 10, height: 4.8),
        const Radius.circular(2.4),
      ),
      tirePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(12.5, 0), width: 10.5, height: 4.4),
        const Radius.circular(2.2),
      ),
      tirePaint,
    );

    // Motorcycle chassis & silver exhaust pipe.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(-8, 4.2), width: 11, height: 2.2),
        const Radius.circular(1.1),
      ),
      Paint()..color = const Color(0xFFB5BAC4),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, 0), width: 22, height: 8.4),
        const Radius.circular(4.2),
      ),
      Paint()..color = const Color(0xFF2B2F38),
    );

    // Front mudguard & warm headlight lens.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(11, 0), width: 8, height: 5.8),
        const Radius.circular(2.9),
      ),
      Paint()..color = FoodColors.accent,
    );
    canvas.drawCircle(
      const Offset(15.2, 0),
      2.1,
      Paint()..color = const Color(0xFFFFF4C4),
    );

    // Handlebar & side mirrors.
    final barPaint = Paint()
      ..color = const Color(0xFF1A1D24)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(6.8, -8.5), const Offset(6.8, 8.5), barPaint);

    final gripPaint = Paint()
      ..color = const Color(0xFF474C57)
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(6.8, -8.5), const Offset(6.8, -5.8), gripPaint);
    canvas.drawLine(const Offset(6.8, 5.8), const Offset(6.8, 8.5), gripPaint);

    // Tail lamp.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(-14.8, 0), width: 2.2, height: 4),
        const Radius.circular(1),
      ),
      Paint()..color = const Color(0xFFEF4444),
    );

    // Rider arms reaching handlebars & dark jacket torso.
    final jacketPaint = Paint()..color = const Color(0xFF232730);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(1.5, 0), width: 8.5, height: 13.5),
        const Radius.circular(4.2),
      ),
      jacketPaint,
    );
    final armPaint = Paint()
      ..color = const Color(0xFF232730)
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(2.2, -5.4), const Offset(6.4, -7.2), armPaint);
    canvas.drawLine(const Offset(2.2, 5.4), const Offset(6.4, 7.2), armPaint);

    // Branded vermilion insulated food delivery box mounted on tail rack.
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(-7.2, 0), width: 10.5, height: 12.2),
      const Radius.circular(2.8),
    );
    canvas.drawRRect(boxRect, Paint()..color = FoodColors.accent);
    canvas.drawRRect(
      boxRect,
      Paint()
        ..color = FoodColors.inkOnAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1,
    );
    // Crisp lid strap across insulated bag.
    canvas.drawLine(
      const Offset(-7.2, -5.4),
      const Offset(-7.2, 5.4),
      Paint()
        ..color = FoodColors.inkOnAccent.withValues(alpha: 0.85)
        ..strokeWidth = 1.4,
    );

    // Rider helmet & forward-facing visor.
    canvas.drawCircle(
      const Offset(2.2, 0),
      5.5,
      Paint()..color = FoodColors.surface,
    );
    canvas.drawCircle(
      const Offset(2.2, 0),
      5.5,
      Paint()
        ..color = FoodColors.textPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(2.8, 0), radius: 4.3),
      -0.85,
      1.7,
      false,
      Paint()
        ..color = const Color(0xFF141518)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScooterTopDownPainter oldDelegate) {
    return oldDelegate.isMoving != isMoving;
  }
}

