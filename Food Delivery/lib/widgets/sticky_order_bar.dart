import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';
import 'package:ai_food_delivery/widgets/food_network_image.dart';

/// Floating espresso-dark dock displaying the active dish photo and checkout pill CTA.
class StickyOrderBar extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onCheckout;

  const StickyOrderBar({
    super.key,
    required this.food,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        FoodSpacing.lg,
        0,
        FoodSpacing.lg,
        bottomPadding + FoodSpacing.md,
      ),
      child: Material(
        color: FoodColors.textPrimary,
        borderRadius: BorderRadius.circular(FoodRadius.pill),
        elevation: 10,
        shadowColor: const Color(0x42171310),
        child: InkWell(
          onTap: onCheckout,
          borderRadius: BorderRadius.circular(FoodRadius.pill),
          child: Padding(
            padding: const EdgeInsets.all(FoodSpacing.sm),
            child: Row(
              children: [
                ClipOval(
                  child: FoodNetworkImage(
                    imageUrl: food.imageUrl,
                    width: 42,
                    height: 42,
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
                        style: FoodText.title.copyWith(
                          color: FoodColors.inkOnDark,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${food.restaurant} · ${food.eta}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FoodText.caption.copyWith(
                          color: FoodColors.inkOnDark.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: FoodSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FoodSpacing.md + 4,
                    vertical: FoodSpacing.sm + 3,
                  ),
                  decoration: BoxDecoration(
                    color: FoodColors.accent,
                    borderRadius: BorderRadius.circular(FoodRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        food.price,
                        style: FoodText.tabular.copyWith(
                          color: FoodColors.inkOnAccent,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: FoodSpacing.xs + 2),
                      const Icon(
                        CupertinoIcons.arrow_right,
                        size: 14,
                        color: FoodColors.inkOnAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
