import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';
import 'package:ride_tracking/widgets/driver_card.dart';
import 'package:ride_tracking/widgets/radar_pulse.dart';
import 'package:ride_tracking/widgets/ride_map.dart';
import 'package:ride_tracking/widgets/ride_status_card.dart';

class RideTrackingScreen extends StatefulWidget {
  const RideTrackingScreen({super.key});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen>
    with SingleTickerProviderStateMixin {
  static const _routePoints = [
    Offset(0.16, 0.74),
    Offset(0.31, 0.74),
    Offset(0.31, 0.58),
    Offset(0.56, 0.58),
    Offset(0.56, 0.40),
    Offset(0.80, 0.40),
    Offset(0.80, 0.22),
  ];

  late final AnimationController _controller;
  final _status = ValueNotifier<RideStatus>((
    phase: RidePhase.searching,
    eta: 4,
  ));
  final _carProgress = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 13))
          ..addListener(_onTick)
          ..repeat();
  }

  void _onTick() {
    final t = _controller.value;
    final phase = switch (t) {
      < 0.26 => RidePhase.searching,
      < 0.38 => RidePhase.matched,
      < 0.92 => RidePhase.arriving,
      _ => RidePhase.arrived,
    };
    final progress = const Interval(0.38, 0.92).transform(t);
    final eta = phase == RidePhase.arrived
        ? 0
        : (4 - progress * 4).ceil().clamp(1, 4);

    _status.value = (phase: phase, eta: eta);
    _carProgress.value = progress;
  }

  void _showNotice(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _controller.dispose();
    _status.dispose();
    _carProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<RideStatus>(
        valueListenable: _status,
        builder: (context, status, _) {
          final isSearching = status.phase == RidePhase.searching;

          return Stack(
            children: [
              Positioned.fill(
                child: RideMap(
                  routePoints: _routePoints,
                  routeProgress: _carProgress,
                  showRoute: !isSearching,
                ),
              ),
              if (isSearching)
                const Positioned.fill(
                  child: IgnorePointer(child: Center(child: RadarPulse())),
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(RideSpacing.lg),
                  child: Column(
                    children: [
                      RideStatusCard(status: status),
                      const Spacer(),
                      DriverCard(
                        isSearching: isSearching,
                        onCall: () => _showNotice('Calling Ahsan Malik…'),
                        onMessage: () => _showNotice('Messaging Ahsan Malik…'),
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
