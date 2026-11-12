import 'package:flutter/material.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Clean section heading with an optional interactive trailing action label.
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: FoodText.title.copyWith(fontSize: 18),
          ),
        ),
        if (trailingText != null && onTrailingTap != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FoodSpacing.md,
                vertical: FoodSpacing.xs + 2,
              ),
              decoration: BoxDecoration(
                color: FoodColors.accentTint,
                borderRadius: BorderRadius.circular(FoodRadius.pill),
              ),
              child: Text(
                trailingText!,
                style: FoodText.caption.copyWith(
                  color: FoodColors.accentInk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
