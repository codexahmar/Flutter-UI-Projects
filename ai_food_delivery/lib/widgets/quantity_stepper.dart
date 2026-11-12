import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Compact quantity stepper with tabular numerals for dish counts.
class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FoodColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(FoodRadius.pill),
        border: Border.all(color: FoodColors.border),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: CupertinoIcons.minus,
            tooltip: 'Decrease quantity',
            onTap: onDecrement,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FoodSpacing.md),
            child: Text('$quantity', style: FoodText.tabular),
          ),
          _StepperButton(
            icon: CupertinoIcons.plus,
            tooltip: 'Increase quantity',
            isPrimary: true,
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isPrimary;
  final VoidCallback? onTap;

  const _StepperButton({
    required this.icon,
    required this.tooltip,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final bgColor = !enabled
        ? Colors.transparent
        : isPrimary
            ? FoodColors.textPrimary
            : FoodColors.surface;
    final fgColor = !enabled
        ? FoodColors.textSecondary.withValues(alpha: 0.4)
        : isPrimary
            ? FoodColors.inkOnDark
            : FoodColors.textPrimary;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FoodRadius.pill),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 15, color: fgColor),
        ),
      ),
    );
  }
}
