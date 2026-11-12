import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../domain/models/product.dart';
import '../controllers/product_detail_controller.dart';
import 'buy_action_button.dart';
import 'product_quantity_selector.dart';

class ProductDetailSheet extends StatelessWidget {
  final Product product;
  final int quantity;
  final int totalPrice;
  final BuyState buyState;
  final VoidCallback onIncrementQuantity;
  final VoidCallback onDecrementQuantity;
  final VoidCallback onBuyPressed;

  const ProductDetailSheet({
    super.key,
    required this.product,
    required this.quantity,
    required this.totalPrice,
    required this.buyState,
    required this.onIncrementQuantity,
    required this.onDecrementQuantity,
    required this.onBuyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -24,
            right: 28,
            child: GestureDetector(
              onTap: onBuyPressed,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.pureBlack,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.bag_fill,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  style: AppTypography.detailTitle(),
                ),
                const SizedBox(height: 8),
                Text(
                  product.subtitle,
                  style: AppTypography.bodyMuted(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '\$${product.price}',
                          style: AppTypography.priceBold(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.discountDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.discount,
                            style: AppTypography.discountBadge(),
                          ),
                        ),
                      ],
                    ),
                    ProductQuantitySelector(
                      quantity: quantity,
                      onIncrement: onIncrementQuantity,
                      onDecrement: onDecrementQuantity,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                BuyActionButton(
                  buyState: buyState,
                  totalPrice: totalPrice,
                  onPressed: onBuyPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
