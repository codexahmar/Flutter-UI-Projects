import 'package:flutter/cupertino.dart';
import '../../data/repositories/mock_product_repository.dart';
import '../../domain/models/product.dart';
import 'catalog_screen.dart';
import 'hero_promo_screen.dart';
import 'product_detail_screen.dart';

class MainNavigationShell extends StatelessWidget {
  final ProductRepository repository;

  const MainNavigationShell({
    super.key,
    required this.repository,
  });

  void openProductDetail(BuildContext context, Product product) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) {
          return ProductDetailScreen(
            product: product,
            heroProduct: repository.getHeroProduct(),
            onBack: () => Navigator.of(context).pop(),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            ),
            child: child,
          );
        },
      ),
    );
  }

  void openHeroPromo(BuildContext context) {
    final heroProduct = repository.getHeroProduct();
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => HeroPromoScreen(
          heroProduct: heroProduct,
          onBack: () => Navigator.of(context).pop(),
          onShopMore: () => Navigator.of(context).pop(),
          onSelectHeroProduct: () {
            openProductDetail(context, heroProduct);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogProducts = repository.getCatalogProducts();

    return CatalogScreen(
      products: catalogProducts,
      onProductSelected: (product) => openProductDetail(context, product),
      onOpenHeroPromo: () => openHeroPromo(context),
    );
  }
}
