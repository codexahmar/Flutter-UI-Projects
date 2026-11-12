import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';
import 'package:ride_tracking/ride_routing.dart';
import 'package:ride_tracking/widgets/car_marker.dart';
import 'package:ride_tracking/widgets/customer_marker.dart';
import 'package:ride_tracking/widgets/ride_status_card.dart';

/// Interactive vector street map with varied place architecture, ambient life, boarding, and route tracking.
class RideMap extends StatefulWidget {
  final Offset pickupPoint;
  final Offset? destinationPoint;
  final String pickupLabel;
  final String? destinationLabel;
  final List<Offset> driverRoutePoints;
  final List<Offset> tripRoutePoints;
  final List<Offset> departureRoutePoints;
  final ValueListenable<double> routeProgress;
  final ValueListenable<double> boardingProgress;
  final ValueListenable<double> departureProgress;
  final ValueListenable<double> trafficProgress;
  final RidePhase phase;
  final bool showBooking;
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
    required this.departureRoutePoints,
    required this.routeProgress,
    required this.boardingProgress,
    required this.departureProgress,
    required this.trafficProgress,
    required this.phase,
    required this.showBooking,
    required this.cameraFollow,
    this.onMapTap,
  });

  @override
  State<RideMap> createState() => _RideMapState();
}

class _RideMapState extends State<RideMap> with SingleTickerProviderStateMixin {
  static const _ambientRoutes = [
    [Offset(0.145, 0.12), Offset(0.16, 0.58), Offset(0.185, 0.90)],
    [Offset(0.515, 0.88), Offset(0.49, 0.50), Offset(0.46, 0.14)],
    [Offset(0.94, 0.425), Offset(0.56, 0.45), Offset(0.06, 0.45)],
  ];
  static const _ambientOffsets = [0.0, 0.37, 0.68];
  static const _ambientRiders = [Offset(0.45, 0.445), Offset(0.64, 0.555)];

  late final AnimationController _tapRipple = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  Offset? _lastTap;
  Size? _cachedSize;
  Path? _driverPath;
  PathMetric? _driverMetric;
  Path? _tripPath;
  PathMetric? _tripMetric;
  PathMetric? _departureMetric;
  List<PathMetric> _trafficMetrics = const [];

  @override
  void dispose() {
    _tapRipple.dispose();
    super.dispose();
  }

  void _triggerTapRipple(Offset normalizedPoint) {
    _lastTap = normalizedPoint;
    if (!MediaQuery.disableAnimationsOf(context)) {
      _tapRipple.forward(from: 0);
    }
  }

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

