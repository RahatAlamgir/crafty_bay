import 'package:crafty_bay/data/service/product_service.dart';
import 'package:crafty_bay/domain/entities/product.dart';
import 'package:flutter/foundation.dart';

class ProductProvider extends ChangeNotifier {
  final _service = ProductService();

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Product> _catalog = [];

  /// Every product, not just the first page. Home rows that pick products by
  /// a rule (Popular) choose from this list.
  List<Product> get catalog => _catalog;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _service.getProducts();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads the whole catalogue (a single request for a small shop). A
  /// failure just leaves the rows that depend on it hidden.
  Future<void> fetchCatalog() async {
    try {
      _catalog = await _service.getAllProducts();
      notifyListeners();
    } catch (_) {}
  }
}
