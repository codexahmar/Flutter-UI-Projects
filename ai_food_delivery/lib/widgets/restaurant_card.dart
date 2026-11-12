import 'package:flutter/cupertino.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';
import 'package:ai_food_delivery/widgets/food_network_image.dart';

/// Editorial full-bleed partner restaurant card with dark bottom photo legibility scrim.
class RestaurantCard extends StatelessWidget {
  final RestaurantSpot spot;
  final bool isSelected;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.spot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: FoodColors.surface,
          borderRadius: BorderRadius.circular(FoodRadius.lg),
          border: Border.all(
            color: isSelected ? FoodColors.accent : FoodColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1C171310),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FoodNetworkImage(imageUrl: spot.imageUrl),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.35, 0.7, 1.0],
                  colors: [
                    Color(0x00171310),
                    Color(0x70171310),
                    Color(0xEB171310),
                  ],
                ),
              ),
            ),
            Positioned(
              top: FoodSpacing.md,
              left: FoodSpacing.md,
              right: FoodSpacing.md,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FoodSpacing.sm + 2,
                      vertical: FoodSpacing.xs + 1,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? FoodColors.accent
                          : FoodColors.surface.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(FoodRadius.pill),
                    ),
                    child: Text(
                      isSelected ? 'Filtering menu' : spot.distance,
                      style: FoodText.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? FoodColors.inkOnAccent
                            : FoodColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FoodSpacing.sm + 2,
                      vertical: FoodSpacing.xs + 1,
                    ),
                    decoration: BoxDecoration(
                      color: FoodColors.surface.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(FoodRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.star_fill,
                          size: 11,
                          color: FoodColors.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          spot.rating.toStringAsFixed(1),
                          style: FoodText.tabular.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: FoodSpacing.lg,
              right: FoodSpacing.lg,
              bottom: FoodSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    spot.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FoodText.title.copyWith(
                      color: FoodColors.inkOnDark,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${spot.cuisine} · ${spot.eta}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FoodText.caption.copyWith(
                      color: FoodColors.inkOnDark.withValues(alpha: 0.82),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
