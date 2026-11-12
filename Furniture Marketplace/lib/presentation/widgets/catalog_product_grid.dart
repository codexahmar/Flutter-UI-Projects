import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/models/product.dart';
import 'product_grid_card.dart';

class CatalogProductGrid extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product> onProductTap;
  final ValueChanged<Product> onFavoriteToggle;

  const CatalogProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'No favorites yet',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.mutedGray,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductGridCard(
          product: product,
          onTap: () => onProductTap(product),
          onFavoriteToggle: () => onFavoriteToggle(product),
        );
      },
    );
  }
}
