import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';

enum RidePhase {
  selecting,
  searching,
  matched,
  arriving,
  arrived,
  inTrip,
  completed,
}

enum StopField { pickup, destination }

typedef RideStatus = ({
  RidePhase phase,
  int eta,
  double remainingKm,
  bool isBoarding,
});

/// Minimal floating status pill showing route setup, live ETA, PIN, and drop-off state.
class RideStatusCard extends StatelessWidget {
  final RideStatus status;
  final StopField activeField;
  final String pickupLabel;
  final String? destinationLabel;
  final double? tripDistanceKm;
  final int? tripEtaMinutes;
  final int? farePkr;

  const RideStatusCard({
    super.key,
    required this.status,
    required this.activeField,
    required this.pickupLabel,
    required this.destinationLabel,
    this.tripDistanceKm,
    this.tripEtaMinutes,
    this.farePkr,
  });

  @override
  Widget build(BuildContext context) {
    final km = (tripDistanceKm ?? 0).toStringAsFixed(1);
    final tripEta = tripEtaMinutes ?? 6;
    final remaining = status.remainingKm.toStringAsFixed(1);
    final isIdle =
        status.phase == RidePhase.selecting && destinationLabel == null;

    final (title, subtitle) = switch (status.phase) {
      RidePhase.selecting when destinationLabel == null => (
        activeField == StopField.pickup
            ? 'Set pickup point'
            : 'Set destination',
        activeField == StopField.pickup
            ? 'Tap any road or place on map'
            : 'Tap any place or pick below',
      ),
      RidePhase.selecting => (
        '$km km · $tripEta min ride',
        '$pickupLabel → $destinationLabel',
      ),
      RidePhase.searching => (
        'Finding drivers',
        'Searching near $pickupLabel',
      ),
      RidePhase.matched => ('Driver found', 'Ahsan Malik · Ready to book'),
      RidePhase.arriving when status.eta <= 1 => (
        'Arriving soon',
        'Almost at $pickupLabel',
      ),
      RidePhase.arriving => ('Driver on the way', 'Heading to $pickupLabel'),
      RidePhase.arrived => ('Driver arrived', 'Outside at $pickupLabel'),
      RidePhase.inTrip when status.isBoarding => (
        'Boarding RideX',
        'Starting at $pickupLabel',
      ),
      RidePhase.inTrip => (
        'To $destinationLabel',
        '$remaining km left · RideX',
      ),
      RidePhase.completed => ('You arrived', 'Dropped at $destinationLabel'),
    };

    final icon = switch (status.phase) {
      RidePhase.selecting => Icons.alt_route_rounded,
      RidePhase.searching => Icons.radar_rounded,
      RidePhase.matched ||
      RidePhase.arriving => Icons.directions_car_filled_rounded,
      RidePhase.arrived => Icons.location_on_rounded,
      RidePhase.inTrip => Icons.navigation_rounded,
      RidePhase.completed => Icons.check_rounded,
    };

    final showTrailing = status.phase != RidePhase.searching && !isIdle;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RideSpacing.md,
        vertical: RideSpacing.md,
      ),
      decoration: RideTheme.cardDecoration,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isIdle ? RideColors.surfaceSubtle : RideColors.accentTint,
              borderRadius: BorderRadius.circular(RideRadius.sm),
              border: Border.all(
                color: isIdle ? RideColors.border : RideColors.accentBorder,
              ),
            ),
            child: Icon(
              icon,
              size: 17,
              color: isIdle ? RideColors.textSecondary : RideColors.accent,
            ),
          ),
          const SizedBox(width: RideSpacing.md),
          Expanded(
            child: AnimatedSwitcher(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.centerLeft,
                children: [...previous, ?current],
              ),
              child: Column(
                key: ValueKey(
                  '${status.phase}-${status.isBoarding}-${activeField.name}-${destinationLabel ?? ''}-$pickupLabel',
                ),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: RideText.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: RideSpacing.xs),
                  Text(
                    subtitle,
                    style: RideText.caption.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          if (showTrailing) ...[
            const SizedBox(width: RideSpacing.md),
            _StatusTrailing(status: status, farePkr: farePkr),
          ],
        ],
      ),
    );
  }
}

class _StatusTrailing extends StatelessWidget {
  final RideStatus status;
  final int? farePkr;

  const _StatusTrailing({required this.status, required this.farePkr});

  @override
  Widget build(BuildContext context) {
    if (status.phase == RidePhase.selecting && farePkr != null) {
      return _StatusPill(label: 'PKR $farePkr');
    }

    if (status.phase == RidePhase.arrived) {
      return Semantics(
        label: 'Driver is here, ride PIN 4920',
        excludeSemantics: true,
        child: const _StatusPill(label: 'PIN 4920', highlighted: true),
      );
    }

    if (status.phase == RidePhase.completed) {
      return Semantics(
        label: 'Ride completed and fare paid',
        excludeSemantics: true,
        child: const _StatusPill(label: 'Paid', highlighted: true),
      );
    }

    return Semantics(
      label: '${status.eta} minutes remaining',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '${status.eta}',
            style: RideText.hero.copyWith(color: RideColors.accent),
          ),
          const SizedBox(width: RideSpacing.xs),
          const Text('min', style: RideText.caption),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final bool highlighted;

  const _StatusPill({required this.label, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RideSpacing.md,
        vertical: RideSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: highlighted ? RideColors.accentTint : RideColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(RideRadius.pill),
        border: Border.all(
          color: highlighted ? RideColors.accentBorder : RideColors.border,
        ),
      ),
      child: Text(
        label,
        style: RideText.captionTabular.copyWith(
          color: highlighted ? RideColors.accent : RideColors.textPrimary,
        ),
      ),
    );
  }
}
