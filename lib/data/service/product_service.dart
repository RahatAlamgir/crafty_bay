import 'dart:convert';

import '../../core/end_points.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_details.dart';
import '../model/product_details_model.dart';
import '../model/product_model.dart';
import 'network/network_caller.dart';

/// One page of the products list, plus how many pages exist.
class _ProductPage {
  final List<Product> products;
  final int lastPage;

  _ProductPage({required this.products, required this.lastPage});
}

class ProductService {
  final _networkCaller = NetworkCaller();

  Future<List<Product>> getProducts() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.products),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage);
    }
    final json = jsonDecode(response.body!);
    return (json['data']['results'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  /// Every product, all pages. The server has no text search, so the app
  /// loads the whole catalogue once and filters it on the phone.
  Future<List<Product>> getAllProducts() async {
    final first = await _getPage(1);
    final pages = await Future.wait([
      for (var page = 2; page <= first.lastPage; page++) _getPage(page),
    ]);

    return [first, ...pages].expand((p) => p.products).toList();
  }

  Future<_ProductPage> _getPage(int page) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.productsPage(page)),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage);
    }
    final data = jsonDecode(response.body!)['data'];

    return _ProductPage(
      products: (data['results'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
      lastPage: (data['last_page'] as num?)?.toInt() ?? 1,
    );
  }

  Future<ProductDetails> getProductDetails(String id) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.productById(id)),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage);
    }
    final json = jsonDecode(response.body!);
    return ProductDetailsModel.fromJson(json['data']);
  }
}
