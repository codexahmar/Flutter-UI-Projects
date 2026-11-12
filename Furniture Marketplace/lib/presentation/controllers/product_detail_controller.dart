import 'dart:async';
import 'package:flutter/widgets.dart';
import '../../domain/models/product.dart';
import '../widgets/in_app_notification.dart';

enum BuyState { buy, purchased, continueShopping }

class ProductDetailController extends ChangeNotifier {
  ProductDetailController({required Product initialProduct})
      : product = initialProduct,
        isFavorite = initialProduct.isFavorite;

  Product product;
  int quantity = 1;
  bool isFavorite;
  BuyState buyState = BuyState.buy;
  Timer? transitionTimer;

  int get totalPrice => product.price * quantity;

  void updateProduct(Product newProduct) {
    if (product.id != newProduct.id) {
      product = newProduct;
      isFavorite = newProduct.isFavorite;
      quantity = 1;
      buyState = BuyState.buy;
      transitionTimer?.cancel();
      notifyListeners();
    }
  }

  void incrementQuantity() {
    quantity++;
    buyState = BuyState.buy;
    notifyListeners();
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
      buyState = BuyState.buy;
      notifyListeners();
    }
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void handleBuyAction({
    required BuildContext context,
    required VoidCallback onContinueShopping,
  }) {
    if (buyState == BuyState.continueShopping) {
      InAppNotification.dismiss();
      onContinueShopping();
      return;
    }

    if (buyState != BuyState.buy) return;

    buyState = BuyState.purchased;
    notifyListeners();

    InAppNotification.show(
      context,
      title: 'Purchase Confirmed',
      message: '$quantity x ${product.name} • \$$totalPrice',
      duration: const Duration(milliseconds: 2200),
    );

    transitionTimer?.cancel();
    transitionTimer = Timer(const Duration(milliseconds: 2200), () {
      buyState = BuyState.continueShopping;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    transitionTimer?.cancel();
    InAppNotification.dismiss();
    super.dispose();
  }
}
