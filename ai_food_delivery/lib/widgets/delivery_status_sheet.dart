import 'package:flutter/material.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Content-sized bottom sheet displaying courier details and delivery steps.
class DeliveryStatusSheet extends StatelessWidget {
  final FoodItem food;
  final int activeStep;
  final bool isDelivered;
  final int etaMinutes;
  final VoidCallback onDone;

  const DeliveryStatusSheet({
    super.key,
    required this.food,
    required this.activeStep,
    required this.isDelivered,
    required this.etaMinutes,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final statusColor = isDelivered ? FoodColors.success : FoodColors.accent;

    return Container(
      decoration: const BoxDecoration(
        color: FoodColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(FoodRadius.lg)),
        border: Border(top: BorderSide(color: FoodColors.border)),
        boxShadow: [
          BoxShadow(
            color: FoodColors.shadow,
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        FoodSpacing.lg,
        FoodSpacing.md,
        FoodSpacing.lg,
        bottomPadding + FoodSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: FoodColors.border,
                borderRadius: BorderRadius.circular(FoodRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: FoodSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isDelivered ? 'Delivered' : 'Arriving in $etaMinutes min',
                      style: textTheme.headlineMedium?.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: FoodSpacing.xs),
                    Text(
                      '${food.name} · ${food.restaurant}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isDelivered)
                FilledButton(
                  onPressed: onDone,
                  style: FilledButton.styleFrom(
                    backgroundColor: FoodColors.success,
                    foregroundColor: FoodColors.inkOnSuccess,
                  ),
                  child: const Text('Done'),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FoodSpacing.md,
                    vertical: FoodSpacing.xs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: FoodColors.accentTint,
                    borderRadius: BorderRadius.circular(FoodRadius.pill),
                    border: Border.all(color: FoodColors.accentBorder),
                  ),
                  child: Text(
                    '$etaMinutes min',
                    style: FoodText.tabular.copyWith(
                      color: statusColor,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: FoodSpacing.lg),
          const Divider(),
          const SizedBox(height: FoodSpacing.md),
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=400&auto=format&fit=crop',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(
                    width: 40,
                    height: 40,
                    child: ColoredBox(
                      color: FoodColors.surfaceSubtle,
                      child: Icon(
                        Icons.person_rounded,
                        color: FoodColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: FoodSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hamza Khan',
                      style: textTheme.titleMedium?.copyWith(fontSize: 15),
                    ),
                    Text(
                      'Honda 125 · 4.9 rating',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Call rider',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling Hamza Khan...')),
                  );
                },
                icon: const Icon(Icons.call_rounded, size: 18),
              ),
            ],
          ),
          const SizedBox(height: FoodSpacing.lg),
          _ConnectedStepRow(activeStep: activeStep, isDelivered: isDelivered),
        ],
      ),
    );
  }
}

class _ConnectedStepRow extends StatelessWidget {
  final int activeStep;
  final bool isDelivered;

  const _ConnectedStepRow({
    required this.activeStep,
    required this.isDelivered,
  });

  static const _labels = ['Confirmed', 'Preparing', 'Picked up', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    final activeColor = isDelivered ? FoodColors.success : FoodColors.accent;
    final inkColor = isDelivered
        ? FoodColors.inkOnSuccess
        : FoodColors.inkOnAccent;

    return Row(
      children: List.generate(_labels.length, (index) {
        final reached = index < activeStep;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == 0
                          ? Colors.transparent
                          : (reached ? activeColor : FoodColors.border),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: reached ? activeColor : FoodColors.surfaceSubtle,
                      border: Border.all(
                        color: reached ? activeColor : FoodColors.border,
                      ),
                    ),
                    child: Icon(
                      reached ? Icons.check_rounded : Icons.circle,
                      size: reached ? 14 : 6,
                      color: reached ? inkColor : FoodColors.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == _labels.length - 1
                          ? Colors.transparent
                          : (index + 1 < activeStep
                                ? activeColor
                                : FoodColors.border),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FoodSpacing.xs),
              Text(
                _labels[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FoodText.caption.copyWith(
                  color: reached
                      ? FoodColors.textPrimary
                      : FoodColors.textSecondary,
                  fontWeight: reached ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

