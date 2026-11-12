import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';
import 'package:ride_tracking/ride_routing.dart';
import 'package:ride_tracking/widgets/ride_status_card.dart';

/// Floating bottom card for stop selection, driver search, active ride, trip progress, and drop-off completion.
class DriverCard extends StatelessWidget {
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
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onCancel;
  final VoidCallback onOnMyWay;
  final ValueChanged<int> onRateDriver;
  final VoidCallback onBookAnother;

  const DriverCard({
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
    required this.onCall,
    required this.onMessage,
    required this.onCancel,
    required this.onOnMyWay,
    required this.onRateDriver,
    required this.onBookAnother,
  });

  static const _avatarUrl =
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=200';

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
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
        avatarUrl: _avatarUrl,
        pickupLabel: pickupLabel,
        destinationLabel: resolvedDest,
        distanceKm: resolvedKm,
        farePkr: resolvedFare,
        rating: rating,
        onRateDriver: onRateDriver,
        onBookAnother: onBookAnother,
      ),
      _ => _DriverContent(
        key: const ValueKey('driver'),
        avatarUrl: _avatarUrl,
        phase: phase,
        pickupLabel: pickupLabel,
        destinationLabel: resolvedDest,
        distanceKm: resolvedKm,
        farePkr: resolvedFare,
        routeProgress: routeProgress,
        isBoarding: isBoarding,
        onCall: onCall,
        onMessage: onMessage,
        onOnMyWay: onOnMyWay,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(RideSpacing.lg),
      decoration: RideTheme.cardDecoration,
      child: AnimatedSize(
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
        _StopRow(
          label: 'Pickup',
          value: pickupLabel,
          isPickup: true,
          isActive: activeField == StopField.pickup,
          onTap: () => onSelectField(StopField.pickup),
        ),
        const SizedBox(height: RideSpacing.sm),
        _StopRow(
          label: 'Destination',
          value: destinationLabel ?? 'Tap map to select drop-off',
          isPickup: false,
          isPlaceholder: destinationLabel == null,
          isActive: activeField == StopField.destination,
          onTap: () => onSelectField(StopField.destination),
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
            style: canRequest
                ? FilledButton.styleFrom(
                    backgroundColor: RideColors.accent,
                    foregroundColor: RideColors.inkOnAccent,
                  )
                : null,
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
      selectedColor: RideColors.accentTint,
      backgroundColor: RideColors.surfaceSubtle,
      side: BorderSide(
        color: selected ? RideColors.accent : RideColors.border,
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
  final bool isPickup;
  final bool isPlaceholder;
  final bool isActive;
  final VoidCallback onTap;

  const _StopRow({
    required this.label,
    required this.value,
    required this.isPickup,
    required this.isActive,
    required this.onTap,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RideColors.surfaceSubtle,
      borderRadius: BorderRadius.circular(RideRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: RideSpacing.md,
            vertical: RideSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RideRadius.md),
            border: Border.all(
              color: isActive ? RideColors.accent : RideColors.border,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: isPickup ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: isPickup ? null : BorderRadius.circular(2),
                  color: isPickup ? RideColors.accent : RideColors.textPrimary,
                ),
              ),
              const SizedBox(width: RideSpacing.md),
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
              if (isActive)
                Text(
                  'Tap map',
                  style: RideText.captionTabular.copyWith(
                    color: RideColors.accent,
                  ),
                ),
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
  final String avatarUrl;
  final RidePhase phase;
  final String pickupLabel;
  final String destinationLabel;
  final double distanceKm;
  final int farePkr;
  final ValueListenable<double> routeProgress;
  final bool isBoarding;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onOnMyWay;

  const _DriverContent({
    super.key,
    required this.avatarUrl,
    required this.phase,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.distanceKm,
    required this.farePkr,
    required this.routeProgress,
    required this.isBoarding,
    required this.onCall,
    required this.onMessage,
    required this.onOnMyWay,
  });

  @override
  Widget build(BuildContext context) {
    final isArrived = phase == RidePhase.arrived;
    final isInTrip = phase == RidePhase.inTrip;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DriverHeader(avatarUrl: avatarUrl),
        const SizedBox(height: RideSpacing.lg),
        _TripSummary(
          pickupLabel: pickupLabel,
          destinationLabel: destinationLabel,
          distanceKm: distanceKm,
          farePkr: farePkr,
        ),
        const SizedBox(height: RideSpacing.lg),
        if (isInTrip)
          _LiveTripProgress(
            pickupLabel: pickupLabel,
            destinationLabel: destinationLabel,
            routeProgress: routeProgress,
            isBoarding: isBoarding,
          )
        else
          Row(
            children: [
              Expanded(
                flex: isArrived ? 4 : 5,
                child: OutlinedButton(
                  onPressed: isArrived ? onCall : onMessage,
                  child: Row(
                    mainAxisAlignment: isArrived
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Icon(
                        isArrived
                            ? Icons.call_rounded
                            : Icons.chat_bubble_outline_rounded,
                        size: 18,
                      ),
                      const SizedBox(width: RideSpacing.sm),
                      Flexible(
                        child: Text(
                          isArrived ? 'Call' : 'Message',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: RideSpacing.md),
              Expanded(
                flex: isArrived ? 5 : 4,
                child: FilledButton.icon(
                  onPressed: isArrived ? onOnMyWay : onCall,
                  style: isArrived
                      ? FilledButton.styleFrom(
                          backgroundColor: RideColors.accent,
                          foregroundColor: RideColors.inkOnAccent,
                        )
                      : null,
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
  final String destinationLabel;
  final ValueListenable<double> routeProgress;
  final bool isBoarding;

  const _LiveTripProgress({
    required this.pickupLabel,
    required this.destinationLabel,
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
                        ? 'Boarding at $pickupLabel'
                        : 'Heading to $destinationLabel',
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
  final String avatarUrl;
  final String pickupLabel;
  final String destinationLabel;
  final double distanceKm;
  final int farePkr;
  final int rating;
  final ValueChanged<int> onRateDriver;
  final VoidCallback onBookAnother;

  const _CompletedContent({
    super.key,
    required this.avatarUrl,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.distanceKm,
    required this.farePkr,
    required this.rating,
    required this.onRateDriver,
    required this.onBookAnother,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _DriverAvatar(avatarUrl: avatarUrl),
            const SizedBox(width: RideSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Trip completed', style: RideText.title),
                  const SizedBox(height: RideSpacing.xs),
                  Text(
                    '$pickupLabel → $destinationLabel · ${distanceKm.toStringAsFixed(1)} km',
                    style: RideText.caption,
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
          padding: const EdgeInsets.symmetric(
            horizontal: RideSpacing.md,
            vertical: RideSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: RideColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(RideRadius.md),
            border: Border.all(color: RideColors.border),
          ),
          child: Row(
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
                      Icons.star_rounded,
                      size: 28,
                      color: star <= rating
                          ? RideColors.rating
                          : RideColors.border,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: RideSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onBookAnother,
            style: FilledButton.styleFrom(
              backgroundColor: RideColors.accent,
              foregroundColor: RideColors.inkOnAccent,
            ),
            child: const Text('Book another ride'),
          ),
        ),
      ],
    );
  }
}

class _DriverHeader extends StatelessWidget {
  final String avatarUrl;

  const _DriverHeader({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _DriverAvatar(avatarUrl: avatarUrl),
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
                label: 'Rated 4.9 stars',
                excludeSemantics: true,
                child: const Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: RideColors.rating,
                      size: 14,
                    ),
                    SizedBox(width: RideSpacing.xs),
                    Text('4.9', style: RideText.captionTabular),
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
  final String avatarUrl;

  const _DriverAvatar({required this.avatarUrl});

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
            border: Border.all(color: RideColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            avatarUrl,
            fit: BoxFit.cover,
            cacheWidth: 96,
            cacheHeight: 96,
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
  final String pickupLabel;
  final String destinationLabel;
  final double distanceKm;
  final int farePkr;

  const _TripSummary({
    required this.pickupLabel,
    required this.destinationLabel,
    required this.distanceKm,
    required this.farePkr,
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: RideColors.accent,
                ),
              ),
              Container(width: 1.5, height: 14, color: RideColors.border),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: RideColors.textPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
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
