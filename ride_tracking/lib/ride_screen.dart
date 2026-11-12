import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';
import 'package:ride_tracking/ride_routing.dart';
import 'package:ride_tracking/widgets/driver_card.dart';
import 'package:ride_tracking/widgets/ride_map.dart';
import 'package:ride_tracking/widgets/ride_status_card.dart';

class RideTrackingScreen extends StatefulWidget {
  const RideTrackingScreen({super.key});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _trafficController;
  late final AnimationController _approachController;
  late final AnimationController _tripController;

  late RideRoutePlan _approachPlan;
  RideRoutePlan? _tripPlan;

  final _status = ValueNotifier<RideStatus>((
    phase: RidePhase.selecting,
    eta: 4,
    remainingKm: 0,
    isBoarding: false,
  ));
  final _carProgress = ValueNotifier<double>(0);
  final _boardingProgress = ValueNotifier<double>(0);
  final _cameraFollow = ValueNotifier<bool>(true);

  Offset _pickup = RideRouting.defaultPickup;
  String _pickupLabel = RideRouting.defaultPickupLabel;
  Offset? _destination;
  String? _destinationLabel;
  StopField _activeField = StopField.destination;
  int _rating = 5;

  @override
  void initState() {
    super.initState();
    _approachPlan = RideRouting.planDriverApproach(_pickup);

    _trafficController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 13),
    )..repeat();
    _approachController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(_onApproachTick);
    _tripController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..addListener(_onTripTick);
  }

  void _onApproachTick() {
    final phaseNow = _status.value.phase;
    if (phaseNow == RidePhase.selecting ||
        phaseNow == RidePhase.inTrip ||
        phaseNow == RidePhase.completed) {
      return;
    }

    final t = _approachController.value;
    final phase = switch (t) {
      < 0.30 => RidePhase.searching,
      < 0.42 => RidePhase.matched,
      < 1.0 => RidePhase.arriving,
      _ => RidePhase.arrived,
    };
    final progress = const Interval(0.42, 1.0).transform(t);
    final baseEta = _approachPlan.etaMinutes;
    final eta = phase == RidePhase.arrived
        ? 0
        : (baseEta - progress * baseEta).ceil().clamp(1, baseEta);

    _carProgress.value = progress;
    final next = (
      phase: phase,
      eta: eta,
      remainingKm: _tripPlan?.distanceKm ?? 0.0,
      isBoarding: false,
    );
    if (_status.value != next) {
      _status.value = next;
    }
  }

  void _onTripTick() {
    final phaseNow = _status.value.phase;
    if (phaseNow != RidePhase.inTrip && phaseNow != RidePhase.completed) {
      return;
    }

    final t = _tripController.value;
    final board = (t / 0.16).clamp(0.0, 1.0);
    final travel = const Interval(
      0.16,
      1.0,
      curve: Curves.easeInOutCubic,
    ).transform(t);
    final tripKm = _tripPlan?.distanceKm ?? 3.8;
    final baseEta = _tripPlan?.etaMinutes ?? 6;
    final isCompleted = t >= 1.0;
    final remainingKm = isCompleted
        ? 0.0
        : double.parse(
            (tripKm * (1.0 - travel)).clamp(0.1, tripKm).toStringAsFixed(1),
          );
    final eta = isCompleted
        ? 0
        : (baseEta * (1.0 - travel)).ceil().clamp(1, baseEta);

    _boardingProgress.value = board;
    _carProgress.value = travel;
    final next = (
      phase: isCompleted ? RidePhase.completed : RidePhase.inTrip,
      eta: eta,
      remainingKm: remainingKm,
      isBoarding: !isCompleted && t < 0.16,
    );
    if (_status.value != next) {
      _status.value = next;
    }
  }

  void _handleMapTap(Offset rawPoint) {
    final snapped = RideRouting.snapToRoad(rawPoint);
    setState(() {
      if (_activeField == StopField.pickup) {
        _pickup = snapped.point;
        _pickupLabel = snapped.label;
        _approachPlan = RideRouting.planDriverApproach(_pickup);
        if (_destination == null) {
          _activeField = StopField.destination;
        }
      } else {
        _destination = snapped.point;
        _destinationLabel = snapped.label;
      }
      _tripPlan = _destination == null
          ? null
          : RideRouting.planRoute(_pickup, _destination!);
    });
  }

  void _pickPresetDestination(Offset point, String label) {
    setState(() {
      _destination = point;
      _destinationLabel = label;
      _activeField = StopField.destination;
      _tripPlan = RideRouting.planRoute(_pickup, point);
    });
  }

  void _startSearch() {
    if (_destination == null || _tripPlan == null) return;
    _tripController.reset();
    _boardingProgress.value = 0;
    _carProgress.value = 0;
    _status.value = (
      phase: RidePhase.searching,
      eta: _approachPlan.etaMinutes,
      remainingKm: _tripPlan!.distanceKm,
      isBoarding: false,
    );
    _approachController
      ..reset()
      ..forward();
  }

  void _startTripToDestination() {
    if (_status.value.phase != RidePhase.arrived) return;
    _approachController.stop();
    _boardingProgress.value = 0;
    _carProgress.value = 0;
    _status.value = (
      phase: RidePhase.inTrip,
      eta: _tripPlan?.etaMinutes ?? 6,
      remainingKm: _tripPlan?.distanceKm ?? 3.8,
      isBoarding: true,
    );
    _tripController
      ..reset()
      ..forward();
  }

  void _cancelRide() {
    _approachController.reset();
    _tripController.reset();
    _boardingProgress.value = 0;
    _carProgress.value = 0;
    _status.value = (
      phase: RidePhase.selecting,
      eta: _approachPlan.etaMinutes,
      remainingKm: _tripPlan?.distanceKm ?? 0.0,
      isBoarding: false,
    );
    _showNotice('Ride request cancelled');
  }

  void _bookAnotherRide() {
    _approachController.reset();
    _tripController.reset();
    _boardingProgress.value = 0;
    _carProgress.value = 0;
    setState(() {
      _destination = null;
      _destinationLabel = null;
      _tripPlan = null;
      _activeField = StopField.destination;
      _rating = 5;
    });
    _status.value = (
      phase: RidePhase.selecting,
      eta: _approachPlan.etaMinutes,
      remainingKm: 0,
      isBoarding: false,
    );
  }

  void _showNotice(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _trafficController.dispose();
    _approachController.dispose();
    _tripController.dispose();
    _status.dispose();
    _carProgress.dispose();
    _boardingProgress.dispose();
    _cameraFollow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripPoints = _tripPlan?.points ?? const <Offset>[];

    return Scaffold(
      body: ValueListenableBuilder<RideStatus>(
        valueListenable: _status,
        builder: (context, status, _) {
          final isSelecting = status.phase == RidePhase.selecting;

          return Stack(
            children: [
              Positioned.fill(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _cameraFollow,
                  builder: (context, follow, _) {
                    return RideMap(
                      pickupPoint: _pickup,
                      destinationPoint: _destination,
                      pickupLabel: _pickupLabel,
                      destinationLabel: _destinationLabel,
                      driverRoutePoints: _approachPlan.points,
                      tripRoutePoints: tripPoints,
                      routeProgress: _carProgress,
                      boardingProgress: _boardingProgress,
                      trafficProgress: _trafficController,
                      phase: status.phase,
                      cameraFollow: follow,
                      onMapTap: _handleMapTap,
                    );
                  },
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(RideSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RideStatusCard(
                        status: status,
                        activeField: _activeField,
                        pickupLabel: _pickupLabel,
                        destinationLabel: _destinationLabel,
                        tripDistanceKm: _tripPlan?.distanceKm,
                        farePkr: _tripPlan?.farePkr,
                      ),
                      const Spacer(),
                      if (!isSelecting) ...[
                        ValueListenableBuilder<bool>(
                          valueListenable: _cameraFollow,
                          builder: (context, follow, _) {
                            return IconButton(
                              onPressed: () {
                                _cameraFollow.value = !follow;
                                _showNotice(
                                  !follow
                                      ? 'Camera centered on ride'
                                      : 'Full map overview',
                                );
                              },
                              tooltip: 'Re-center map',
                              icon: Icon(
                                Icons.my_location_rounded,
                                color: follow
                                    ? RideColors.accent
                                    : RideColors.textPrimary,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: RideSpacing.md),
                      ],
                      DriverCard(
                        phase: status.phase,
                        activeField: _activeField,
                        pickupLabel: _pickupLabel,
                        destinationLabel: _destinationLabel,
                        distanceKm: _tripPlan?.distanceKm,
                        farePkr: _tripPlan?.farePkr,
                        routeProgress: _carProgress,
                        isBoarding: status.isBoarding,
                        rating: _rating,
                        onSelectField: (field) =>
                            setState(() => _activeField = field),
                        onPickPresetDestination: _pickPresetDestination,
                        onFindDriver: _startSearch,
                        onCall: () => _showNotice('Calling Ahsan Malik…'),
                        onMessage: () => _showNotice('Messaging Ahsan Malik…'),
                        onCancel: _cancelRide,
                        onOnMyWay: _startTripToDestination,
                        onRateDriver: (stars) {
                          setState(() => _rating = stars);
                          _showNotice('Rated Ahsan Malik $stars stars');
                        },
                        onBookAnother: _bookAnotherRide,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
