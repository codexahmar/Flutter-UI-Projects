import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_marketplace/domain/models/product.dart';
import 'package:furniture_marketplace/presentation/controllers/catalog_controller.dart';
import 'package:furniture_marketplace/presentation/controllers/product_detail_controller.dart';

void main() {
  const sampleProducts = [
    Product(
      id: '1',
      name: 'Strandmon',
      subtitle: 'Tufted Velvet Wingback',
      price: 320,
      discount: '-5%',
      category: 'Lounge',
      assetPath: 'assets/images/chair1.png',
      isFavorite: true,
    ),
    Product(
      id: '2',
      name: 'Chesterfield',
      subtitle: 'Tufted Leather Club Chair',
      price: 490,
      discount: '-10%',
      category: 'Lounge',
      assetPath: 'assets/images/chair2.png',
      isFavorite: false,
    ),
  ];

  group('CatalogController Unit Tests', () {
    test('initializes with products and default category', () {
      final controller = CatalogController(initialProducts: sampleProducts);

      expect(controller.products.length, 2);
      expect(controller.selectedCategory, 'Lounge');
      expect(controller.displayedProducts.length, 2);
      expect(controller.favoritesCount, 1);
    });

    test('selectCategory updates selectedCategory and notifies listeners', () {
      final controller = CatalogController(initialProducts: sampleProducts);
      var notified = false;
      controller.addListener(() => notified = true);

      controller.selectCategory('Office');

      expect(controller.selectedCategory, 'Office');
      expect(notified, isTrue);
    });

    test('toggleFavorite toggles favorite state of targeted product', () {
      final controller = CatalogController(initialProducts: sampleProducts);

      expect(controller.products[1].isFavorite, isFalse);
      controller.toggleFavorite('2');
      expect(controller.products[1].isFavorite, isTrue);
      expect(controller.favoritesCount, 2);
    });

    test('displayedProducts filters to favorites when showFavoritesOnly is true', () {
      final controller = CatalogController(initialProducts: sampleProducts);

      controller.setNavIndex(1);
      expect(controller.showFavoritesOnly, isTrue);
      expect(controller.displayedProducts.length, 1);
      expect(controller.displayedProducts.first.id, '1');
    });
  });

  group('ProductDetailController Unit Tests', () {
    test('initializes with product data', () {
      final controller = ProductDetailController(initialProduct: sampleProducts[0]);

      expect(controller.product.id, '1');
      expect(controller.quantity, 1);
      expect(controller.isFavorite, isTrue);
      expect(controller.buyState, BuyState.buy);
      expect(controller.totalPrice, 320);
    });

    test('incrementQuantity increases quantity and calculates total price', () {
      final controller = ProductDetailController(initialProduct: sampleProducts[0]);

      controller.incrementQuantity();
      expect(controller.quantity, 2);
      expect(controller.totalPrice, 640);
    });

    test('decrementQuantity decreases quantity but does not go below 1', () {
      final controller = ProductDetailController(initialProduct: sampleProducts[0]);

      controller.incrementQuantity();
      expect(controller.quantity, 2);

      controller.decrementQuantity();
      expect(controller.quantity, 1);

      controller.decrementQuantity();
      expect(controller.quantity, 1);
    });

    test('toggleFavorite updates favorite state', () {
      final controller = ProductDetailController(initialProduct: sampleProducts[0]);

      expect(controller.isFavorite, isTrue);
      controller.toggleFavorite();
      expect(controller.isFavorite, isFalse);
    });

    test('updateProduct resets quantity and buyState for new product', () {
      final controller = ProductDetailController(initialProduct: sampleProducts[0]);

      controller.incrementQuantity();
      controller.updateProduct(sampleProducts[1]);

      expect(controller.product.id, '2');
      expect(controller.quantity, 1);
      expect(controller.isFavorite, isFalse);
      expect(controller.buyState, BuyState.buy);
    });
  });
}
