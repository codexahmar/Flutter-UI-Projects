import 'package:flutter/material.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Quiet section header with optional tabular count or action link.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailingText;
  final VoidCallback? onTrailingTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailingText,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(child: Text(title, style: textTheme.titleMedium)),
        if (trailingText != null)
          onTrailingTap != null
              ? TextButton(
                  onPressed: onTrailingTap,
                  style: TextButton.styleFrom(
                    foregroundColor: FoodColors.textSecondary,
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(
                      horizontal: FoodSpacing.sm,
                    ),
                  ),
                  child: Text(
                    trailingText!,
                    style: textTheme.bodySmall?.copyWith(
                      color: FoodColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Text(
                  trailingText!,
                  style: FoodText.tabular.copyWith(
                    color: FoodColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
      ],
    );
  }
}

