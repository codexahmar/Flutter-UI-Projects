import 'package:flutter/material.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';

/// Docked checkout bar shown when a dish is selected from discovery.
class StickyOrderBar extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onContinue;

  const StickyOrderBar({
    super.key,
    required this.food,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        FoodSpacing.md,
        FoodSpacing.sm,
        FoodSpacing.sm,
        FoodSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: FoodColors.surface,
        borderRadius: BorderRadius.circular(FoodRadius.pill),
        border: Border.all(color: FoodColors.border),
        boxShadow: const [
          BoxShadow(
            color: FoodColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              food.imageUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox(
                width: 44,
                height: 44,
                child: ColoredBox(
                  color: FoodColors.surfaceSubtle,
                  child: Icon(
                    Icons.restaurant_rounded,
                    color: FoodColors.textSecondary,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: FoodSpacing.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${food.price} · ${food.eta}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: FoodSpacing.sm),
          FilledButton(
            onPressed: onContinue,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Order'),
                SizedBox(width: FoodSpacing.xs),
                Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

