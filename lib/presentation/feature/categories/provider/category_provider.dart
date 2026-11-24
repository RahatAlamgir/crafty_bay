import 'package:crafty_bay/data/service/category_service.dart';
import 'package:crafty_bay/domain/entities/category.dart';
import 'package:crafty_bay/domain/entities/page_result.dart';
import 'package:crafty_bay/presentation/core/paged_provider.dart';

/// Categories, loaded page by page. Shared by the Home row (which shows what
/// is loaded so far) and the Categories page (which loads more as you scroll).
class CategoryProvider extends PagedProvider<Category> {
  final _service = CategoryService();

  List<Category> get categories => items;

  Future<void> fetchCategories() => fetchFirstPage();

  @override
  Future<PageResult<Category>> loadPage(int page) =>
      _service.getCategoryPage(page);
}
