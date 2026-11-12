import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Shared geometry helper guaranteeing roads, markers, and rider stay locked to street coordinates.
abstract final class DeliveryMapLayout {
  static const double _yMarketRow = 0.21;
  static const double _yMargallaRd = 0.40;
  static const double _yServiceLn = 0.56;

  static const double _xJinnahAve = 0.17;
  static const double _xCentralAve = 0.43;
  static const double _xStreet8 = 0.78;

  static Offset restaurantPoint(Size size) =>
      Offset(size.width * _xJinnahAve, size.height * _yMarketRow);

  static Offset marketCentralIntersection(Size size) =>
      Offset(size.width * _xCentralAve, size.height * _yMarketRow);

  static Offset centralMargallaIntersection(Size size) =>
      Offset(size.width * _xCentralAve, size.height * _yMargallaRd);

  static Offset margallaStreet8Intersection(Size size) =>
      Offset(size.width * _xStreet8, size.height * _yMargallaRd);

  static Offset homePoint(Size size) =>
      Offset(size.width * _xStreet8, size.height * _yServiceLn);

  /// Exact route centerline path following Market Row -> Central Ave -> Margalla Rd -> Street 8.
  static Path buildRoutePath(Size size) {
    final p0 = restaurantPoint(size);
    final p1 = marketCentralIntersection(size);
    final p2 = centralMargallaIntersection(size);
    final p3 = margallaStreet8Intersection(size);
    final p4 = homePoint(size);
    const corner = 12.0;

    return Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx - corner, p1.dy)
      ..quadraticBezierTo(p1.dx, p1.dy, p1.dx, p1.dy + corner)
      ..lineTo(p2.dx, p2.dy - corner)
      ..quadraticBezierTo(p2.dx, p2.dy, p2.dx + corner, p2.dy)
      ..lineTo(p3.dx - corner, p3.dy)
      ..quadraticBezierTo(p3.dx, p3.dy, p3.dx, p3.dy + corner)
      ..lineTo(p4.dx, p4.dy);
  }
}

/// Editorial 3-color neighborhood cartography harmonized with Warm Ivory, Espresso, and Terracotta.
class DeliveryMapPainter extends CustomPainter {
  final double progress;
  final String restaurantName;

  const DeliveryMapPainter({
    required this.progress,
    required this.restaurantName,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = FoodColors.mapLand);

    _drawLandUse(canvas, size);
    _drawBuildings(canvas, size);
    _drawRoadNetwork(canvas, size);
    _drawStreetLabels(canvas, size);
    _drawActiveRoute(canvas, size);
    _drawPlaceLabels(canvas, size);
  }

