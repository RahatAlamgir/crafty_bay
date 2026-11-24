import 'package:crafty_bay/data/service/product_service.dart';
import 'package:crafty_bay/domain/entities/page_result.dart';
import 'package:crafty_bay/domain/entities/product.dart';
import 'package:crafty_bay/presentation/core/paged_provider.dart';

/// Products of one category or brand (or all products), loaded page by page.
/// Created by the product list page, so every opening starts fresh.
class ProductListProvider extends PagedProvider<Product> {
  ProductListProvider({this.categoryId, this.brandId});

  final String? categoryId;
  final String? brandId;
  final _service = ProductService();

  List<Product> get products => items;

  Future<void> fetchProducts() => fetchFirstPage();

  @override
  Future<PageResult<Product>> loadPage(int page) => _service.getProductPage(
    page,
    categoryId: categoryId,
    brandId: brandId,
  );
}
