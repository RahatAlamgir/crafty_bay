import 'package:crafty_bay/data/service/brand_service.dart';
import 'package:crafty_bay/domain/entities/brand.dart';
import 'package:crafty_bay/domain/entities/page_result.dart';
import 'package:crafty_bay/presentation/core/paged_provider.dart';

/// Brands, loaded page by page. Shared by the Home row and the Brands page.
class BrandProvider extends PagedProvider<Brand> {
  final _service = BrandService();

  List<Brand> get brands => items;

  Future<void> fetchBrands() => fetchFirstPage();

  @override
  Future<PageResult<Brand>> loadPage(int page) => _service.getBrandPage(page);
}
