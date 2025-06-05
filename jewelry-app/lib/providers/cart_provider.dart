import 'package:flutter/material.dart';
import 'package:jewelry_app/models/jewelry_model.dart';

class CartProvider extends ChangeNotifier {
  final List<JewelryModel> _items = [];

  List<JewelryModel> get items => _items;

  void addToCart(JewelryModel item) {
    _items.add(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

double get totalPrice {
  return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
}

  bool isInCart(JewelryModel item) {
    return _items.contains(item);
  }
void increaseQuantity(JewelryModel item) {
  item.quantity++;
  notifyListeners();
}

void decreaseQuantity(JewelryModel item) {
  if (item.quantity > 1) {
    item.quantity--;
    notifyListeners();
  }
}
}
