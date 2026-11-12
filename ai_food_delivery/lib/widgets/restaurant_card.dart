import 'package:flutter/material.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';
import 'package:ai_food_delivery/widgets/food_network_image.dart';

/// Horizontal card representing a featured restaurant.
class RestaurantCard extends StatelessWidget {
  final RestaurantSpot restaurant;
  final bool selected;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
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
        child: Container(
          width: 184,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FoodRadius.lg),
            border: Border.all(
              color: selected ? FoodColors.accent : FoodColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 96,
                width: double.infinity,
                child: FoodNetworkImage(
                  imageUrl: restaurant.imageUrl,
                  heroTag: 'restaurant_${restaurant.name}',
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(FoodRadius.lg - 1),
                  ),
                  showBottomScrim: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(FoodSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: FoodSpacing.xs),
                    Text(
                      restaurant.cuisine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: FoodSpacing.sm),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: FoodColors.accent,
                          size: 15,
                        ),
                        const SizedBox(width: FoodSpacing.xs),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: FoodText.tabular.copyWith(fontSize: 12),
                        ),
                        Text(
                          ' · ${restaurant.eta}',
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

