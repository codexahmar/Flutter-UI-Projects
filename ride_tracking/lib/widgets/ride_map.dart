import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';
import 'package:ride_tracking/widgets/car_marker.dart';
import 'package:ride_tracking/widgets/customer_marker.dart';
import 'package:ride_tracking/widgets/ride_status_card.dart';

/// Vector street map with interactive pin placement, ambient traffic/riders, boarding, and drop-off route tracking.
class RideMap extends StatefulWidget {
  final Offset pickupPoint;
  final Offset? destinationPoint;
  final String pickupLabel;
  final String? destinationLabel;
  final List<Offset> driverRoutePoints;
  final List<Offset> tripRoutePoints;
  final ValueListenable<double> routeProgress;
  final ValueListenable<double> boardingProgress;
  final ValueListenable<double> trafficProgress;
  final RidePhase phase;
  final bool cameraFollow;
  final ValueChanged<Offset>? onMapTap;

  const RideMap({
    super.key,
    required this.pickupPoint,
    required this.destinationPoint,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.driverRoutePoints,
    required this.tripRoutePoints,
    required this.routeProgress,
    required this.boardingProgress,
    required this.trafficProgress,
    required this.phase,
    required this.cameraFollow,
    this.onMapTap,
  });

  @override
  State<RideMap> createState() => _RideMapState();
}

class _RideMapState extends State<RideMap> {
  static const _ambientRoutes = [
    [Offset(0.145, 0.12), Offset(0.16, 0.58), Offset(0.185, 0.90)],
    [Offset(0.515, 0.88), Offset(0.49, 0.50), Offset(0.46, 0.14)],
    [Offset(0.94, 0.425), Offset(0.56, 0.45), Offset(0.06, 0.45)],
  ];
  static const _ambientOffsets = [0.0, 0.37, 0.68];
  static const _ambientRiders = [Offset(0.27, 0.37), Offset(0.58, 0.60)];

  Size? _cachedSize;
  Path? _driverPath;
  PathMetric? _driverMetric;
  Path? _tripPath;
  PathMetric? _tripMetric;
  List<PathMetric> _trafficMetrics = const [];

  void _ensureGeometry(Size size) {
    if (size.isEmpty) return;
    if (_cachedSize != size) {
      _cachedSize = size;
      _trafficMetrics = [
        for (final pts in _ambientRoutes)
          ..._buildSmoothPath(pts, size).computeMetrics().take(1),
      ];
      _rebuildRoutes(size);
    }
  }

  void _rebuildRoutes(Size size) {
    if (widget.driverRoutePoints.length >= 2) {
      final path = _buildSmoothPath(widget.driverRoutePoints, size);
      _driverPath = path;
      _driverMetric = path.computeMetrics().firstOrNull;
    } else {
      _driverPath = null;
      _driverMetric = null;
    }

    if (widget.tripRoutePoints.length >= 2) {
      final path = _buildSmoothPath(widget.tripRoutePoints, size);
      _tripPath = path;
      _tripMetric = path.computeMetrics().firstOrNull;
    } else {
      _tripPath = null;
      _tripMetric = null;
    }
  }