  void _drawLandUse(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // F-10 Plaza courtyard block between Jinnah Ave and Central Ave.
    final plazaRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.21, h * 0.43, w * 0.39, h * 0.535),
      const Radius.circular(10),
    );
    canvas.drawRRect(plazaRect, Paint()..color = FoodColors.mapPark);

    // Subtle courtyard promenade path.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.22, h * 0.51)
        ..quadraticBezierTo(w * 0.30, h * 0.48, w * 0.38, h * 0.45),
      Paint()
        ..color = FoodColors.surface.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // Architectural plaza planters rendered in warm stone tones.
    const plazaTrees = [
      Offset(0.245, 0.458),
      Offset(0.285, 0.448),
      Offset(0.352, 0.466),
      Offset(0.262, 0.512),
      Offset(0.335, 0.514),
    ];
    final planterPaint = Paint()..color = FoodColors.mapParkTree;
    for (final pt in plazaTrees) {
      canvas.drawCircle(Offset(w * pt.dx, h * pt.dy), 6.2, planterPaint);
    }

    // Recessed eastern corridor along Nullah Walk.
    final corridorPath = Path()
      ..moveTo(w * 0.91, 0)
      ..cubicTo(
        w * 0.87,
        h * 0.18,
        w * 0.94,
        h * 0.36,
        w * 0.89,
        h * 0.66,
      );
    canvas.drawPath(
      corridorPath,
      Paint()
        ..color = FoodColors.mapWater
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawBuildings(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final footprints = <Rect>[
      Rect.fromLTRB(w * 0.06, h * 0.125, w * 0.145, h * 0.188),
      Rect.fromLTRB(w * 0.215, h * 0.115, w * 0.385, h * 0.182),
      Rect.fromLTRB(w * 0.47, h * 0.238, w * 0.615, h * 0.328),
      Rect.fromLTRB(w * 0.635, h * 0.265, w * 0.745, h * 0.368),
      Rect.fromLTRB(w * 0.48, h * 0.115, w * 0.71, h * 0.182),
      Rect.fromLTRB(w * 0.475, h * 0.432, w * 0.615, h * 0.525),
      Rect.fromLTRB(w * 0.64, h * 0.435, w * 0.74, h * 0.528),
      Rect.fromLTRB(w * 0.805, h * 0.495, w * 0.875, h * 0.542),
      Rect.fromLTRB(w * 0.055, h * 0.245, w * 0.135, h * 0.345),
      Rect.fromLTRB(w * 0.22, h * 0.248, w * 0.385, h * 0.358),
      Rect.fromLTRB(w * 0.06, h * 0.435, w * 0.135, h * 0.525),
    ];

    final wallPaint = Paint()..color = FoodColors.mapBuilding;
    final roofPaint = Paint()..color = FoodColors.mapBuildingTop;
    final strokePaint = Paint()
      ..color = FoodColors.mapBuildingBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final rect in footprints) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect.shift(const Offset(0, 3.5)),
          const Radius.circular(4.5),
        ),
        wallPaint,
      );
      final roof = RRect.fromRectAndRadius(rect, const Radius.circular(4.5));
      canvas.drawRRect(roof, roofPaint);
      canvas.drawRRect(roof, strokePaint);
    }
  }

  void _drawRoadNetwork(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final minorRoads = <List<Offset>>[
      [Offset(0, h * 0.21), Offset(w, h * 0.21)],
      [Offset(0, h * 0.56), Offset(w * 0.88, h * 0.56)],
      [Offset(w * 0.17, 0), Offset(w * 0.17, h * 0.68)],
      [Offset(w * 0.78, h * 0.08), Offset(w * 0.78, h * 0.66)],
    ];

    final majorRoads = <List<Offset>>[
      [Offset(0, h * 0.40), Offset(w, h * 0.40)],
      [Offset(w * 0.43, 0), Offset(w * 0.43, h * 0.70)],
    ];

    void strokeRoad(List<Offset> seg, double width, Color color) {
      canvas.drawLine(
        seg[0],
        seg[1],
        Paint()
          ..color = color
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
    }

    for (final seg in minorRoads) {
      strokeRoad(seg, 15, FoodColors.mapRoadCasing);
    }
    for (final seg in majorRoads) {
      strokeRoad(seg, 20, FoodColors.mapRoadCasing);
    }

    for (final seg in minorRoads) {
      strokeRoad(seg, 12.5, FoodColors.mapRoadMinor);
    }
    for (final seg in majorRoads) {
      strokeRoad(seg, 17, FoodColors.mapRoadMajor);
    }

    final centerDash = Paint()
      ..color = FoodColors.mapRoadCasing
      ..strokeWidth = 1.2;
    for (double x = 14; x < w - 14; x += 18) {
      canvas.drawLine(
        Offset(x, h * 0.40),
        Offset(x + 8, h * 0.40),
        centerDash,
      );
    }
  }

  void _drawStreetLabels(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _paintMapText(
      canvas,
      text: 'Market Row',
      center: Offset(w * 0.62, h * 0.21),
      color: FoodColors.mapStreetLabel,
      fontSize: 9.5,
      weight: FontWeight.w600,
    );
    _paintMapText(
      canvas,
      text: 'Margalla Rd',
      center: Offset(w * 0.27, h * 0.40),
      color: FoodColors.mapStreetLabel,
      fontSize: 10,
      weight: FontWeight.w700,
    );
    _paintMapText(
      canvas,
      text: 'Service Ln',
      center: Offset(w * 0.56, h * 0.56),
      color: FoodColors.mapStreetLabel,
      fontSize: 9.5,
      weight: FontWeight.w600,
    );
    _paintMapText(
      canvas,
      text: 'Central Ave',
      center: Offset(w * 0.43, h * 0.14),
      color: FoodColors.mapStreetLabel,
      fontSize: 9.5,
      weight: FontWeight.w600,
      angleRadians: math.pi / 2,
    );
    _paintMapText(
      canvas,
      text: 'Street 8',
      center: Offset(w * 0.78, h * 0.30),
      color: FoodColors.mapStreetLabel,
      fontSize: 9.5,
      weight: FontWeight.w600,
      angleRadians: -math.pi / 2,
    );
  }

  void _drawActiveRoute(Canvas canvas, Size size) {
    final routePath = DeliveryMapLayout.buildRoutePath(size);
    final metric = routePath.computeMetrics().first;
    final currentLen = metric.length * progress.clamp(0.0, 1.0);

    canvas.drawPath(
      routePath,
      Paint()
        ..color = FoodColors.accent.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    if (currentLen > 1) {
      final completed = metric.extractPath(0, currentLen);
      canvas.drawPath(
        completed,
        Paint()
          ..color = FoodColors.surface
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        completed,
        Paint()
          ..color = FoodColors.accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  void _drawPlaceLabels(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final places = [
      ('City Bakery', Offset(w * 0.30, h * 0.148), FoodColors.mapLabel),
      ('Tech Hub', Offset(w * 0.595, h * 0.148), FoodColors.mapLabel),
      ('Fresh Mart', Offset(w * 0.542, h * 0.283), FoodColors.mapLabel),
      ('Central Plaza', Offset(w * 0.69, h * 0.316), FoodColors.mapLabel),
      ('F-10 Courtyard', Offset(w * 0.30, h * 0.483), FoodColors.mapLabel),
      ('Greenway Apt', Offset(w * 0.545, h * 0.478), FoodColors.mapLabel),
      (restaurantName, Offset(w * 0.102, h * 0.156), FoodColors.accentInk),
      ('House 12', Offset(w * 0.84, h * 0.518), FoodColors.textPrimary),
    ];

    for (final (label, pos, color) in places) {
      _paintMapText(
        canvas,
        text: label,
        center: pos,
        color: color,
        fontSize: 9.5,
        weight: FontWeight.w700,
        halo: true,
      );
    }
  }

  void _paintMapText(
    Canvas canvas, {
    required String text,
    required Offset center,
    required Color color,
    required double fontSize,
    required FontWeight weight,
    double angleRadians = 0,
    bool halo = false,
  }) {
    final span = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: weight,
        letterSpacing: -0.1,
      ),
    );
    final painter = TextPainter(
      text: span,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 96);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (angleRadians != 0) {
      canvas.rotate(angleRadians);
    }
    final topLeft = Offset(-painter.width / 2, -painter.height / 2);
    if (halo) {
      final haloPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: weight,
            letterSpacing: -0.1,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.6
              ..color = FoodColors.surface.withValues(alpha: 0.92),
          ),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 96);
      haloPainter.paint(canvas, topLeft);
    }
    painter.paint(canvas, topLeft);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DeliveryMapPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.restaurantName != restaurantName;
  }
}
