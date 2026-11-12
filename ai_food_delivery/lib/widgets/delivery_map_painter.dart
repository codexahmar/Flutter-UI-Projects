import 'package:flutter/material.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Clean dark-mode vector map with district blocks, roads, and delivery route.
class DeliveryMapPainter extends CustomPainter {
  final List<Offset> routePoints;
  final double routeProgress;
  final double pulseProgress;
  final bool isSearching;

  const DeliveryMapPainter({
    required this.routePoints,
    required this.routeProgress,
    required this.pulseProgress,
    required this.isSearching,
  });

  static Path buildRoutePath(List<Offset> routePoints, Size size) {
    final points = routePoints
        .map((point) => Offset(point.dx * size.width, point.dy * size.height))
        .toList();

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      path.cubicTo(
        previous.dx + (current.dx - previous.dx) * 0.42,
        previous.dy - 16,
        previous.dx + (current.dx - previous.dx) * 0.58,
        current.dy + 16,
        current.dx,
        current.dy,
      );
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = FoodColors.canvas);
    _drawRoads(canvas, size);
    _drawBlocks(canvas, size);
    _drawLabels(canvas, size);
    _drawRoute(canvas, size);
    if (isSearching) {
      _drawSearchPulse(canvas, size);
    }
  }

  void _drawRoads(Canvas canvas, Size size) {
    final roadCasing = Paint()
      ..color = FoodColors.mapRoadCasing
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    final roadFill = Paint()
      ..color = FoodColors.mapRoad
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    final roads = [
      Path()
        ..moveTo(-40, size.height * 0.31)
        ..cubicTo(
          size.width * 0.20,
          size.height * 0.21,
          size.width * 0.52,
          size.height * 0.42,
          size.width + 40,
          size.height * 0.29,
        ),
      Path()
        ..moveTo(size.width * 0.12, -40)
        ..cubicTo(
          size.width * 0.15,
          size.height * 0.26,
          size.width * 0.30,
          size.height * 0.55,
          size.width * 0.18,
          size.height + 40,
        ),
      Path()
        ..moveTo(size.width + 40, size.height * 0.62)
        ..cubicTo(
          size.width * 0.72,
          size.height * 0.50,
          size.width * 0.46,
          size.height * 0.67,
          -40,
          size.height * 0.69,
        ),
    ];

    for (final road in roads) {
      canvas.drawPath(road, roadCasing);
      canvas.drawPath(road, roadFill);
    }
  }

  void _drawBlocks(Canvas canvas, Size size) {
    final fill = Paint()..color = FoodColors.mapBlock;
    final border = Paint()
      ..color = FoodColors.border.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final blocks = [
      Rect.fromLTWH(size.width * 0.06, size.height * 0.14, 88, 56),
      Rect.fromLTWH(size.width * 0.32, size.height * 0.15, 118, 66),
      Rect.fromLTWH(size.width * 0.64, size.height * 0.14, 108, 68),
      Rect.fromLTWH(size.width * 0.08, size.height * 0.48, 120, 74),
      Rect.fromLTWH(size.width * 0.54, size.height * 0.35, 126, 86),
      Rect.fromLTWH(size.width * 0.62, size.height * 0.66, 114, 62),
    ];

    for (final rect in blocks) {
      final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(14));
      canvas.drawRRect(rRect, fill);
      canvas.drawRRect(rRect, border);
    }
  }

  void _drawLabels(Canvas canvas, Size size) {
    _drawLabel(
      canvas,
      'Market Row',
      Offset(size.width * 0.18, size.height * 0.28),
    );
    _drawLabel(
      canvas,
      'Central Ave',
      Offset(size.width * 0.54, size.height * 0.36),
    );
    _drawLabel(
      canvas,
      'F-10/2',
      Offset(size.width * 0.64, size.height * 0.61),
    );
  }

  void _drawLabel(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: FoodColors.mapLabel,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  void _drawSearchPulse(Canvas canvas, Size size) {
    final restaurantPoint = Offset(
      size.width * routePoints.first.dx,
      size.height * routePoints.first.dy,
    );
    for (var i = 0; i < 2; i++) {
      final wave = (pulseProgress * 4 + i * 0.5) % 1;
      canvas.drawCircle(
        restaurantPoint,
        24 + wave * 54,
        Paint()
          ..color = FoodColors.accent.withValues(alpha: (1 - wave) * 0.28)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8,
      );
    }
  }

  void _drawRoute(Canvas canvas, Size size) {
    final path = buildRoutePath(routePoints, size);
    final metric = path.computeMetrics().first;
    final activeLength = metric.length * routeProgress;

    canvas.drawPath(
      path,
      Paint()
        ..color = FoodColors.surfaceSubtle
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = FoodColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    if (activeLength > 0) {
      final activePath = metric.extractPath(0, activeLength);
      canvas.drawPath(
        activePath,
        Paint()
          ..color = routeProgress >= 1 ? FoodColors.success : FoodColors.accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DeliveryMapPainter oldDelegate) {
    return oldDelegate.routeProgress != routeProgress ||
        oldDelegate.pulseProgress != pulseProgress ||
        oldDelegate.isSearching != isSearching;
  }
}

