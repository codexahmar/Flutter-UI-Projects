import 'package:flutter/material.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';
import 'package:ai_food_delivery/widgets/food_network_image.dart';

/// Selectable menu dish row with fixed thumbnail crop and clear price hierarchy.
class FoodMenuCard extends StatelessWidget {
  final FoodItem food;
  final bool selected;
  final VoidCallback onTap;

  const FoodMenuCard({
    super.key,
    required this.food,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: selected ? FoodColors.accentTint : FoodColors.surface,
      borderRadius: BorderRadius.circular(FoodRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FoodRadius.lg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(FoodSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FoodRadius.lg),
            border: Border.all(
              color: selected ? FoodColors.accent : FoodColors.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child: FoodNetworkImage(
                  imageUrl: food.imageUrl,
                  heroTag: 'dish_${food.name}',
                  borderRadius: BorderRadius.circular(FoodRadius.md),
                ),
              ),
              const SizedBox(width: FoodSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            food.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: FoodSpacing.sm),
                        Text(
                          food.price,
                          style: FoodText.tabular.copyWith(
                            color: selected
                                ? FoodColors.accent
                                : FoodColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: FoodSpacing.xs),
                    Text(
                      '${food.restaurant} · ${food.promoLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: FoodColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: FoodSpacing.xs),
                    Text(
                      food.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: FoodSpacing.sm),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: FoodColors.accent,
                          size: 14,
                        ),
                        const SizedBox(width: FoodSpacing.xs),
                        Text(
                          '${food.rating.toStringAsFixed(1)} · ${food.eta} · ${food.distance}',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