  @override
  void didUpdateWidget(covariant RideMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_cachedSize != null &&
        (!listEquals(oldWidget.driverRoutePoints, widget.driverRoutePoints) ||
            !listEquals(oldWidget.tripRoutePoints, widget.tripRoutePoints))) {
      _rebuildRoutes(_cachedSize!);
    }
  }

  Offset _carNormalizedFocus(Size size, PathMetric? metric, double progress) {
    if (metric == null || size.isEmpty) return widget.pickupPoint;
    final tangent = metric.getTangentForOffset(metric.length * progress);
    if (tangent == null) return widget.pickupPoint;
    return Offset(
      (tangent.position.dx / size.width).clamp(0.0, 1.0),
      (tangent.position.dy / size.height).clamp(0.0, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final phase = widget.phase;
    final isSelecting = phase == RidePhase.selecting;
    final isSearching = phase == RidePhase.searching;
    final isApproach =
        phase == RidePhase.matched ||
        phase == RidePhase.arriving ||
        phase == RidePhase.arrived;
    final isInTrip = phase == RidePhase.inTrip;
    final isCompleted = phase == RidePhase.completed;
    final showApproachRoute = isApproach && _driverMetric != null;
    final showActiveTripRoute = (isInTrip || isCompleted) && _tripMetric != null;
    final activeMetric = showActiveTripRoute ? _tripMetric : _driverMetric;
    final showMatchedCar =
        (isApproach || isInTrip || isCompleted) && activeMetric != null;

    return ClipRect(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          _ensureGeometry(size);

          final startOrigin = widget.driverRoutePoints.firstOrNull;
          const matchedCarHalf = CarMarker.size / 2;
          const ambientCarHalf = 22.0;

          final mapStack = Stack(
            children: [
              const Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(painter: _StaticMapPainter()),
                ),
              ),
              if (_tripPath != null && !showActiveTripRoute)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _TripPreviewPainter(
                        path: _tripPath!,
                        highlight: isSelecting,
                      ),
                    ),
                  ),
                ),
              if (showApproachRoute && _driverPath != null)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _RoutePainter(
                        path: _driverPath!,
                        metric: _driverMetric!,
                        progress: widget.routeProgress,
                      ),
                    ),
                  ),
                ),
              if (showActiveTripRoute && _tripPath != null)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _RoutePainter(
                        path: _tripPath!,
                        metric: _tripMetric!,
                        progress: widget.routeProgress,
                      ),
                    ),
                  ),
                ),
              for (final rider in _ambientRiders)
                Positioned(
                  left: size.width * rider.dx - 14,
                  top: size.height * rider.dy - 30,
                  child: const CustomerMarker(
                    isPrimary: false,
                    semanticLabel: 'Nearby waiting rider',
                  ),
                ),
              if (showApproachRoute && startOrigin != null)
                Positioned(
                  left: size.width * startOrigin.dx - 5,
                  top: size.height * startOrigin.dy - 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: RideColors.textSecondary,
                      border: Border.all(
                        color: RideColors.textPrimary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              if (_trafficMetrics.isNotEmpty)
                Positioned.fill(
                  child: ValueListenableBuilder<double>(
                    valueListenable: widget.trafficProgress,
                    child: const RepaintBoundary(
                      child: CarMarker(isAmbient: true),
                    ),
                    builder: (context, tick, ambientCar) {
                      return Stack(
                        children: [
                          for (var i = 0; i < _trafficMetrics.length; i++)
                            Positioned(
                              left: 0,
                              top: 0,
                              child: _buildCarTransform(
                                metric: _trafficMetrics[i],
                                progress: (tick + _ambientOffsets[i]) % 1.0,
                                halfSize: ambientCarHalf,
                                child: ambientCar!,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              if (widget.destinationPoint != null)
                Positioned(
                  left:
                      size.width * widget.destinationPoint!.dx -
                      _DestinationPin.anchorOffset.dx,
                  top:
                      size.height * widget.destinationPoint!.dy -
                      _DestinationPin.anchorOffset.dy,
                  child: _DestinationPin(
                    label: widget.destinationLabel ?? 'Drop-off',
                  ),
                ),
              if (showMatchedCar)
                Positioned(
                  left: 0,
                  top: 0,
                  child: ValueListenableBuilder<double>(
                    valueListenable: widget.routeProgress,
                    child: const RepaintBoundary(child: CarMarker()),
                    builder: (context, progress, child) {
                      return _buildCarTransform(
                        metric: activeMetric,
                        progress: isCompleted ? 1.0 : progress,
                        halfSize: matchedCarHalf,
                        child: child!,
                      );
                    },
                  ),
                ),
              _buildRiderOverlay(
                size: size,
                phase: phase,
                isSelecting: isSelecting,
                isSearching: isSearching,
                reduceMotion: reduceMotion,
              ),
            ],
          );

          final interactiveMap = isSelecting && widget.onMapTap != null
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    if (size.isEmpty) return;
                    final nx = (details.localPosition.dx / size.width).clamp(
                      0.10,
                      0.90,
                    );
                    final ny = (details.localPosition.dy / size.height).clamp(
                      0.22,
                      0.58,
                    );
                    widget.onMapTap!(Offset(nx, ny));
                  },
                  child: mapStack,
                )
              : mapStack;

          if (isSelecting ||
              !widget.cameraFollow ||
              reduceMotion ||
              size.isEmpty) {
            return interactiveMap;
          }

          return ValueListenableBuilder<double>(
            valueListenable: widget.routeProgress,
            child: interactiveMap,
            builder: (context, progress, child) {
              late final double scale;
              late final Offset focus;

              if (isSearching) {
                scale = 1.06;
                focus = widget.pickupPoint;
              } else if (isApproach) {
                final eased = Curves.easeInOutCubic.transform(progress);
                scale = 1.06 + 0.08 * eased;
                final carFocus = _carNormalizedFocus(
                  size,
                  _driverMetric,
                  progress,
                );
                focus = Offset.lerp(
                  carFocus,
                  widget.pickupPoint,
                  0.5 + 0.5 * eased,
                )!;
              } else if (isInTrip) {
                scale = 1.14;
                final carFocus = _carNormalizedFocus(
                  size,
                  _tripMetric,
                  progress,
                );
                final dest = widget.destinationPoint ?? widget.pickupPoint;
                focus = Offset.lerp(carFocus, dest, 0.32 * progress)!;
              } else {
                scale = 1.12;
                focus = widget.destinationPoint ?? widget.pickupPoint;
              }

              final maxTx = (scale - 1.0) * size.width / 2;
              final maxTy = (scale - 1.0) * size.height / 2;
              final tx = ((0.5 - focus.dx) * size.width * 0.45).clamp(
                -maxTx,
                maxTx,
              );
              final ty = ((0.42 - focus.dy) * size.height * 0.45).clamp(
                -maxTy,
                maxTy,
              );

              return Transform.translate(
                offset: Offset(tx, ty),
                child: Transform.scale(scale: scale, child: child),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRiderOverlay({
    required Size size,
    required RidePhase phase,
    required bool isSelecting,
    required bool isSearching,
    required bool reduceMotion,
  }) {
    if (phase == RidePhase.completed && widget.destinationPoint != null) {
      final dest = widget.destinationPoint!;
      return Positioned(
        left: size.width * dest.dx - CustomerMarker.anchorOffset.dx + 22,
        top: size.height * dest.dy - CustomerMarker.anchorOffset.dy - 4,
        child: const CustomerMarker(
          isPrimary: true,
          semanticLabel: 'You arrived at destination',
        ),
      );
    }

    if (phase == RidePhase.inTrip) {
      return ValueListenableBuilder<double>(
        valueListenable: widget.boardingProgress,
        builder: (context, board, _) {
          if (board >= 1.0) return const SizedBox.shrink();
          final eased = reduceMotion
              ? board
              : Curves.easeInOutCubic.transform(board);
          return Positioned(
            left: size.width * widget.pickupPoint.dx - CustomerMarker.anchorOffset.dx,
            top:
                size.height * widget.pickupPoint.dy -
                CustomerMarker.anchorOffset.dy +
                8 * eased,
            child: Opacity(
              opacity: (1.0 - eased).clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 1.0 - 0.55 * eased,
                alignment: Alignment.bottomCenter,
                child: const CustomerMarker(
                  isPrimary: true,
                  callout: 'Boarding',
                  semanticLabel: 'Boarding driver vehicle',
                ),
              ),
            ),
          );
        },
      );
    }

    return Positioned(
      left: size.width * widget.pickupPoint.dx - CustomerMarker.anchorOffset.dx,
      top: size.height * widget.pickupPoint.dy - CustomerMarker.anchorOffset.dy,
      child: CustomerMarker(
        isPrimary: true,
        isPulsing: isSearching,
        callout: isSelecting ? widget.pickupLabel : 'You',
        semanticLabel: 'Your pickup point at ${widget.pickupLabel}',
      ),
    );
  }

  static Widget _buildCarTransform({
    required PathMetric metric,
    required double progress,
    required double halfSize,
    required Widget child,
  }) {
    final tangent = metric.getTangentForOffset(metric.length * progress);
    if (tangent == null) return const SizedBox.shrink();

    final angle = math.atan2(tangent.vector.dy, tangent.vector.dx);
    return Transform.translate(
      offset: Offset(
        tangent.position.dx - halfSize,
        tangent.position.dy - halfSize,
      ),
      child: Transform.rotate(angle: angle, child: child),
    );
  }
}

class _DestinationPin extends StatelessWidget {
  final String label;

  const _DestinationPin({required this.label});

  static const double width = 104;
  static const double height = 46;
  static const Offset anchorOffset = Offset(width / 2, height - 8);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Destination at $label',
      excludeSemantics: true,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: RideSpacing.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: RideColors.surface,
                borderRadius: BorderRadius.circular(RideRadius.pill),
                border: Border.all(color: RideColors.border),
              ),
              child: Text(
                label,
                style: RideText.captionTabular,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: RideSpacing.xs),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: RideColors.textPrimary,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: RideColors.mapRoadCasing, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: RideColors.shadow,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Path _buildSmoothPath(
  List<Offset> normalizedPoints,
  Size size, {
  double cornerRadius = 26,
}) {
  final pts = [
    for (final p in normalizedPoints)
      Offset(p.dx * size.width, p.dy * size.height),
  ];
  final path = Path()..moveTo(pts.first.dx, pts.first.dy);

  for (var i = 1; i < pts.length - 1; i++) {
    final prev = pts[i - 1];
    final curr = pts[i];
    final next = pts[i + 1];

    final toPrev = prev - curr;
    final toNext = next - curr;
    final lenIn = toPrev.distance;
    final lenOut = toNext.distance;
    if (lenIn == 0 || lenOut == 0) {
      path.lineTo(curr.dx, curr.dy);
      continue;
    }

    final r = math.min(cornerRadius, math.min(lenIn, lenOut) * 0.45);
    final entry = curr + (toPrev / lenIn) * r;
    final exit = curr + (toNext / lenOut) * r;

    path.lineTo(entry.dx, entry.dy);
    path.quadraticBezierTo(curr.dx, curr.dy, exit.dx, exit.dy);
  }

  path.lineTo(pts.last.dx, pts.last.dy);
  return path;
}

class _StaticMapPainter extends CustomPainter {
  const _StaticMapPainter();

  static final _bgPaint = Paint()..color = RideColors.canvas;
  static final _blockPaint = Paint()..color = RideColors.mapBlock;
  static final _parkPaint = Paint()..color = RideColors.mapPark;
  static final _waterPaint = Paint()
    ..color = RideColors.mapWater
    ..style = PaintingStyle.stroke
    ..strokeWidth = 34
    ..strokeCap = StrokeCap.round;

  static Paint _roadPaint(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  static final _minorCasing = _roadPaint(RideColors.mapRoadCasing, 13);
  static final _minorFill = _roadPaint(RideColors.mapRoadMinor, 10);
  static final _majorCasing = _roadPaint(RideColors.mapRoadCasing, 21);
  static final _majorFill = _roadPaint(RideColors.mapRoadMajor, 17);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, _bgPaint);

    final canal = Path()
      ..moveTo(-24, size.height * 0.16)
      ..quadraticBezierTo(
        size.width * 0.09,
        size.height * 0.12,
        size.width * 0.14,
        -24,
      );
    canvas.drawPath(canal, _waterPaint);

    final blocks = [
      (Rect.fromLTWH(size.width * 0.22, size.height * 0.08, 92, 68), false),
      (Rect.fromLTWH(size.width * 0.54, size.height * 0.09, 76, 60), false),
      (Rect.fromLTWH(size.width * 0.05, size.height * 0.32, 74, 86), false),
      (Rect.fromLTWH(size.width * 0.24, size.height * 0.33, 88, 66), true),
      (Rect.fromLTWH(size.width * 0.54, size.height * 0.31, 70, 50), false),
      (Rect.fromLTWH(size.width * 0.83, size.height * 0.34, 62, 54), false),
      (Rect.fromLTWH(size.width * 0.55, size.height * 0.61, 84, 68), false),
      (Rect.fromLTWH(size.width * 0.25, size.height * 0.67, 94, 70), false),
    ];
    for (final (rect, isPark) in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(RideRadius.sm)),
        isPark ? _parkPaint : _blockPaint,
      );
    }

    final minorStreets = [
      _buildSmoothPath(const [
        Offset(0.14, -0.04),
        Offset(0.16, 0.61),
        Offset(0.19, 1.04),
      ], size),
      _buildSmoothPath(const [
        Offset(0.45, -0.04),
        Offset(0.49, 0.50),
        Offset(0.52, 1.04),
      ], size),
      _buildSmoothPath(const [
        Offset(-0.05, 0.31),
        Offset(0.77, 0.28),
        Offset(1.05, 0.26),
      ], size),
      _buildSmoothPath(const [
        Offset(-0.05, 0.45),
        Offset(0.56, 0.45),
        Offset(1.05, 0.42),
      ], size),
      _buildSmoothPath(const [
        Offset(-0.05, 0.63),
        Offset(0.16, 0.61),
        Offset(0.34, 0.59),
        Offset(1.05, 0.53),
      ], size),
    ];

    final majorRoads = [
      _buildSmoothPath(const [
        Offset(-0.06, 0.78),
        Offset(0.14, 0.70),
        Offset(0.34, 0.59),
        Offset(0.56, 0.45),
        Offset(0.76, 0.34),
        Offset(1.06, 0.19),
      ], size),
      _buildSmoothPath(const [
        Offset(0.75, -0.04),
        Offset(0.77, 0.28),
        Offset(0.76, 0.34),
        Offset(0.81, 1.04),
      ], size),
    ];

    for (final p in minorStreets) {
      canvas.drawPath(p, _minorCasing);
    }
    for (final p in majorRoads) {
      canvas.drawPath(p, _majorCasing);
    }
    for (final p in minorStreets) {
      canvas.drawPath(p, _minorFill);
    }
    for (final p in majorRoads) {
      canvas.drawPath(p, _majorFill);
    }

    _drawMapLabel(
      canvas,
      'MM Alam Rd',
      Offset(size.width * 0.45, size.height * 0.52),
      -0.55,
    );
    _drawMapLabel(
      canvas,
      'Main Blvd',
      Offset(size.width * 0.80, size.height * 0.52),
      -1.50,
    );
    _drawMapLabel(
      canvas,
      'Gulberg III',
      Offset(size.width * 0.29, size.height * 0.36),
      0,
    );
  }

  static void _drawMapLabel(
    Canvas canvas,
    String text,
    Offset center,
    double angle,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: RideColors.mapLabel,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StaticMapPainter oldDelegate) => false;
}

class _TripPreviewPainter extends CustomPainter {
  final Path path;
  final bool highlight;

  const _TripPreviewPainter({required this.path, required this.highlight});

  static final _selectingPaint = Paint()
    ..color = RideColors.textPrimary
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.5
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  static final _dimmedPaint = Paint()
    ..color = RideColors.routeTrack
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path, highlight ? _selectingPaint : _dimmedPaint);
  }

  @override
  bool shouldRepaint(covariant _TripPreviewPainter oldDelegate) {
    return oldDelegate.path != path || oldDelegate.highlight != highlight;
  }
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
    if (t < 1.0) {
      canvas.drawPath(
        metric.extractPath(metric.length * t, metric.length),
        _activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) {
    return oldDelegate.path != path || oldDelegate.metric != metric;
  }
}
