import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';
import 'package:ai_food_delivery/widgets/food_network_image.dart';

/// Editorial dish card with generous framing, right-aligned dish photo, and inline add toggle.
class FoodMenuCard extends StatelessWidget {
  final FoodItem food;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onOpenCheckout;

  const FoodMenuCard({
    super.key,
    required this.food,
    required this.isSelected,
    required this.onSelect,
    required this.onOpenCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenCheckout,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: FoodColors.surface,
          borderRadius: BorderRadius.circular(FoodRadius.lg),
          border: Border.all(
            color: isSelected ? FoodColors.accent : FoodColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: FoodColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(FoodSpacing.md + 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (food.promoLabel.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: FoodSpacing.sm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: FoodColors.accentTint,
                            borderRadius: BorderRadius.circular(FoodRadius.pill),
                          ),
                          child: Text(
                            food.promoLabel,
                            style: FoodText.caption.copyWith(
                              color: FoodColors.accentInk,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: FoodSpacing.sm),
                      ],
                      const Icon(
                        CupertinoIcons.star_fill,
                        size: 11,
                        color: FoodColors.accent,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        food.rating.toStringAsFixed(1),
                        style: FoodText.tabular.copyWith(
                          fontSize: 12,
                          color: FoodColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FoodSpacing.sm),
                  Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FoodText.title.copyWith(fontSize: 16.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${food.restaurant} · ${food.eta}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FoodText.caption,
                  ),
                  const SizedBox(height: FoodSpacing.xs + 2),
                  Text(
                    food.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FoodText.caption.copyWith(height: 1.38),
                  ),
                  const SizedBox(height: FoodSpacing.md),
                  Row(
                    children: [
                      Text(
                        food.price,
                        style: FoodText.tabular.copyWith(fontSize: 15.5),
                      ),
                      const SizedBox(width: FoodSpacing.md),
                      InkWell(
                        onTap: onSelect,
                        borderRadius: BorderRadius.circular(FoodRadius.pill),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(
                            horizontal: FoodSpacing.md,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? FoodColors.textPrimary
                                : FoodColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(FoodRadius.pill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected
                                    ? CupertinoIcons.checkmark_alt
                                    : CupertinoIcons.plus,
                                size: 12,
                                color: isSelected
                                    ? FoodColors.inkOnDark
                                    : FoodColors.textPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isSelected ? 'Selected' : 'Select',
                                style: FoodText.caption.copyWith(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? FoodColors.inkOnDark
                                      : FoodColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: FoodSpacing.md),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(FoodRadius.md),
                border: Border.all(color: FoodColors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(FoodRadius.md - 2),
                child: FoodNetworkImage(
                  imageUrl: food.imageUrl,
                  width: 108,
                  height: 108,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
