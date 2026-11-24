import 'dart:convert';

import '../../core/end_points.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_details.dart';
import '../../domain/entities/page_result.dart';
import '../model/product_details_model.dart';
import '../model/product_model.dart';
import 'network/network_caller.dart';

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

  /// The whole catalogue, all pages at once.
  ///
  /// Only Search uses this, because the server has no text search and the
  /// app has to filter on the phone. Product lists load page by page with
  /// [getProductPage] instead.
  Future<List<Product>> getAllProducts() async {
    final first = await getProductPage(1);
    final rest = await Future.wait([
      for (var n = 2; n <= first.lastPage; n++) getProductPage(n),
    ]);

    return [first, ...rest].expand((p) => p.items).toList();
  }

  /// One page (10 products). Pass [categoryId] and/or [brandId] to get only
  /// the products of that category or brand (the server filters them).
  Future<PageResult<Product>> getProductPage(
    int page, {
    String? categoryId,
    String? brandId,
  }) async {
    final response = await _networkCaller.get(
      Uri.parse(
        EndPoints.productsPage(page, categoryId: categoryId, brandId: brandId),
      ),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage);
    }
    final data = jsonDecode(response.body!)['data'];

    return PageResult(
      items: (data['results'] as List)
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
