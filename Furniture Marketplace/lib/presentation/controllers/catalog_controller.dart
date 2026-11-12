import 'package:flutter/foundation.dart';
import '../../domain/models/product.dart';

class CatalogController extends ChangeNotifier {
  CatalogController({
    required List<Product> initialProducts,
    String defaultCategory = 'Lounge',
  })  : products = List<Product>.from(initialProducts),
        selectedCategory = defaultCategory;

  final List<Product> products;
  final List<String> categories = const [
    'Lounge',
    'Office',
    'Dining',
    'Rocking',
  ];

  String selectedCategory;
  int navIndex = 0;
  bool showFavoritesOnly = false;

  List<Product> get displayedProducts {
    if (showFavoritesOnly) {
      return products.where((product) => product.isFavorite).toList();
    }
    return products;
  }

  int get favoritesCount {
    return products.where((product) => product.isFavorite).length;
  }

  void selectCategory(String category) {
    if (selectedCategory != category) {
      selectedCategory = category;
      notifyListeners();
    }
  }

  void toggleFavorite(String productId) {
    final index = products.indexWhere((product) => product.id == productId);
    if (index != -1) {
      products[index] = products[index].copyWith(
        isFavorite: !products[index].isFavorite,
      );
      notifyListeners();
    }
  }

  void setNavIndex(int index) {
    navIndex = index;
    if (index == 0) {
      showFavoritesOnly = false;
    } else if (index == 1) {
      showFavoritesOnly = !showFavoritesOnly;
    }
    notifyListeners();
  }
}
