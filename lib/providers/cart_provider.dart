import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items {
    return _items.values.toList();
  }

  int get totalItems {
    int total = 0;

    for (final item in _items.values) {
      total += item.quantity;
    }

    return total;
  }

  double get totalPrice {
    double total = 0;

    for (final item in _items.values) {
      total += item.total;
    }

    return total;
  }

  int _getProductKey(Product product) {
    return product.id ?? product.title.hashCode;
  }

  void addToCart(Product product) {
    final key = _getProductKey(product);

    if (_items.containsKey(key)) {
      final oldItem = _items[key]!;

      _items[key] = oldItem.copyWith(quantity: oldItem.quantity + 1);
    } else {
      _items[key] = CartItem(product: product, quantity: 1);
    }

    notifyListeners();
  }

  void increase(Product product) {
    addToCart(product);
  }

  void decrease(Product product) {
    final key = _getProductKey(product);

    if (!_items.containsKey(key)) {
      return;
    }

    final oldItem = _items[key]!;

    if (oldItem.quantity <= 1) {
      _items.remove(key);
    } else {
      _items[key] = oldItem.copyWith(quantity: oldItem.quantity - 1);
    }

    notifyListeners();
  }

  void remove(Product product) {
    final key = _getProductKey(product);
    _items.remove(key);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
