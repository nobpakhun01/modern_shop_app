import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products {
    return _products;
  }

  bool get isLoading {
    return _isLoading;
  }

  String? get errorMessage {
    return _errorMessage;
  }

  List<Product> get popularProducts {
    final sortedProducts = [..._products];

    sortedProducts.sort((a, b) {
      return b.rating.compareTo(a.rating);
    });

    return sortedProducts.take(6).toList();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
    } catch (e) {
      _errorMessage = 'ไม่สามารถโหลดข้อมูลสินค้าได้';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final createdProduct = await _apiService.createProduct(product);
      _products.insert(0, createdProduct);
    } catch (e) {
      _errorMessage = 'เพิ่มสินค้าไม่สำเร็จ';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedProduct = await _apiService.updateProduct(product);
      final index = _products.indexWhere((item) {
        return item.id == product.id;
      });

      if (index != -1) {
        _products[index] = updatedProduct;
      }
    } catch (e) {
      _errorMessage = 'แก้ไขสินค้าไม่สำเร็จ';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteProduct(id);
      _products.removeWhere((product) {
        return product.id == id;
      });
    } catch (e) {
      _errorMessage = 'ลบสินค้าไม่สำเร็จ';
    }

    _isLoading = false;
    notifyListeners();
  }
}