    if (widget.departureRoutePoints.length >= 2) {
      final path = _buildSmoothPath(widget.departureRoutePoints, size);
      _departureMetric = path.computeMetrics().firstOrNull;
    } else {
      _departureMetric = null;
    }
  }

  @override
  void didUpdateWidget(covariant RideMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_cachedSize != null &&
        (!listEquals(oldWidget.driverRoutePoints, widget.driverRoutePoints) ||
            !listEquals(oldWidget.tripRoutePoints, widget.tripRoutePoints) ||
            !listEquals(
              oldWidget.departureRoutePoints,
              widget.departureRoutePoints,
            ))) {
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
    final showActiveTripRoute = isInTrip && _tripMetric != null;
    final activeMetric = showActiveTripRoute ? _tripMetric : _driverMetric;
    final showMatchedCar = (isApproach || isInTrip) && activeMetric != null;

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
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _StaticMapPainter(
                      pickupLabel: widget.showBooking ? widget.pickupLabel : '',
                      destinationLabel: widget.showBooking
                          ? widget.destinationLabel
                          : null,
                    ),
                  ),
                ),
              ),
              if (isSelecting && widget.showBooking)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TapRipplePainter(
                      progress: _tapRipple,
                      getPoint: () => _lastTap,
                    ),
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
                        progress: progress,
                        halfSize: matchedCarHalf,
                        child: child!,
                      );
                    },
                  ),
                ),
              if (_departureMetric != null)
                Positioned(
                  left: 0,
                  top: 0,
                  child: ValueListenableBuilder<double>(
                    valueListenable: widget.departureProgress,
                    child: const RepaintBoundary(child: CarMarker()),
                    builder: (context, t, child) {
                      if ((t <= 0 && !isCompleted) || t >= 1.0) {
                        return const SizedBox.shrink();
                      }
                      final eased = reduceMotion
                          ? t
                          : Curves.easeInCubic.transform(t);
                      final fade = (1.0 -
                              const Interval(0.68, 1.0).transform(t))
                          .clamp(0.0, 1.0);
                      return Opacity(
                        opacity: fade,
                        child: _buildCarTransform(
                          metric: _departureMetric!,
                          progress: eased,
                          halfSize: matchedCarHalf,
                          child: child!,
                        ),
                      );
                    },
                  ),
                ),
              _buildRiderOverlay(
                size: size,
                phase: phase,
                isSearching: isSearching,
                reduceMotion: reduceMotion,
              ),
            ],
          );

          final interactiveMap =
              isSelecting && widget.showBooking && widget.onMapTap != null
                  ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    if (size.isEmpty) return;
                    final nx = (details.localPosition.dx / size.width).clamp(
                      0.10,
                      0.90,
                    );
                    final ny = (details.localPosition.dy / size.height).clamp(
                      0.20,
                      0.60,
                    );
                    final tapPoint = Offset(nx, ny);
                    _triggerTapRipple(tapPoint);
                    widget.onMapTap!(tapPoint);
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
            left:
                size.width * widget.pickupPoint.dx -
                CustomerMarker.anchorOffset.dx,
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
        callout: 'You',
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

  static const double width = 136;
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
  final String pickupLabel;
  final String? destinationLabel;

  const _StaticMapPainter({required this.pickupLabel, this.destinationLabel});

  static final _bgPaint = Paint()..color = RideColors.canvas;
  static final _blockShadowPaint = Paint()..color = RideColors.mapRoadCasing;
  static final _towerPaint = Paint()..color = RideColors.mapBlock;
  static final _housePaint = Paint()..color = RideColors.mapHouse;
  static final _shopPaint = Paint()..color = RideColors.mapShop;
  static final _awningPaint = Paint()
    ..color = RideColors.mapAwning.withValues(alpha: 0.45);
  static final _parkPaint = Paint()..color = RideColors.mapPark;
  static final _parkCanopyPaint = Paint()..color = RideColors.mapParkCanopy;
  static final _activePlaceFill = Paint()
    ..color = RideColors.accent.withValues(alpha: 0.14);
  static final _activePlaceStroke = Paint()
    ..color = RideColors.accentBorder
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.6;
  static final _roofBorderPaint = Paint()
    ..color = RideColors.mapBuildingBorder
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.1;
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

    for (final place in RideRouting.places) {
      final rect = Rect.fromLTWH(
        size.width * place.x,
        size.height * place.y,
        size.width * place.w,
        size.height * place.h,
      );
      final isSelected =
          place.label != null &&
          (place.label == pickupLabel || place.label == destinationLabel);
      _paintPlace(canvas, rect, place, isSelected: isSelected);
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

    _drawCenteredLabel(
      canvas,
      'MM Alam Rd',
      Offset(size.width * 0.455, size.height * 0.525),
      angle: -0.55,
    );
    _drawCenteredLabel(
      canvas,
      'Main Blvd',
      Offset(size.width * 0.805, size.height * 0.48),
      angle: -1.50,
    );
    _drawCenteredLabel(
      canvas,
      'West Ave',
      Offset(size.width * 0.128, size.height * 0.49),
      angle: -1.54,
    );
  }

  static void _paintPlace(
    Canvas canvas,
    Rect rect,
    MapPlace place, {
    bool isSelected = false,
  }) {
    final radius = place.kind == MapPlaceKind.house ? 6.0 : RideRadius.sm;
    final outer = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawRRect(outer.shift(const Offset(0, 2)), _blockShadowPaint);

    switch (place.kind) {
      case MapPlaceKind.tower:
        canvas.drawRRect(outer, _towerPaint);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect.deflate(4), const Radius.circular(6)),
          _roofBorderPaint,
        );
        // Stepped penthouse rooftop tier
        final tier = Rect.fromCenter(
          center: rect.center,
          width: rect.width * 0.56,
          height: rect.height * 0.54,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(tier, const Radius.circular(4)),
          _roofBorderPaint,
        );
      case MapPlaceKind.mall:
        canvas.drawRRect(outer, _towerPaint);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect.deflate(3.5), const Radius.circular(6)),
          _roofBorderPaint,
        );
        // Twin glass atrium bays
        for (final sign in const [-0.2, 0.2]) {
          final bay = Rect.fromCenter(
            center: rect.center.translate(rect.width * sign, 0),
            width: rect.width * 0.24,
            height: rect.height * 0.46,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(bay, const Radius.circular(3)),
            _roofBorderPaint,
          );
        }
      case MapPlaceKind.shop:
        canvas.drawRRect(outer, _shopPaint);
        canvas.drawRRect(outer, _roofBorderPaint);
        // Warm storefront awning strip along curb-facing edge
        final awning = Rect.fromLTWH(
          rect.left + 3,
          rect.top + 2.5,
          rect.width - 6,
          4.5,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(awning, const Radius.circular(2)),
          _awningPaint,
        );
      case MapPlaceKind.house:
        // Yard plot + inset hip-roof house footprint
        canvas.drawRRect(outer, _parkPaint);
        final houseRect = rect.deflate(5);
        final houseRRect = RRect.fromRectAndRadius(
          houseRect,
          const Radius.circular(4),
        );
        canvas.drawRRect(houseRRect, _housePaint);
        canvas.drawRRect(houseRRect, _roofBorderPaint);
        // Gable roof ridge slightly above center so label below stays crisp
        final ridgeY = houseRect.top + houseRect.height * 0.34;
        final leftRidge = Offset(
          houseRect.left + houseRect.width * 0.28,
          ridgeY,
        );
        final rightRidge = Offset(
          houseRect.right - houseRect.width * 0.28,
          ridgeY,
        );
        canvas
          ..drawLine(leftRidge, rightRidge, _roofBorderPaint)
          ..drawLine(houseRect.topLeft, leftRidge, _roofBorderPaint)
          ..drawLine(houseRect.bottomLeft, leftRidge, _roofBorderPaint)
          ..drawLine(houseRect.topRight, rightRidge, _roofBorderPaint)
          ..drawLine(houseRect.bottomRight, rightRidge, _roofBorderPaint);
      case MapPlaceKind.park:
        canvas.drawRRect(outer, _parkPaint);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect.deflate(3.5), const Radius.circular(7)),
          _roofBorderPaint,
        );
        // Scattered circular tree canopies & central plaza ring
        for (final (ox, oy, r) in const [
          (-0.32, -0.22, 6.5),
          (0.30, -0.18, 7.5),
          (-0.26, 0.24, 5.5),
          (0.33, 0.22, 6.0),
        ]) {
          canvas.drawCircle(
            rect.center.translate(rect.width * ox, rect.height * oy),
            r,
            _parkCanopyPaint,
          );
        }
        canvas.drawCircle(rect.center, 8, _roofBorderPaint);
    }

    if (isSelected) {
      canvas
        ..drawRRect(outer, _activePlaceFill)
        ..drawRRect(outer, _activePlaceStroke);
    }

    if (place.label != null) {
      _drawCenteredLabel(
        canvas,
        place.label!,
        place.labelPosition(rect),
        color: isSelected
            ? RideColors.accent
            : (place.kind == MapPlaceKind.park
                  ? RideColors.mapParkLabel
                  : RideColors.mapLabel),
        maxWidth: math.max(28, rect.width - 4),
        fontSize: 8.5,
      );
    }
  }

  static void _drawCenteredLabel(
    Canvas canvas,
    String text,
    Offset center, {
    double angle = 0,
    Color color = RideColors.mapLabel,
    double maxWidth = 120,
    double fontSize = 10,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        ),
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (angle != 0) canvas.rotate(angle);
    painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StaticMapPainter oldDelegate) {
    return oldDelegate.pickupLabel != pickupLabel ||
        oldDelegate.destinationLabel != destinationLabel;
  }
}

