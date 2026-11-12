import 'package:flutter/material.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Compact quantity stepper with accessible touch targets.
class QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FoodColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(FoodRadius.pill),
        border: Border.all(color: FoodColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepIconButton(
            icon: Icons.remove_rounded,
            tooltip: 'Decrease quantity',
            onTap: value > 1 ? onRemove : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FoodSpacing.sm),
            child: Text(value.toString(), style: FoodText.tabular),
          ),
          _StepIconButton(
            icon: Icons.add_rounded,
            tooltip: 'Increase quantity',
            onTap: onAdd,
          ),
        ],
      ),
    );
  }
}

class _StepIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  const _StepIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: onTap == null
            ? FoodColors.textSecondary
            : FoodColors.textPrimary,
        minimumSize: const Size.square(44),
        side: BorderSide.none,
      ),
      icon: Icon(icon, size: 18),
    );
  }
}

