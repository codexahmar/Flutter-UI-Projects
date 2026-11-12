import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';
import 'package:ai_food_delivery/widgets/delivery_map_painter.dart';
import 'package:ai_food_delivery/widgets/delivery_scooter_marker.dart';
import 'package:ai_food_delivery/widgets/delivery_status_sheet.dart';

/// Live delivery map screen using strict 3-color cartography and an arrival notification banner.
class DeliveryTrackingScreen extends StatefulWidget {
  final FoodItem food;

  const DeliveryTrackingScreen({
    super.key,
    required this.food,
  });

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _routeController;
  Timer? _bannerDismissTimer;

  bool _didTriggerNotification = false;
  bool _showDeliveredBanner = false;

  @override
  void initState() {
    super.initState();
    _routeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )
      ..addListener(_handleRouteTick)
      ..forward();
  }

  void _handleRouteTick() {
    if (_routeController.value >= 0.96 && !_didTriggerNotification) {
      _didTriggerNotification = true;
      if (!mounted) return;
      setState(() => _showDeliveredBanner = true);
      _bannerDismissTimer?.cancel();
      _bannerDismissTimer = Timer(const Duration(seconds: 5), () {
        if (!mounted) return;
        setState(() => _showDeliveredBanner = false);
      });
    }
  }

  @override
  void dispose() {
    _bannerDismissTimer?.cancel();
    _routeController
      ..removeListener(_handleRouteTick)
      ..dispose();
    super.dispose();
  }

  int _activeStepForProgress(double t) {
    if (t >= 0.96) return 4;
    if (t >= 0.25) return 3;
    if (t >= 0.10) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: FoodColors.mapLand,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mapSize = constraints.biggest;
          final routePath = DeliveryMapLayout.buildRoutePath(mapSize);
          final routeMetric = routePath.computeMetrics().first;
          final restaurantPos = DeliveryMapLayout.restaurantPoint(mapSize);
          final homePos = DeliveryMapLayout.homePoint(mapSize);

          return AnimatedBuilder(
            animation: _routeController,
            builder: (context, _) {
              final progress = _routeController.value;
              final activeStep = _activeStepForProgress(progress);
              final isDelivered = progress >= 0.96;
              final etaMinutes = (14 * (1 - progress)).ceil().clamp(1, 14);

              final distance = (routeMetric.length * progress).clamp(
                0.0,
                routeMetric.length,
              );
              final tangent = routeMetric.getTangentForOffset(distance);
              final riderPos = tangent?.position ?? restaurantPos;
              final riderAngle = tangent != null
                  ? math.atan2(tangent.vector.dy, tangent.vector.dx)
                  : 0.0;

              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DeliveryMapPainter(
                        progress: progress,
                        restaurantName: widget.food.restaurant,
                      ),
                    ),
                  ),
                  Positioned(
                    left: restaurantPos.dx - 16,
                    top: restaurantPos.dy - 16,
                    child: const _MapLocationPin(
                      icon: CupertinoIcons.bag_fill,
                      background: FoodColors.surface,
                      iconColor: FoodColors.accent,
                      borderColor: FoodColors.accent,
                    ),
                  ),
                  Positioned(
                    left: homePos.dx - 16,
                    top: homePos.dy - 16,
                    child: _MapLocationPin(
                      icon: CupertinoIcons.house_fill,
                      background: isDelivered
                          ? FoodColors.accent
                          : FoodColors.textPrimary,
                      iconColor: FoodColors.inkOnDark,
                      borderColor: FoodColors.surface,
                    ),
                  ),
                  Positioned(
                    left: riderPos.dx - 27,
                    top: riderPos.dy - 27,
                    child: Transform.rotate(
                      angle: riderAngle,
                      child: DeliveryScooterMarker(
                        size: 54,
                        isMoving: !isDelivered,
                      ),
                    ),
                  ),
                  Positioned(
                    top: topPadding + FoodSpacing.sm,
                    left: FoodSpacing.lg,
                    child: Material(
                      color: FoodColors.surface,
                      shape: const CircleBorder(),
                      elevation: 3,
                      shadowColor: FoodColors.shadow,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        customBorder: const CircleBorder(),
                        child: const SizedBox(
                          width: 42,
                          height: 42,
                          child: Icon(
                            CupertinoIcons.back,
                            size: 18,
                            color: FoodColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.easeOutCubic,
                    top: _showDeliveredBanner
                        ? topPadding + FoodSpacing.xs
                        : -140,
                    left: FoodSpacing.lg,
                    right: FoodSpacing.lg,
                    child: _DeliveryNotificationBanner(
                      foodName: widget.food.name,
                      restaurantName: widget.food.restaurant,
                      onDismiss: () {
                        _bannerDismissTimer?.cancel();
                        setState(() => _showDeliveredBanner = false);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: DeliveryStatusSheet(
                      food: widget.food,
                      activeStep: activeStep,
                      isDelivered: isDelivered,
                      etaMinutes: etaMinutes,
                      onDone: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
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

class _DeliveryNotificationBanner extends StatelessWidget {
  final String foodName;
  final String restaurantName;
  final VoidCallback onDismiss;

  const _DeliveryNotificationBanner({
    required this.foodName,
    required this.restaurantName,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      onVerticalDragEnd: (_) => onDismiss(),
      child: Material(
        color: FoodColors.textPrimary,
        borderRadius: BorderRadius.circular(FoodRadius.lg),
        elevation: 14,
        shadowColor: const Color(0x55171310),
        child: Container(
          padding: const EdgeInsets.all(FoodSpacing.md + 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FoodRadius.lg),
            border: Border.all(
              color: FoodColors.inkOnDark.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: FoodColors.accent,
                  borderRadius: BorderRadius.circular(FoodRadius.sm),
                ),
                child: const Icon(
                  CupertinoIcons.bag_fill,
                  color: FoodColors.inkOnAccent,
                  size: 18,
                ),
              ),
              const SizedBox(width: FoodSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Crave',
                          style: FoodText.title.copyWith(
                            color: FoodColors.inkOnDark,
                            fontSize: 13.5,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'now',
                          style: FoodText.caption.copyWith(
                            color: FoodColors.inkOnDark.withValues(alpha: 0.58),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Order delivered to House 12',
                      style: FoodText.body.copyWith(
                        color: FoodColors.inkOnDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Hamza left your $foodName from $restaurantName at your door. Enjoy your meal!',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FoodText.caption.copyWith(
                        color: FoodColors.inkOnDark.withValues(alpha: 0.76),
                        height: 1.32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapLocationPin extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final Color borderColor;

  const _MapLocationPin({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28171310),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, size: 15, color: iconColor),
    );
  }
}
