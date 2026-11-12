import 'package:flutter/material.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Realistic top-down delivery motorcycle marker pointing east (+X) with waiting radar pulse.
class DeliveryScooterMarker extends StatefulWidget {
  final double size;
  final bool isWaiting;
  final bool isMoving;

  const DeliveryScooterMarker({
    super.key,
    this.size = 54,
    this.isWaiting = false,
    this.isMoving = true,
  });

  @override
  State<DeliveryScooterMarker> createState() => _DeliveryScooterMarkerState();
}

class _DeliveryScooterMarkerState extends State<DeliveryScooterMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    if (widget.isWaiting) {
      _pulseController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant DeliveryScooterMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isWaiting && !_pulseController.isAnimating) {
      _pulseController.repeat();
    } else if (!widget.isWaiting && _pulseController.isAnimating) {
      _pulseController
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, _) {
          return CustomPaint(
            painter: _ScooterTopDownPainter(
              isWaiting: widget.isWaiting,
              isMoving: widget.isMoving,
              pulse: _pulseController.value,
            ),
          );
        },
      ),
    );
  }
}

class _ScooterTopDownPainter extends CustomPainter {
  final bool isWaiting;
  final bool isMoving;
  final double pulse;

  const _ScooterTopDownPainter({
    required this.isWaiting,
    required this.isMoving,
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = size.width / 54.0;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.scale(scale);

    // Live pulsing radar rings & blinking beacon while confirmed/preparing at pickup.
    if (isWaiting) {
      final outerRadius = 15 + (pulse * 19);
      final outerAlpha = (1.0 - pulse).clamp(0.0, 1.0) * 0.45;
      canvas.drawCircle(
        Offset.zero,
        outerRadius,
        Paint()
          ..color = FoodColors.accent.withValues(alpha: outerAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4,
      );

      final innerT = (pulse + 0.45) % 1.0;
      final innerRadius = 13 + (innerT * 15);
      final innerAlpha = (1.0 - innerT).clamp(0.0, 1.0) * 0.30;
      canvas.drawCircle(
        Offset.zero,
        innerRadius,
        Paint()..color = FoodColors.accent.withValues(alpha: innerAlpha),
      );
    }

    // Ground halo & contact shadow.
    canvas.drawCircle(
      Offset.zero,
      19,
      Paint()..color = FoodColors.surface.withValues(alpha: 0.78),
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-1, 2.5), width: 34, height: 15),
      Paint()
        ..color = const Color(0x36171310)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Warm directional headlight beam once actively riding.
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
        Rect.fromCenter(center: const Offset(-12.5, 0), width: 10, height: 4.8),
        const Radius.circular(2.4),
      ),
      tirePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(12.5, 0), width: 10.5, height: 4.4),
        const Radius.circular(2.2),
      ),
      tirePaint,
    );

    // Exhaust pipe & motorcycle frame.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(-8, 4.2), width: 11, height: 2.2),
        const Radius.circular(1.1),
      ),
      Paint()..color = const Color(0xFFB5BAC4),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 22, height: 8.4),
        const Radius.circular(4.2),
      ),
      Paint()..color = const Color(0xFF2B2F38),
    );

    // Front mudguard & warm headlight lens.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(11, 0), width: 8, height: 5.8),
        const Radius.circular(2.9),
      ),
      Paint()..color = FoodColors.accent,
    );
    canvas.drawCircle(
      const Offset(15.2, 0),
      2.1,
      Paint()..color = const Color(0xFFFFF4C4),
    );

    // Handlebar & grips.
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

    // Hazard taillight (blinks softly while waiting at restaurant).
    final hazardOn = !isWaiting || pulse < 0.55;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(-14.8, 0), width: 2.4, height: 4.4),
        const Radius.circular(1.2),
      ),
      Paint()
        ..color = hazardOn
            ? FoodColors.accent
            : FoodColors.accent.withValues(alpha: 0.25),
    );

    // Rider jacket & arms reaching handlebars.
    final jacketPaint = Paint()..color = const Color(0xFF232730);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(1.5, 0), width: 8.5, height: 13.5),
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

    // Insulated terracotta delivery box on tail rack.
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: const Offset(-7.2, 0), width: 10.5, height: 12.2),
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
        ..color = const Color(0xFF171310)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScooterTopDownPainter oldDelegate) {
    return oldDelegate.isWaiting != isWaiting ||
        oldDelegate.isMoving != isMoving ||
        oldDelegate.pulse != pulse;
  }
}