extension on MapPlace {
  Offset labelPosition(Rect rect) {
    if (kind == MapPlaceKind.shop) {
      return rect.center.translate(0, 2);
    }
    if (kind == MapPlaceKind.house) {
      return rect.center.translate(0, rect.height * 0.14);
    }
    return rect.center;
  }
}

class _TapRipplePainter extends CustomPainter {
  final Animation<double> progress;
  final Offset? Function() getPoint;

  _TapRipplePainter({required this.progress, required this.getPoint})
    : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final point = getPoint();
    final t = progress.value;
    if (point == null || t <= 0 || t >= 1) return;

    final center = Offset(size.width * point.dx, size.height * point.dy);
    final radius = 8 + 26 * Curves.easeOut.transform(t);
    final paint = Paint()
      ..color = RideColors.accent.withValues(alpha: (1 - t) * 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _TapRipplePainter oldDelegate) => false;
}

class _TripPreviewPainter extends CustomPainter {
  final Path path;
  final bool highlight;

  const _TripPreviewPainter({required this.path, required this.highlight});

  static final _casingPaint = Paint()
    ..color = RideColors.mapRoadCasing
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6.5
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  static final _selectingPaint = Paint()
    ..color = RideColors.accent
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
    if (highlight) {
      canvas
        ..drawPath(path, _casingPaint)
        ..drawPath(path, _selectingPaint);
    } else {
      canvas.drawPath(path, _dimmedPaint);
    }
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
