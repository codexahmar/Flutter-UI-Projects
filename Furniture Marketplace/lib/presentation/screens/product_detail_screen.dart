import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/repositories/mock_product_repository.dart';
import '../../domain/models/product.dart';
import '../controllers/product_detail_controller.dart';
import '../widgets/product_detail_sheet.dart';
import '../widgets/product_detail_top_bar.dart';
import '../widgets/product_showcase.dart';
import 'hero_promo_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Product? heroProduct;
  final VoidCallback onBack;
  final ProductDetailController? controller;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.heroProduct,
    required this.onBack,
    this.controller,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailController controller;
  bool isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      controller = widget.controller!;
    } else {
      controller = ProductDetailController(initialProduct: widget.product);
      isInternalController = true;
    }
  }

  @override
  void didUpdateWidget(covariant ProductDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      controller.updateProduct(widget.product);
    }
  }

  @override
  void dispose() {
    if (isInternalController) {
      controller.dispose();
    }
    super.dispose();
  }

  void openHeroPromo() {
    final hero = widget.heroProduct ?? MockProductRepository().getHeroProduct();
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => HeroPromoScreen(
          heroProduct: hero,
          onBack: () => Navigator.of(context).pop(),
          onShopMore: () {
            Navigator.of(context).pop();
            widget.onBack();
          },
          onSelectHeroProduct: () {
            controller.updateProduct(hero);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final product = controller.product;

            return Column(
              children: [
                ProductDetailTopBar(
                  isFavorite: controller.isFavorite,
                  onBack: widget.onBack,
                  onInfoTap: openHeroPromo,
                  onFavoriteTap: controller.toggleFavorite,
                ),
                const SizedBox(height: 6),
                ProductShowcase(
                  product: product,
                  onOpenHeroPromo: openHeroPromo,
                ),
                ProductDetailSheet(
                  product: product,
                  quantity: controller.quantity,
                  totalPrice: controller.totalPrice,
                  buyState: controller.buyState,
                  onIncrementQuantity: controller.incrementQuantity,
                  onDecrementQuantity: controller.decrementQuantity,
                  onBuyPressed: () {
                    controller.handleBuyAction(
                      context: context,
                      onContinueShopping: widget.onBack,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
