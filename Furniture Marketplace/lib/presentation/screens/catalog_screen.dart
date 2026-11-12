import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/models/product.dart';
import '../controllers/catalog_controller.dart';
import '../widgets/catalog_header.dart';
import '../widgets/catalog_product_grid.dart';
import '../widgets/catalog_search_bar.dart';
import '../widgets/category_filter_list.dart';
import '../widgets/floating_bottom_nav.dart';

class CatalogScreen extends StatefulWidget {
  final List<Product> products;
  final ValueChanged<Product> onProductSelected;
  final VoidCallback onOpenHeroPromo;
  final CatalogController? controller;

  const CatalogScreen({
    super.key,
    required this.products,
    required this.onProductSelected,
    required this.onOpenHeroPromo,
    this.controller,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late final CatalogController controller;
  bool isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      controller = widget.controller!;
    } else {
      controller = CatalogController(initialProducts: widget.products);
      isInternalController = true;
    }
  }

  @override
  void dispose() {
    if (isInternalController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: topPadding + 10,
                    left: 20,
                    right: 20,
                    bottom: 120,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CatalogHeader(
                        onNotificationTap: widget.onOpenHeroPromo,
                      ),
                      const SizedBox(height: 20),
                      const CatalogSearchBar(),
                      const SizedBox(height: 20),
                      CategoryFilterList(
                        categories: controller.categories,
                        selectedCategory: controller.selectedCategory,
                        onCategorySelected: controller.selectCategory,
                      ),
                      const SizedBox(height: 24),
                      CatalogProductGrid(
                        products: controller.displayedProducts,
                        onProductTap: widget.onProductSelected,
                        onFavoriteToggle: (product) {
                          controller.toggleFavorite(product.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Center(
                  child: SizedBox(
                    width: 276,
                    child: FloatingBottomNav(
                      selectedIndex: controller.navIndex,
                      favoritesCount: controller.favoritesCount,
                      onIndexChanged: (index) {
                        controller.setNavIndex(index);
                        if (index == 2) {
                          widget.onOpenHeroPromo();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
