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
  final int? farePkr;

  const RideStatusCard({
    super.key,
    required this.status,
    required this.activeField,
    required this.pickupLabel,
    required this.destinationLabel,
    this.tripDistanceKm,
    this.farePkr,
  });

  @override
  Widget build(BuildContext context) {
    final km = (tripDistanceKm ?? 0).toStringAsFixed(1);
    final remaining = status.remainingKm.toStringAsFixed(1);

    final (title, subtitle) = switch (status.phase) {
      RidePhase.selecting when destinationLabel == null => (
        activeField == StopField.pickup
            ? 'Set pickup on map'
            : 'Set destination on map',
        activeField == StopField.pickup
            ? 'Tap any street to move pickup'
            : 'Tap map or pick a drop-off below',
      ),
      RidePhase.selecting => (
        'Route ready',
        '$pickupLabel → $destinationLabel · $km km',
      ),
      RidePhase.searching => (
        'Finding your driver',
        '3 nearby drivers near $pickupLabel',
      ),
      RidePhase.matched => ('Driver on the way', 'Heading to $pickupLabel'),
      RidePhase.arriving => ('Arriving soon', 'Coming to $pickupLabel'),
      RidePhase.arrived => (
        'Driver has arrived',
        'Share PIN 4920 to board at $pickupLabel',
      ),
      RidePhase.inTrip when status.isBoarding => (
        'Getting in the car',
        'Starting trip from $pickupLabel',
      ),
      RidePhase.inTrip => (
        'On trip to $destinationLabel',
        '$remaining km left · Heading to drop-off',
      ),
      RidePhase.completed => (
        'You have arrived',
        'Dropped off at $destinationLabel',
      ),
    };

    final showTrailing =
        status.phase != RidePhase.searching &&
        !(status.phase == RidePhase.selecting && destinationLabel == null);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RideSpacing.lg,
        vertical: RideSpacing.md,
      ),
      decoration: RideTheme.cardDecoration,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  status.phase == RidePhase.selecting &&
                      destinationLabel == null
                  ? RideColors.textSecondary
                  : RideColors.accent,
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
        border: highlighted ? null : Border.all(color: RideColors.border),
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
