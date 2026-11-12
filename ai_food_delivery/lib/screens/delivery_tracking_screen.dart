import 'package:flutter/material.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';
import 'package:ai_food_delivery/widgets/delivery_map_painter.dart';
import 'package:ai_food_delivery/widgets/delivery_status_sheet.dart';

/// Live order map and step-by-step courier tracking screen.
class DeliveryTrackingScreen extends StatefulWidget {
  final FoodItem food;

  const DeliveryTrackingScreen({super.key, required this.food});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const List<Offset> _routePoints = [
    Offset(0.16, 0.36),
    Offset(0.30, 0.29),
    Offset(0.46, 0.38),
    Offset(0.56, 0.48),
    Offset(0.70, 0.44),
    Offset(0.84, 0.54),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _value => _controller.value;
  bool get _isSearching => _value < 0.18;
  bool get _isPreparing => _value >= 0.18 && _value < 0.50;
  bool get _isMoving => _value >= 0.50 && _value < 0.94;
  bool get _isDelivered => _value >= 0.94;

  double get _routeProgress {
    if (_value < 0.50) return 0;
    if (_value >= 0.94) return 1;
    return ((_value - 0.50) / 0.44).clamp(0.0, 1.0);
  }

  int get _etaMinutes {
    if (_isDelivered) return 0;
    return (12 - (_routeProgress * 12)).ceil().clamp(1, 12);
  }

  int get _activeStep {
    if (_isSearching) return 1;
    if (_isPreparing) return 2;
    if (_isMoving) return 3;
    return 4;
  }

  String get _statusPillText {
    if (_isSearching) return 'Assigning rider';
    if (_isPreparing) return 'Preparing at ${widget.food.restaurant}';
    if (_isMoving) return 'On the way';
    return 'Delivered';
  }

  Offset _courierPosition(Size size) {
    final path = DeliveryMapPainter.buildRoutePath(_routePoints, size);
    final metric = path.computeMetrics().first;
    final tangent = metric.getTangentForOffset(metric.length * _routeProgress);
    return tangent?.position ?? metric.getTangentForOffset(0)!.position;
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: FoodColors.canvas,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final courierOffset = _courierPosition(size);

              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DeliveryMapPainter(
                        routePoints: _routePoints,
                        routeProgress: _routeProgress,
                        pulseProgress: _value,
                        isSearching: _isSearching,
                      ),
                    ),
                  ),
                  Positioned(
                    left: size.width * _routePoints.first.dx - 20,
                    top: size.height * _routePoints.first.dy - 20,
                    child: const _MapPin(
                      icon: Icons.restaurant_rounded,
                      label: 'Pickup',
                      color: FoodColors.accent,
                      foreground: FoodColors.inkOnAccent,
                    ),
                  ),
                  Positioned(
                    left: size.width * _routePoints.last.dx - 20,
                    top: size.height * _routePoints.last.dy - 20,
                    child: const _MapPin(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      color: FoodColors.success,
                      foreground: FoodColors.inkOnSuccess,
                    ),
                  ),
                  if (_isMoving)
                    Positioned(
                      left: courierOffset.dx - 18,
                      top: courierOffset.dy - 18,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: FoodColors.textPrimary,
                          border: Border.all(
                            color: FoodColors.canvas,
                            width: 2.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.delivery_dining_rounded,
                          color: FoodColors.canvas,
                          size: 18,
                        ),
                      ),
                    ),
                  Positioned(
                    top: topPadding + FoodSpacing.sm,
                    left: FoodSpacing.lg,
                    right: FoodSpacing.lg,
                    child: Row(
                      children: [
                        IconButton(
                          tooltip: 'Back',
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded, size: 20),
                        ),
                        const SizedBox(width: FoodSpacing.md),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: FoodSpacing.md,
                                vertical: FoodSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: FoodColors.surface,
                                borderRadius: BorderRadius.circular(
                                  FoodRadius.pill,
                                ),
                                border: Border.all(color: FoodColors.border),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _isDelivered
                                          ? FoodColors.success
                                          : FoodColors.accent,
                                    ),
                                  ),
                                  const SizedBox(width: FoodSpacing.sm),
                                  Flexible(
                                    child: Text(
                                      _statusPillText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: FoodText.body.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: DeliveryStatusSheet(
                      food: widget.food,
                      activeStep: _activeStep,
                      isDelivered: _isDelivered,
                      etaMinutes: _etaMinutes,
                      onDone: () => Navigator.pop(context),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color foreground;

  const _MapPin({
    required this.icon,
    required this.label,
    required this.color,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: FoodColors.canvas, width: 2.5),
          ),
          child: Icon(icon, color: foreground, size: 19),
        ),
        const SizedBox(height: FoodSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: FoodSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: FoodColors.surface,
            borderRadius: BorderRadius.circular(FoodRadius.pill),
            border: Border.all(color: FoodColors.border),
          ),
          child: Text(
            label,
            style: FoodText.caption.copyWith(
              color: FoodColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

