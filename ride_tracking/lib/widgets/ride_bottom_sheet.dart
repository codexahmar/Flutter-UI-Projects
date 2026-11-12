import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';
import 'package:ride_tracking/ride_routing.dart';
import 'package:ride_tracking/widgets/ride_status_card.dart';
import 'package:ride_tracking/widgets/route_step_indicator.dart';

/// Docked bottom sheet handling stop selection, nearby matching, driver confirmation, live trip, and rating.
class RideBottomSheet extends StatelessWidget {
  final RidePhase phase;
  final StopField activeField;
  final String pickupLabel;
  final String? destinationLabel;
  final double? distanceKm;
  final int? farePkr;
  final ValueListenable<double> routeProgress;
  final bool isBoarding;
  final int rating;
  final ValueChanged<StopField> onSelectField;
  final void Function(Offset point, String label) onPickPresetDestination;
  final VoidCallback onFindDriver;
  final VoidCallback onBookRide;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onCancel;
  final VoidCallback onOnMyWay;
  final ValueChanged<int> onRateDriver;
  final VoidCallback onSubmitRating;
  final VoidCallback onSkipRating;

  const RideBottomSheet({
    super.key,
    required this.phase,
    required this.activeField,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.distanceKm,
    required this.farePkr,
    required this.routeProgress,
    required this.isBoarding,
    required this.rating,
    required this.onSelectField,
    required this.onPickPresetDestination,
    required this.onFindDriver,
    required this.onBookRide,
    required this.onCall,
    required this.onMessage,
    required this.onCancel,
    required this.onOnMyWay,
    required this.onRateDriver,
    required this.onSubmitRating,
    required this.onSkipRating,
  });

  static const _avatarAsset = 'assets/images/driver_avatar.jpg';

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final resolvedDest = destinationLabel ?? 'DHA Phase 5';
    final resolvedKm = distanceKm ?? 3.8;
    final resolvedFare = farePkr ?? 410;

