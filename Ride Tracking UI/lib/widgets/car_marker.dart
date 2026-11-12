import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';

/// Top-down sculpted sedan marker for both the matched driver and ambient traffic.
class CarMarker extends StatelessWidget {
  final bool isAmbient;

  const CarMarker({super.key, this.isAmbient = false});

  static const double size = 56;

  @override
  Widget build(BuildContext context) {
    final widgetSize = isAmbient ? 44.0 : size;
    return Semantics(
      label: isAmbient ? 'Nearby vehicle' : 'Driver vehicle',
      excludeSemantics: true,
      child: SizedBox(
        width: widgetSize,
        height: widgetSize,
        child: CustomPaint(painter: _CarPainter(isAmbient: isAmbient)),
      ),
    );
  }
}

class _CarPainter extends CustomPainter {
  final bool isAmbient;

  const _CarPainter({required this.isAmbient});

  static final _shadowPaint = Paint()..color = RideColors.shadow;
  static final _tirePaint = Paint()..color = RideColors.mapRoadCasing;
  static final _cabinPaint = Paint()..color = RideColors.carCabin;
  static final _primaryBodyPaint = Paint()..color = RideColors.carBody;
  static final _ambientBodyPaint = Paint()..color = RideColors.ambientCarBody;
  static final _outlinePaint = Paint()
    ..color = RideColors.border
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  static final _creasePaint = Paint()
    ..color = RideColors.carTrim
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.8;
  static final _headlightPaint = Paint()..color = RideColors.textPrimary;
  static final _taillightPaint = Paint()..color = RideColors.carTaillight;
  static final _hull = _sedanHull();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final bodyPaint = isAmbient ? _ambientBodyPaint : _primaryBodyPaint;

    canvas.save();
    canvas.translate(c.dx, c.dy);
    if (isAmbient) {
      canvas.scale(0.8);
    }

    canvas.save();
    canvas.translate(0, 2.5);
    canvas.drawPath(_hull, _shadowPaint);
    canvas.restore();

    for (final rect in const [
      Rect.fromLTWH(-14.5, -10.3, 8, 2.2),
      Rect.fromLTWH(-14.5, 8.1, 8, 2.2),
      Rect.fromLTWH(8.5, -10.3, 8, 2.2),
      Rect.fromLTWH(8.5, 8.1, 8, 2.2),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1)),
        _tirePaint,
      );
    }

    for (final y in const [-10.8, 8.4]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(5.2, y, 3.2, 2.4),
          const Radius.circular(1.2),
        ),
        bodyPaint,
      );
    }

    canvas.drawPath(_hull, bodyPaint);
    canvas.drawPath(_hull, _outlinePaint);

    final glass = Path()
      ..moveTo(-15.5, -5.8)
      ..quadraticBezierTo(-17.0, 0, -15.5, 5.8)
      ..lineTo(-9.0, 7.0)
      ..lineTo(4.0, 7.2)
      ..lineTo(11.5, 6.2)
      ..quadraticBezierTo(13.2, 0, 11.5, -6.2)
      ..lineTo(4.0, -7.2)
      ..lineTo(-9.0, -7.0)
      ..close();
    canvas.drawPath(glass, _cabinPaint);

    final roof = Path()
      ..moveTo(-9.0, -5.4)
      ..lineTo(4.0, -5.6)
      ..quadraticBezierTo(5.2, 0, 4.0, 5.6)
      ..lineTo(-9.0, 5.4)
      ..quadraticBezierTo(-10.2, 0, -9.0, -5.4)
      ..close();
    canvas.drawPath(roof, bodyPaint);

    if (!isAmbient) {
      canvas.drawLine(
        const Offset(12.8, -4.4),
        const Offset(19.2, -3.5),
        _creasePaint,
      );
      canvas.drawLine(
        const Offset(12.8, 4.4),
        const Offset(19.2, 3.5),
        _creasePaint,
      );

      for (final y in const [-6.2, 4.0]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(19.4, y, 2.0, 2.2),
            const Radius.circular(1),
          ),
          _headlightPaint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(-20.4, y, 1.5, 2.4),
            const Radius.circular(0.8),
          ),
          _taillightPaint,
        );
      }
    }

    canvas.restore();
  }

  static Path _sedanHull() {
    return Path()
      ..moveTo(-19.5, -7.2)
      ..quadraticBezierTo(-21.2, 0, -19.5, 7.2)
      ..quadraticBezierTo(-15.0, 9.6, -9.0, 9.4)
      ..lineTo(5.0, 9.4)
      ..quadraticBezierTo(13.0, 9.4, 18.2, 7.8)
      ..quadraticBezierTo(22.2, 5.2, 22.2, 0)
      ..quadraticBezierTo(22.2, -5.2, 18.2, -7.8)
      ..quadraticBezierTo(13.0, -9.4, 5.0, -9.4)
      ..lineTo(-9.0, -9.4)
      ..quadraticBezierTo(-15.0, -9.6, -19.5, -7.2)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _CarPainter oldDelegate) {
    return oldDelegate.isAmbient != isAmbient;
  }
}
