import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';
import 'package:ride_tracking/ride_routing.dart';
import 'package:ride_tracking/widgets/ride_bottom_sheet.dart';
import 'package:ride_tracking/widgets/ride_map.dart';
import 'package:ride_tracking/widgets/ride_snackbar.dart';
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
  late final AnimationController _departureController;

  late RideRoutePlan _approachPlan;
  RideRoutePlan? _tripPlan;
  List<Offset> _departurePoints = const [];

  final _status = ValueNotifier<RideStatus>((
    phase: RidePhase.selecting,
    eta: 4,
    remainingKm: 0,
    isBoarding: false,
  ));
  final _carProgress = ValueNotifier<double>(0);
  final _boardingProgress = ValueNotifier<double>(0);
  final _cameraFollow = ValueNotifier<bool>(true);
  final _notice = ValueNotifier<RideNotice?>(null);

  Offset _pickup = RideRouting.defaultPickup;
  String _pickupLabel = RideRouting.defaultPickupLabel;
  Offset? _destination;
  String? _destinationLabel;
  StopField _activeField = StopField.destination;
  Timer? _searchTimer;
  Timer? _noticeTimer;
  int _noticeSeq = 0;
  int _rating = 0;
  bool _bookingOpen = false;

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
      duration: const Duration(seconds: 7),
    )..addListener(_onApproachTick);
    _tripController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..addListener(_onTripTick);
    _departureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
  }

  void _showNotice(
    String title, {
    String? subtitle,
    required IconData icon,
    String? tag,
    bool isMuted = false,
  }) {
    _noticeTimer?.cancel();
    _notice.value = (
      id: ++_noticeSeq,
      title: title,
      subtitle: subtitle,
      icon: icon,
      tag: tag,
      isMuted: isMuted,
    );
    _noticeTimer = Timer(const Duration(seconds: 2), _dismissNotice);
  }

  void _dismissNotice() {
    _noticeTimer?.cancel();
    if (_notice.value != null) {
      _notice.value = null;
    }
  }

  void _onApproachTick() {
    if (_status.value.phase != RidePhase.arriving) return;

    final t = _approachController.value.clamp(0.0, 1.0);
    final arrived = t >= 1.0;
    final baseEta = _approachPlan.etaMinutes;
    final eta = arrived
        ? 0
        : (baseEta - t * baseEta).ceil().clamp(1, baseEta);

    _carProgress.value = t;
    final next = (
      phase: arrived ? RidePhase.arrived : RidePhase.arriving,
      eta: eta,
      remainingKm: _tripPlan?.distanceKm ?? 0.0,
      isBoarding: false,
    );
    if (_status.value != next) {
      _status.value = next;
      if (arrived) {
        _showNotice(
          'Driver has arrived',
          subtitle: 'Meet Ahsan outside at $_pickupLabel',
          icon: Icons.location_on_rounded,
        );
      }
    }
  }

  void _onTripTick() {
    if (_status.value.phase != RidePhase.inTrip) return;

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
      if (isCompleted && _destination != null) {
        _departurePoints = RideRouting.planDepartureRoute(
          _destination!,
          _tripPlan?.points ?? const [],
        );
        _departureController
          ..reset()
          ..forward();
      }
      _status.value = next;
      if (isCompleted) {
        _showNotice(
          'You have arrived',
          subtitle: 'Dropped off at ${_destinationLabel ?? 'destination'}',
          icon: Icons.flag_rounded,
        );
      }
    }
  }

  void _openBooking() {
    _searchTimer?.cancel();
    _approachController.reset();
    _tripController.reset();
    _departureController.reset();
    _boardingProgress.value = 0;
    _carProgress.value = 0;
    _dismissNotice();
    setState(() {
      _bookingOpen = true;
      _destination = null;
      _destinationLabel = null;
      _tripPlan = null;
      _departurePoints = const [];
      _activeField = StopField.destination;
      _rating = 0;
    });
    _status.value = (
      phase: RidePhase.selecting,
      eta: _approachPlan.etaMinutes,
      remainingKm: 0,
      isBoarding: false,
    );
  }

  void _handleMapTap(Offset rawPoint) {
    final snapped = RideRouting.snapToRoad(rawPoint);
    final pickedPickup = _activeField == StopField.pickup;
    setState(() {
      if (pickedPickup) {
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
    _showNotice(
      pickedPickup ? 'Pickup updated' : 'Destination updated',
      subtitle: 'At ${snapped.label}',
      icon: pickedPickup ? Icons.my_location_rounded : Icons.place_rounded,
    );
  }

  void _pickPresetDestination(Offset point, String label) {
    final plan = RideRouting.planRoute(_pickup, point);
    setState(() {
      _destination = point;
      _destinationLabel = label;
      _activeField = StopField.destination;
      _tripPlan = plan;
    });
    _showNotice(
      'Destination updated',
      subtitle: 'To $label',
      icon: Icons.alt_route_rounded,
    );
  }

  void _startSearch() {
    if (_destination == null || _tripPlan == null) return;
    _searchTimer?.cancel();
    _approachController.reset();
    _tripController.reset();
    _departureController.reset();
    _boardingProgress.value = 0;
    _carProgress.value = 0;
    setState(() {
      _departurePoints = const [];
      _rating = 0;
    });
    _status.value = (
      phase: RidePhase.searching,
      eta: _approachPlan.etaMinutes,
      remainingKm: _tripPlan!.distanceKm,
      isBoarding: false,
    );
    _searchTimer = Timer(const Duration(milliseconds: 2200), _onDriverFound);
  }

  void _onDriverFound() {
    if (!mounted || _status.value.phase != RidePhase.searching) return;
    _carProgress.value = 0;
    _status.value = (
      phase: RidePhase.matched,
      eta: _approachPlan.etaMinutes,
      remainingKm: _tripPlan?.distanceKm ?? 3.8,
      isBoarding: false,
    );
    _showNotice(
      'Driver found nearby',
      subtitle: 'Ahsan Malik · White Honda Civic',
      icon: Icons.directions_car_filled_rounded,
    );
  }

  void _confirmBookRide() {
    if (_status.value.phase != RidePhase.matched) return;
    _status.value = (
      phase: RidePhase.arriving,
      eta: _approachPlan.etaMinutes,
      remainingKm: _tripPlan?.distanceKm ?? 3.8,
      isBoarding: false,
    );
    _showNotice(
      'Ride booked',
      subtitle: 'Ahsan Malik heading to $_pickupLabel',
      icon: Icons.check_circle_rounded,
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
    _showNotice(
      'Trip started',
      subtitle: 'To ${_destinationLabel ?? 'drop-off'}',
      icon: Icons.navigation_rounded,
    );
    _tripController
      ..reset()
      ..forward();
  }

  void _cancelRide() {
    _searchTimer?.cancel();
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
    _showNotice(
      'Ride request cancelled',
      subtitle: 'Adjust your stops anytime',
      icon: Icons.close_rounded,
      isMuted: true,
    );
  }

  void _finishCompleted({required bool rated}) {
    if (rated && _rating == 0) return;
    final submittedRating = _rating;
    _searchTimer?.cancel();
    _approachController.reset();
    _tripController.reset();
    _boardingProgress.value = 0;
    _carProgress.value = 0;
    setState(() {
      _bookingOpen = false;
      _destination = null;
      _destinationLabel = null;
      _tripPlan = null;
      _activeField = StopField.destination;
      _rating = 0;
    });
    _status.value = (
      phase: RidePhase.selecting,
      eta: _approachPlan.etaMinutes,
      remainingKm: 0,
      isBoarding: false,
    );
    if (rated) {
      _showNotice(
        'Thanks for rating Ahsan',
        subtitle: 'Rated Ahsan Malik $submittedRating of 5',
        icon: Icons.star_rounded,
        tag: '$submittedRating/5',
      );
    } else {
      _dismissNotice();
    }
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _noticeTimer?.cancel();
    _trafficController.dispose();
    _approachController.dispose();
    _tripController.dispose();
    _departureController.dispose();
    _status.dispose();
    _carProgress.dispose();
    _boardingProgress.dispose();
    _cameraFollow.dispose();
    _notice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripPoints = _tripPlan?.points ?? const <Offset>[];
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      body: ValueListenableBuilder<RideStatus>(
        valueListenable: _status,
        builder: (context, status, _) {
          final showActiveChrome = _bookingOpen;
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
                      departureRoutePoints: _departurePoints,
                      routeProgress: _carProgress,
                      boardingProgress: _boardingProgress,
                      departureProgress: _departureController,
                      trafficProgress: _trafficController,
                      phase: status.phase,
                      showBooking: showActiveChrome,
                      cameraFollow: follow,
                      onMapTap: showActiveChrome ? _handleMapTap : null,
                    );
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showActiveChrome)
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          RideSpacing.lg,
                          RideSpacing.lg,
                          RideSpacing.lg,
                          0,
                        ),
                        child: RideStatusCard(
                          status: status,
                          activeField: _activeField,
                          pickupLabel: _pickupLabel,
                          destinationLabel: _destinationLabel,
                          tripDistanceKm: _tripPlan?.distanceKm,
                          tripEtaMinutes: _tripPlan?.etaMinutes,
                          farePkr: _tripPlan?.farePkr,
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (showActiveChrome && !isSelecting)
                    Padding(
                      padding: const EdgeInsets.only(
                        right: RideSpacing.lg,
                        bottom: RideSpacing.md,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _cameraFollow,
                          builder: (context, follow, _) {
                            return IconButton(
                              onPressed: () {
                                _cameraFollow.value = !follow;
                                _showNotice(
                                  !follow ? 'Camera centered' : 'Full map view',
                                  icon: Icons.my_location_rounded,
                                  isMuted: follow,
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
                      ),
                    ),
                  AnimatedSwitcher(
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    child: !showActiveChrome
                        ? SafeArea(
                            key: const ValueKey('book_ride_cta'),
                            top: false,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: RideSpacing.lg,
                              ),
                              child: Center(
                                child: FilledButton.icon(
                                  onPressed: _openBooking,
                                  icon: const Icon(
                                    Icons.directions_car_filled_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('Book a ride'),
                                ),
                              ),
                            ),
                          )
                        : RideBottomSheet(
                            key: const ValueKey('bottom_sheet'),
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
                            onBookRide: _confirmBookRide,
                            onCall: () => _showNotice(
                              'Calling Ahsan Malik…',
                              subtitle: 'Shielded ride audio',
                              icon: Icons.phone_in_talk_rounded,
                            ),
                            onMessage: () => _showNotice(
                              'Message sent',
                              subtitle: 'Delivered to Ahsan Malik',
                              icon: Icons.chat_bubble_rounded,
                            ),
                            onCancel: _cancelRide,
                            onOnMyWay: _startTripToDestination,
                            onRateDriver: (stars) =>
                                setState(() => _rating = stars),
                            onSubmitRating: () =>
                                _finishCompleted(rated: true),
                            onSkipRating: () => _finishCompleted(rated: false),
                          ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      RideSpacing.lg,
                      RideSpacing.lg,
                      RideSpacing.lg,
                      0,
                    ),
                    child: ValueListenableBuilder<RideNotice?>(
                      valueListenable: _notice,
                      builder: (context, notice, _) => RideSnackbar(
                        notice: notice,
                        onDismiss: _dismissNotice,
                      ),
                    ),
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
