import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';
import 'package:ride_tracking/widgets/ride_status_card.dart';

/// Vertical two-stop step indicator showing pickup selection, live approach, and drop-off transit progress.
class RouteStepIndicator extends StatelessWidget {
  final RidePhase phase;
  final bool destinationReady;
  final ValueListenable<double>? routeProgress;
  final double height;

  const RouteStepIndicator({
    super.key,
    required this.phase,
    this.destinationReady = true,
    this.routeProgress,
    this.height = 46,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: height,
      child: CustomPaint(
        painter: _StepTrackPainter(
          phase: phase,
          destinationReady: destinationReady,
          routeProgress: routeProgress,
        ),
      ),
    );
  }
}

class _StepTrackPainter extends CustomPainter {
  final RidePhase phase;
  final bool destinationReady;
  final ValueListenable<double>? routeProgress;

  _StepTrackPainter({
    required this.phase,
    required this.destinationReady,
    required this.routeProgress,
  }) : super(repaint: routeProgress);

  static final _accentFill = Paint()..color = RideColors.accent;
  static final _accentHalo = Paint()..color = RideColors.accentTint;
  static final _trackMuted = Paint()
    ..color = RideColors.border
    ..strokeWidth = 1.8
    ..strokeCap = StrokeCap.round;
  static final _trackActive = Paint()
    ..color = RideColors.accent
    ..strokeWidth = 2.2
    ..strokeCap = StrokeCap.round;
  static final _trackReady = Paint()
    ..color = RideColors.accent
    ..strokeWidth = 1.6
    ..strokeCap = StrokeCap.round;
  static final _destStroke = Paint()
    ..color = RideColors.textSecondary
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.6;
  static final _destFill = Paint()..color = RideColors.textPrimary;
  static final _checkStroke = Paint()
    ..color = RideColors.inkOnAccent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.6
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    const topY = 7.0;
    final bottomY = size.height - 7.0;

    final isInTrip = phase == RidePhase.inTrip;
    final isCompleted = phase == RidePhase.completed;
    final isArrived = phase == RidePhase.arrived;
    final isSelecting = phase == RidePhase.selecting;
    final tripT = isCompleted
        ? 1.0
        : (isInTrip ? (routeProgress?.value ?? 0.0).clamp(0.0, 1.0) : 0.0);

    // Connector line between Pickup and Destination
    const stemTop = topY + 8;
    final stemBottom = bottomY - 7;

    if (isInTrip || isCompleted) {
      canvas.drawLine(Offset(cx, stemTop), Offset(cx, stemBottom), _trackMuted);
      final fillY = stemTop + (stemBottom - stemTop) * tripT;
      if (fillY > stemTop) {
        canvas.drawLine(Offset(cx, stemTop), Offset(cx, fillY), _trackActive);
      }
      if (isInTrip && tripT > 0.02 && tripT < 0.98) {
        canvas.drawCircle(Offset(cx, fillY), 4.5, _accentHalo);
        canvas.drawCircle(Offset(cx, fillY), 2.5, _accentFill);
      }
    } else if (isSelecting && destinationReady) {
      canvas.drawLine(Offset(cx, stemTop), Offset(cx, stemBottom), _trackReady);
    } else {
      // Stepped dotted path leading from Pickup toward upcoming Destination
      final steps = isArrived ? 4 : 3;
      for (var i = 0; i < steps; i++) {
        final f = (i + 0.5) / steps;
        final dy = stemTop + (stemBottom - stemTop) * f;
        canvas.drawCircle(
          Offset(cx, dy),
          1.4,
          isArrived ? _accentFill : _trackMuted,
        );
      }
    }

    // Top step: Pickup node
    if (isInTrip || isCompleted) {
      canvas.drawCircle(Offset(cx, topY), 6, _accentFill);
      final tick = Path()
        ..moveTo(cx - 2.6, topY + 0.1)
        ..lineTo(cx - 0.7, topY + 2.0)
        ..lineTo(cx + 2.8, topY - 1.8);
      canvas.drawPath(tick, _checkStroke);
    } else {
      canvas.drawCircle(Offset(cx, topY), 7, _accentHalo);
      canvas.drawCircle(Offset(cx, topY), 4, _accentFill);
    }

    // Bottom step: Destination node
    final destRect = Rect.fromCenter(
      center: Offset(cx, bottomY),
      width: 8.5,
      height: 8.5,
    );
    final destRRect = RRect.fromRectAndRadius(
      destRect,
      const Radius.circular(2.2),
    );
    if (isCompleted || (isSelecting && destinationReady)) {
      canvas.drawRRect(
        destRRect,
        isCompleted ? _accentFill : _destFill,
      );
    } else if (isInTrip && tripT >= 0.96) {
      canvas.drawRRect(destRRect, _accentFill);
    } else {
      canvas.drawRRect(destRRect, _destStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _StepTrackPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.destinationReady != destinationReady ||
        oldDelegate.routeProgress != routeProgress;
  }
}
