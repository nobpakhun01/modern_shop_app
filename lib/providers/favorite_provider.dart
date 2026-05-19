import 'package:flutter/material.dart';

import '../models/product.dart';

class FavoriteProvider extends ChangeNotifier {
  final Map<int, Product> _items = {};

  List<Product> get items {
    return _items.values.toList();
  }

  int get totalFavorites {
    return _items.length;
  }

  int _getProductKey(Product product) {
    return product.id ?? product.title.hashCode;
  }

  bool isFavorite(Product product) {
    final key = _getProductKey(product);
    return _items.containsKey(key);
  }

  void toggleFavorite(Product product) {
    final key = _getProductKey(product);

    if (_items.containsKey(key)) {
      _items.remove(key);
    } else {
      _items[key] = product;
    }

    notifyListeners();
  }

  void removeFavorite(Product product) {
    final key = _getProductKey(product);
    _items.remove(key);
    notifyListeners();
  }

  void clearFavorites() {
    _items.clear();
    notifyListeners();
  }
}
