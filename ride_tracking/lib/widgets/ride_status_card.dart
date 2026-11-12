import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';

enum RidePhase { searching, matched, arriving, arrived }

typedef RideStatus = ({RidePhase phase, int eta});

/// Floating status header putting the live answer (ETA or arrival state) first.
class RideStatusCard extends StatelessWidget {
  final RideStatus status;

  const RideStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (title, subtitle) = switch (status.phase) {
      RidePhase.searching => ('Finding a driver', 'Checking nearby vehicles…'),
      RidePhase.matched => ('Driver matched', 'Accepted your ride'),
      RidePhase.arriving => ('Driver arriving', 'On the way to pickup'),
      RidePhase.arrived => ('Driver arrived', 'Waiting at pickup point'),
    };

    return Container(
      padding: const EdgeInsets.all(RideSpacing.lg),
      decoration: RideTheme.cardDecoration,
      child: Row(
        children: [
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
                key: ValueKey(status.phase),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: RideText.title),
                  const SizedBox(height: RideSpacing.xs),
                  Text(subtitle, style: RideText.caption),
                ],
              ),
            ),
          ),
          if (status.phase != RidePhase.searching) ...[
            const SizedBox(width: RideSpacing.md),
            _StatusTrailing(status: status),
          ],
        ],
      ),
    );
  }
}

class _StatusTrailing extends StatelessWidget {
  final RideStatus status;

  const _StatusTrailing({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status.phase == RidePhase.arrived) {
      return Semantics(
        label: 'Driver is here',
        excludeSemantics: true,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: RideSpacing.md,
            vertical: RideSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: RideColors.accentTint,
            borderRadius: BorderRadius.circular(RideRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_rounded,
                size: 16,
                color: RideColors.accent,
              ),
              const SizedBox(width: RideSpacing.xs),
              Text(
                'Here',
                style: RideText.captionTabular.copyWith(
                  color: RideColors.accent,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Semantics(
      label: '${status.eta} minutes away',
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