    final Widget content = switch (phase) {
      RidePhase.selecting => _SelectingContent(
        key: const ValueKey('selecting'),
        activeField: activeField,
        pickupLabel: pickupLabel,
        destinationLabel: destinationLabel,
        farePkr: farePkr,
        onSelectField: onSelectField,
        onPickPresetDestination: onPickPresetDestination,
        onFindDriver: onFindDriver,
      ),
      RidePhase.searching => _SearchingContent(
        key: const ValueKey('searching'),
        reduceMotion: reduceMotion,
        pickupLabel: pickupLabel,
        destinationLabel: resolvedDest,
        distanceKm: resolvedKm,
        farePkr: resolvedFare,
        onCancel: onCancel,
      ),
      RidePhase.completed => _CompletedContent(
        key: const ValueKey('completed'),
        avatarAsset: _avatarAsset,
        distanceKm: resolvedKm,
        farePkr: resolvedFare,
        rating: rating,
        onRateDriver: onRateDriver,
        onSubmitRating: onSubmitRating,
        onSkipRating: onSkipRating,
      ),
      _ => _DriverContent(
        key: const ValueKey('driver'),
        avatarAsset: _avatarAsset,
        phase: phase,
        pickupLabel: pickupLabel,
        destinationLabel: resolvedDest,
        distanceKm: resolvedKm,
        farePkr: resolvedFare,
        routeProgress: routeProgress,
        isBoarding: isBoarding,
        onBookRide: onBookRide,
        onCall: onCall,
        onMessage: onMessage,
        onCancel: onCancel,
        onOnMyWay: onOnMyWay,
      ),
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        RideSpacing.lg,
        RideSpacing.sm + 2,
        RideSpacing.lg,
        RideSpacing.lg + bottomInset,
      ),
      decoration: RideTheme.sheetDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: RideColors.border,
              borderRadius: BorderRadius.circular(RideRadius.pill),
            ),
          ),
          const SizedBox(height: RideSpacing.md),
          AnimatedSize(
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectingContent extends StatelessWidget {
  final StopField activeField;
  final String pickupLabel;
  final String? destinationLabel;
  final int? farePkr;
  final ValueChanged<StopField> onSelectField;
  final void Function(Offset point, String label) onPickPresetDestination;
  final VoidCallback onFindDriver;

  const _SelectingContent({
    super.key,
    required this.activeField,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.farePkr,
    required this.onSelectField,
    required this.onPickPresetDestination,
    required this.onFindDriver,
  });

  @override
  Widget build(BuildContext context) {
    final canRequest = destinationLabel != null && farePkr != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: RideColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(RideRadius.md),
            border: Border.all(color: RideColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: RideSpacing.md),
                child: RouteStepIndicator(
                  phase: RidePhase.selecting,
                  destinationReady: canRequest,
                  height: 69,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StopRow(
                      label: 'Pickup',
                      value: pickupLabel,
                      isActive: activeField == StopField.pickup,
                      onTap: () => onSelectField(StopField.pickup),
                    ),
                    const Divider(),
                    _StopRow(
                      label: 'Drop-off',
                      value: destinationLabel ?? 'Tap map to choose',
                      isPlaceholder: destinationLabel == null,
                      isActive: activeField == StopField.destination,
                      onTap: () => onSelectField(StopField.destination),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: RideSpacing.md),
        Wrap(
          spacing: RideSpacing.sm,
          runSpacing: RideSpacing.sm,
          children: [
            for (final preset in RideRouting.presets)
              _PresetChip(
                label: preset.label,
                selected: destinationLabel == preset.label,
                onSelected: () =>
                    onPickPresetDestination(preset.point, preset.label),
              ),
          ],
        ),
        const SizedBox(height: RideSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: canRequest ? onFindDriver : null,
            child: Text(
              canRequest ? 'Find drivers · PKR $farePkr' : 'Choose destination',
            ),
          ),
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _PresetChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: RideSpacing.xs),
      selectedColor: RideColors.accentTint,
      backgroundColor: RideColors.surfaceSubtle,
      side: BorderSide(
        color: selected ? RideColors.accentBorder : RideColors.border,
      ),
      shape: const StadiumBorder(),
      label: Text(
        label,
        style: RideText.captionTabular.copyWith(
          color: selected ? RideColors.accent : RideColors.textPrimary,
        ),
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isPlaceholder;
  final bool isActive;
  final VoidCallback onTap;

  const _StopRow({
    required this.label,
    required this.value,
    required this.isActive,
    required this.onTap,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive
          ? RideColors.accentTint.withValues(alpha: 0.65)
          : RideColors.surfaceSubtle,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: RideSpacing.md,
            vertical: RideSpacing.sm + 2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, style: RideText.caption),
                    Text(
                      value,
                      style: isPlaceholder
                          ? RideText.body.copyWith(
                              color: RideColors.textSecondary,
                            )
                          : RideText.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: RideSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RideSpacing.sm,
                    vertical: RideSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: RideColors.accentTint,
                    borderRadius: BorderRadius.circular(RideRadius.pill),
                    border: Border.all(color: RideColors.accentBorder),
                  ),
                  child: Text(
                    'Tap map',
                    style: RideText.captionTabular.copyWith(
                      color: RideColors.accent,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchingContent extends StatelessWidget {
  final bool reduceMotion;
  final String pickupLabel;
  final String destinationLabel;
  final double distanceKm;
  final int farePkr;
  final VoidCallback onCancel;

  const _SearchingContent({
    super.key,
    required this.reduceMotion,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.distanceKm,
    required this.farePkr,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Matching you nearby', style: RideText.title),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: RideSpacing.sm,
                vertical: RideSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: RideColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(RideRadius.sm),
                border: Border.all(color: RideColors.border),
              ),
              child: const Text('RideX', style: RideText.captionTabular),
            ),
          ],
        ),
        const SizedBox(height: RideSpacing.md),
        LinearProgressIndicator(
          value: reduceMotion ? 0.5 : null,
          minHeight: 3,
          borderRadius: BorderRadius.circular(RideRadius.pill),
          backgroundColor: RideColors.surfaceSubtle,
          color: RideColors.accent,
        ),
        const SizedBox(height: RideSpacing.lg),
        _TripSummary(
          phase: RidePhase.searching,
          pickupLabel: pickupLabel,
          destinationLabel: destinationLabel,
          distanceKm: distanceKm,
          farePkr: farePkr,
        ),
        const SizedBox(height: RideSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onCancel,
            child: const Text('Cancel ride'),
          ),
        ),
      ],
    );
  }
}

class _DriverContent extends StatelessWidget {
  final String avatarAsset;
  final RidePhase phase;
  final String pickupLabel;
  final String destinationLabel;
  final double distanceKm;
  final int farePkr;
  final ValueListenable<double> routeProgress;
  final bool isBoarding;
  final VoidCallback onBookRide;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onCancel;
  final VoidCallback onOnMyWay;

  const _DriverContent({
    super.key,
    required this.avatarAsset,
    required this.phase,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.distanceKm,
    required this.farePkr,
    required this.routeProgress,
    required this.isBoarding,
    required this.onBookRide,
    required this.onCall,
    required this.onMessage,
    required this.onCancel,
    required this.onOnMyWay,
  });

  @override
  Widget build(BuildContext context) {
    final isMatched = phase == RidePhase.matched;
    final isArrived = phase == RidePhase.arrived;
    final isInTrip = phase == RidePhase.inTrip;
    const buttonPadding = EdgeInsets.symmetric(horizontal: RideSpacing.md);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DriverHeader(avatarAsset: avatarAsset),
        const SizedBox(height: RideSpacing.md),
        const Divider(),
        const SizedBox(height: RideSpacing.md),
        _TripSummary(
          phase: phase,
          pickupLabel: pickupLabel,
          destinationLabel: destinationLabel,
          distanceKm: distanceKm,
          farePkr: farePkr,
          routeProgress: routeProgress,
        ),
        const SizedBox(height: RideSpacing.lg),
        if (isInTrip)
          _LiveTripProgress(
            pickupLabel: pickupLabel,
            routeProgress: routeProgress,
            isBoarding: isBoarding,
          )
        else if (isMatched)
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(padding: buttonPadding),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: RideSpacing.md),
              Expanded(
                flex: 3,
                child: FilledButton(
                  onPressed: onBookRide,
                  style: FilledButton.styleFrom(padding: buttonPadding),
                  child: Text(
                    'Book ride · PKR $farePkr',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isArrived ? onCall : onMessage,
                  style: OutlinedButton.styleFrom(padding: buttonPadding),
                  icon: Icon(
                    isArrived
                        ? Icons.call_rounded
                        : Icons.chat_bubble_outline_rounded,
                    size: 18,
                  ),
                  label: Text(isArrived ? 'Call' : 'Message'),
                ),
              ),
              const SizedBox(width: RideSpacing.md),
              Expanded(
                child: FilledButton.icon(
                  onPressed: isArrived ? onOnMyWay : onCall,
                  style: FilledButton.styleFrom(padding: buttonPadding),
                  icon: Icon(
                    isArrived
                        ? Icons.directions_walk_rounded
                        : Icons.call_rounded,
                    size: 18,
                  ),
                  label: Text(isArrived ? "I'm coming" : 'Call driver'),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _LiveTripProgress extends StatelessWidget {
  final String pickupLabel;
  final ValueListenable<double> routeProgress;
  final bool isBoarding;

  const _LiveTripProgress({
    required this.pickupLabel,
    required this.routeProgress,
    required this.isBoarding,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: routeProgress,
      builder: (context, progress, _) {
        final pct = (progress * 100).round().clamp(0, 100);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isBoarding
                        ? 'Entering at $pickupLabel'
                        : 'Heading to drop-off',
                    style: RideText.captionTabular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: RideSpacing.sm),
                Text(
                  isBoarding ? 'In car' : '$pct%',
                  style: RideText.captionTabular.copyWith(
                    color: RideColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: RideSpacing.sm),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 4,
              borderRadius: BorderRadius.circular(RideRadius.pill),
              backgroundColor: RideColors.surfaceSubtle,
              color: RideColors.accent,
            ),
          ],
        );
      },
    );
  }
}

class _CompletedContent extends StatelessWidget {
  final String avatarAsset;
  final double distanceKm;
  final int farePkr;
  final int rating;
  final ValueChanged<int> onRateDriver;
  final VoidCallback onSubmitRating;
  final VoidCallback onSkipRating;

  const _CompletedContent({
    super.key,
    required this.avatarAsset,
    required this.distanceKm,
    required this.farePkr,
    required this.rating,
    required this.onRateDriver,
    required this.onSubmitRating,
    required this.onSkipRating,
  });

  @override
  Widget build(BuildContext context) {
    final km = distanceKm.toStringAsFixed(1);
    final hasRating = rating > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _DriverAvatar(avatarAsset: avatarAsset),
            const SizedBox(width: RideSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Trip completed', style: RideText.title),
                  const SizedBox(height: RideSpacing.xs),
                  Text(
                    'Ahsan Malik · $km km',
                    style: RideText.caption.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: RideSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PKR $farePkr',
                  style: RideText.title.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: RideSpacing.xs),
                const Text('Cash paid', style: RideText.caption),
              ],
            ),
          ],
        ),
        const SizedBox(height: RideSpacing.md),
        Container(
          padding: const EdgeInsets.fromLTRB(
            RideSpacing.md,
            RideSpacing.sm,
            RideSpacing.md,
            RideSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: RideColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(RideRadius.md),
            border: Border.all(color: RideColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                hasRating
                    ? 'Rated $rating of 5 stars'
                    : 'How was your ride with Ahsan?',
                style: RideText.captionTabular.copyWith(
                  color: hasRating
                      ? RideColors.rating
                      : RideColors.textSecondary,
                ),
              ),
              const SizedBox(height: RideSpacing.xs),
              Row(
                children: [
                  for (var star = 1; star <= 5; star++)
                    Expanded(
                      child: IconButton(
                        onPressed: () => onRateDriver(star),
                        tooltip: 'Rate $star stars',
                        style: IconButton.styleFrom(
                          backgroundColor: RideColors.surfaceSubtle,
                          side: BorderSide.none,
                          minimumSize: const Size.square(44),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                        ),
                        icon: Icon(
                          star <= rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 28,
                          color: star <= rating
                              ? RideColors.rating
                              : RideColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: RideSpacing.lg),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: onSkipRating,
                child: const Text('Skip'),
              ),
            ),
            const SizedBox(width: RideSpacing.md),
            Expanded(
              flex: 3,
              child: FilledButton(
                onPressed: hasRating ? onSubmitRating : null,
                child: Text(hasRating ? 'Submit rating' : 'Rate driver'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DriverHeader extends StatelessWidget {
  final String avatarAsset;

  const _DriverHeader({required this.avatarAsset});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _DriverAvatar(avatarAsset: avatarAsset),
        const SizedBox(width: RideSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ahsan Malik',
                style: RideText.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: RideSpacing.xs),
              Semantics(
                label: 'Rated 4.9 stars over 1.2k trips',
                excludeSemantics: true,
                child: const Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: RideColors.rating,
                      size: 14,
                    ),
                    SizedBox(width: RideSpacing.xs),
                    Text('4.9 · 1.2k trips', style: RideText.captionTabular),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: RideSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: RideSpacing.md,
                vertical: RideSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: RideColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(RideRadius.sm),
                border: Border.all(color: RideColors.border),
              ),
              child: Text(
                'LEA 4821',
                style: RideText.body.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(height: RideSpacing.xs),
            const Text('White Honda Civic', style: RideText.caption),
          ],
        ),
      ],
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  final String avatarAsset;

  const _DriverAvatar({required this.avatarAsset});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: RideColors.surfaceSubtle,
            border: Border.all(color: RideColors.border, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            avatarAsset,
            fit: BoxFit.cover,
            cacheWidth: 160,
            cacheHeight: 160,
            filterQuality: FilterQuality.high,
            semanticLabel: 'Driver Ahsan Malik',
            errorBuilder: (_, _, _) => const Icon(
              Icons.person_rounded,
              color: RideColors.textSecondary,
              size: 24,
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RideColors.accent,
              border: Border.all(color: RideColors.surface, width: 2),
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 10,
              color: RideColors.inkOnAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class _TripSummary extends StatelessWidget {
  final RidePhase phase;
  final String pickupLabel;
  final String destinationLabel;
  final double distanceKm;
  final int farePkr;
  final ValueListenable<double>? routeProgress;

  const _TripSummary({
    required this.phase,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.distanceKm,
    required this.farePkr,
    this.routeProgress,
  });

  @override
  Widget build(BuildContext context) {
    final km = distanceKm.toStringAsFixed(1);
    return Semantics(
      label:
          'Pickup at $pickupLabel, drop-off at $destinationLabel, $km kilometers, fare PKR $farePkr cash',
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RouteStepIndicator(
            phase: phase,
            routeProgress: routeProgress,
            height: 44,
          ),
          const SizedBox(width: RideSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pickupLabel,
                  style: RideText.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: RideSpacing.xs),
                Text(
                  '$destinationLabel · $km km',
                  style: RideText.caption.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: RideSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PKR $farePkr',
                style: RideText.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: RideSpacing.xs),
              const Text('Cash', style: RideText.caption),
            ],
          ),
        ],
      ),
    );
  }
}
