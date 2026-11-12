import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Live courier status bottom sheet harmonized strictly to the 3-color app palette.
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

  String get _headline {
    if (isDelivered) return 'Order delivered';
    return switch (activeStep) {
      <= 1 => 'Order confirmed',
      2 => 'Kitchen preparing your order',
      _ => 'Hamza is on the way',
    };
  }

  String get _subtitle {
    if (isDelivered) return 'Left at House 12 · Street 8, F-10/3';
    return switch (activeStep) {
      <= 1 => 'Sent directly to ${food.restaurant}',
      2 => 'Packing ${food.name} fresh for pickup',
      _ => 'Heading east along Margalla Rd to House 12',
    };
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

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
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: FoodColors.border,
                borderRadius: BorderRadius.circular(FoodRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: FoodSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _headline,
                      style: FoodText.headline.copyWith(fontSize: 21),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FoodText.caption.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: FoodSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FoodSpacing.md,
                  vertical: FoodSpacing.xs + 2,
                ),
                decoration: BoxDecoration(
                  color: isDelivered
                      ? FoodColors.textPrimary
                      : FoodColors.accentTint,
                  borderRadius: BorderRadius.circular(FoodRadius.pill),
                ),
                child: Text(
                  isDelivered ? 'Delivered' : '$etaMinutes min',
                  style: FoodText.tabular.copyWith(
                    color: isDelivered
                        ? FoodColors.inkOnDark
                        : FoodColors.accentInk,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: FoodSpacing.lg),
          _ConnectedStepRow(activeStep: activeStep, isDelivered: isDelivered),
          const SizedBox(height: FoodSpacing.lg),
          Container(
            padding: const EdgeInsets.all(FoodSpacing.md),
            decoration: BoxDecoration(
              color: FoodColors.canvas,
              borderRadius: BorderRadius.circular(FoodRadius.md),
              border: Border.all(color: FoodColors.border),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=400&auto=format&fit=crop',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox(
                      width: 44,
                      height: 44,
                      child: ColoredBox(
                        color: FoodColors.surfaceSubtle,
                        child: Center(
                          child: Icon(
                            CupertinoIcons.person_fill,
                            size: 18,
                            color: FoodColors.textSecondary,
                          ),
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
                      Row(
                        children: [
                          Text(
                            'Hamza Khan',
                            style: FoodText.title.copyWith(fontSize: 15),
                          ),
                          const SizedBox(width: FoodSpacing.xs),
                          const Icon(
                            CupertinoIcons.checkmark_seal_fill,
                            size: 14,
                            color: FoodColors.accent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Honda 125 · RIL-4821 · 4.9 ★',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FoodText.caption,
                      ),
                    ],
                  ),
                ),
                _CourierActionButton(
                  icon: CupertinoIcons.chat_bubble_fill,
                  tooltip: 'Message courier',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening chat with Hamza Khan...'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: FoodSpacing.sm),
                _CourierActionButton(
                  icon: CupertinoIcons.phone_fill,
                  tooltip: 'Call courier',
                  isPrimary: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling Hamza Khan...')),
                    );
                  },
                ),
              ],
            ),
          ),
          if (isDelivered) ...[
            const SizedBox(height: FoodSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onDone,
                style: FilledButton.styleFrom(
                  backgroundColor: FoodColors.textPrimary,
                  foregroundColor: FoodColors.inkOnDark,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(FoodRadius.pill),
                  ),
                ),
                child: Text('Back to menu', style: FoodText.button),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CourierActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isPrimary;
  final VoidCallback onTap;

  const _CourierActionButton({
    required this.icon,
    required this.tooltip,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isPrimary ? FoodColors.accent : FoodColors.surface,
        shape: CircleBorder(
          side: BorderSide(
            color: isPrimary ? FoodColors.accent : FoodColors.border,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 38,
            height: 38,
            child: Icon(
              icon,
              size: 16,
              color: isPrimary ? FoodColors.inkOnAccent : FoodColors.textPrimary,
            ),
          ),
        ),
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
    final activeColor = isDelivered ? FoodColors.textPrimary : FoodColors.accent;

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
                      height: 2.5,
                      color: index == 0
                          ? Colors.transparent
                          : (reached ? activeColor : FoodColors.border),
                    ),
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: reached ? activeColor : FoodColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: reached ? activeColor : FoodColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: reached
                        ? const Icon(
                            CupertinoIcons.checkmark_alt,
                            size: 12,
                            color: FoodColors.inkOnAccent,
                          )
                        : null,
                  ),
                  Expanded(
                    child: Container(
                      height: 2.5,
                      color: index == _labels.length - 1
                          ? Colors.transparent
                          : (index + 1 < activeStep
                              ? activeColor
                              : FoodColors.border),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FoodSpacing.xs + 2),
              Text(
                _labels[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FoodText.caption.copyWith(
                  fontSize: 11,
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
