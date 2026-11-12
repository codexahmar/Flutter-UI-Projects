import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';
import 'package:ride_tracking/widgets/car_marker.dart';
import 'package:ride_tracking/widgets/location_pin.dart';

/// Displays the static map grid, cached route progress, pins, and car marker.
class RideMap extends StatefulWidget {
  final List<Offset> routePoints;
  final ValueListenable<double> routeProgress;
  final bool showRoute;

  const RideMap({
    super.key,
    required this.routePoints,
    required this.routeProgress,
    required this.showRoute,
  });

  @override
  State<RideMap> createState() => _RideMapState();
}

class _RideMapState extends State<RideMap> {
  Size? _cachedSize;
  Path? _routePath;
  PathMetric? _routeMetric;

  void _ensureGeometry(Size size) {
    if (size.isEmpty || _cachedSize == size) return;
    _cachedSize = size;
    final path = _buildRoutePath(widget.routePoints, size);
    _routePath = path;
    _routeMetric = path.computeMetrics().firstOrNull;
  }

  @override
  void didUpdateWidget(covariant RideMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routePoints != widget.routePoints) {
      _cachedSize = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        _ensureGeometry(size);

        final first = widget.routePoints.first;
        final last = widget.routePoints.last;
        const pinHalf = LocationPin.size / 2;
        const carHalf = CarMarker.size / 2;

        return Stack(
          children: [
            const Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(painter: _StaticMapPainter()),
              ),
            ),
            if (widget.showRoute && _routePath != null && _routeMetric != null)
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _RoutePainter(
                      path: _routePath!,
                      metric: _routeMetric!,
                      progress: widget.routeProgress,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: size.width * first.dx - pinHalf,
              top: size.height * first.dy - pinHalf,
              child: const LocationPin(
                icon: Icons.trip_origin_rounded,
                color: RideColors.textSecondary,
                semanticLabel: 'Driver starting point',
              ),
            ),
            Positioned(
              left: size.width * last.dx - pinHalf,
              top: size.height * last.dy - pinHalf,
              child: const LocationPin(
                icon: Icons.my_location_rounded,
                color: RideColors.accent,
                semanticLabel: 'Pickup location',
              ),
            ),
            if (widget.showRoute && _routeMetric != null)
              Positioned(
                left: 0,
                top: 0,
                child: ValueListenableBuilder<double>(
                  valueListenable: widget.routeProgress,
                  child: const RepaintBoundary(child: CarMarker()),
                  builder: (context, progress, child) {
                    final metric = _routeMetric!;
                    final tangent = metric.getTangentForOffset(
                      metric.length * progress,
                    );
                    if (tangent == null) return const SizedBox.shrink();

                    final angle = math.atan2(
                      tangent.vector.dy,
                      tangent.vector.dx,
                    );
                    return Transform.translate(
                      offset: Offset(
                        tangent.position.dx - carHalf,
                        tangent.position.dy - carHalf,
                      ),
                      child: Transform.rotate(angle: angle, child: child),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

Path _buildRoutePath(List<Offset> normalizedPoints, Size size) {
  final path = Path()
    ..moveTo(
      normalizedPoints.first.dx * size.width,
      normalizedPoints.first.dy * size.height,
    );

  for (var i = 1; i < normalizedPoints.length; i++) {
    final prev = normalizedPoints[i - 1];
    final curr = normalizedPoints[i];
    final x = curr.dx * size.width;
    final y = curr.dy * size.height;

    if (curr.dx != prev.dx && curr.dy != prev.dy) {
      path.lineTo(x, prev.dy * size.height);
    }
    path.lineTo(x, y);
  }
  return path;
}

class _StaticMapPainter extends CustomPainter {
  const _StaticMapPainter();

  static final _bgPaint = Paint()..color = RideColors.canvas;
  static final _blockPaint = Paint()..color = RideColors.mapBlock;
  static final _dotPaint = Paint()..color = RideColors.mapLandmark;
  static final _majorRoadPaint = Paint()
    ..color = RideColors.mapRoadMajor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 24
    ..strokeCap = StrokeCap.round;
  static final _minorRoadPaint = Paint()
    ..color = RideColors.mapRoadMinor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 14
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, _bgPaint);

    final blocks = [
      Rect.fromLTWH(size.width * 0.08, size.height * 0.14, 88, 56),
      Rect.fromLTWH(size.width * 0.56, size.height * 0.14, 120, 72),
      Rect.fromLTWH(size.width * 0.18, size.height * 0.42, 110, 80),
      Rect.fromLTWH(size.width * 0.62, size.height * 0.43, 94, 108),
      Rect.fromLTWH(size.width * 0.10, size.height * 0.78, 128, 76),
      Rect.fromLTWH(size.width * 0.58, size.height * 0.72, 120, 68),
    ];
    for (final rect in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(RideRadius.md)),
        _blockPaint,
      );
    }

    final road1 = Path()
      ..moveTo(-40, size.height * 0.28)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.18,
        size.width * 0.38,
        size.height * 0.42,
        size.width + 40,
        size.height * 0.32,
      );
    final road2 = Path()
      ..moveTo(size.width * 0.16, -40)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.28,
        size.width * 0.14,
        size.height * 0.62,
        size.width * 0.36,
        size.height + 40,
      );
    final road3 = Path()
      ..moveTo(size.width + 40, size.height * 0.68)
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.58,
        size.width * 0.42,
        size.height * 0.74,
        -40,
        size.height * 0.84,
      );

    canvas.drawPath(road1, _majorRoadPaint);
    canvas.drawPath(road2, _minorRoadPaint);
    canvas.drawPath(road3, _majorRoadPaint);

    final landmarks = [
      Offset(size.width * 0.18, size.height * 0.58),
      Offset(size.width * 0.78, size.height * 0.30),
      Offset(size.width * 0.42, size.height * 0.20),
      Offset(size.width * 0.50, size.height * 0.82),
      Offset(size.width * 0.86, size.height * 0.58),
    ];
    for (final dot in landmarks) {
      canvas.drawCircle(dot, 3, _dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StaticMapPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  final Path path;
  final PathMetric metric;
  final ValueListenable<double> progress;

  _RoutePainter({
    required this.path,
    required this.metric,
    required this.progress,
  }) : super(repaint: progress);

  static final _trackPaint = Paint()
    ..color = RideColors.routeTrack
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  static final _activePaint = Paint()
    ..color = RideColors.accent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path, _trackPaint);
    final t = progress.value;
    if (t > 0) {
      canvas.drawPath(metric.extractPath(0, metric.length * t), _activePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) {
    return oldDelegate.path != path || oldDelegate.metric != metric;
  }
}

