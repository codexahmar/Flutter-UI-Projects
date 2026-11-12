import 'package:flutter/material.dart';
import 'package:ride_tracking/app_theme.dart';

/// Solid floating bottom card displaying driver matching status or assigned driver info.
class DriverCard extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const DriverCard({
    super.key,
    required this.isSearching,
    required this.onCall,
    required this.onMessage,
  });

  static const _avatarUrl =
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=200';

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Container(
      padding: const EdgeInsets.all(RideSpacing.lg),
      decoration: RideTheme.cardDecoration,
      child: AnimatedSwitcher(
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 180),
        child: isSearching
            ? _SearchingRow(
                key: const ValueKey('searching'),
                reduceMotion: reduceMotion,
              )
            : _DriverRow(
                key: const ValueKey('driver'),
                avatarUrl: _avatarUrl,
                onCall: onCall,
                onMessage: onMessage,
              ),
      ),
    );
  }
}

class _SearchingRow extends StatelessWidget {
  final bool reduceMotion;

  const _SearchingRow({super.key, required this.reduceMotion});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: RideColors.surfaceSubtle,
          ),
          alignment: Alignment.center,
          child: reduceMotion
              ? const Icon(
                  Icons.directions_car_rounded,
                  color: RideColors.accent,
                  size: 20,
                )
              : const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: RideColors.accent,
                  ),
                ),
        ),
        const SizedBox(width: RideSpacing.md),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Matching nearby drivers', style: RideText.title),
              SizedBox(height: RideSpacing.xs),
              Text(
                'Driver details will appear once assigned',
                style: RideText.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DriverRow extends StatelessWidget {
  final String avatarUrl;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const _DriverRow({
    super.key,
    required this.avatarUrl,
    required this.onCall,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                label: 'Rated 4.9, Honda Civic, plate LEA 4821',
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
                    SizedBox(width: RideSpacing.sm),
                    Expanded(
                      child: Text(
                        'Honda Civic · LEA 4821',
                        style: RideText.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: RideSpacing.sm),
        IconButton(
          onPressed: onCall,
          tooltip: 'Call driver',
          icon: const Icon(Icons.call_rounded),
        ),
        const SizedBox(width: RideSpacing.sm),
        IconButton(
          onPressed: onMessage,
          tooltip: 'Message driver',
          icon: const Icon(Icons.chat_bubble_outline_rounded),
        ),
      ],
    );
  }
}
