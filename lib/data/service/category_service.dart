import 'dart:convert';

import '../../core/end_points.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/page_result.dart';
import '../model/category_model.dart';
import 'network/network_caller.dart';

class CategoryService {
  final _networkCaller = NetworkCaller();

  /// One page of categories (the server sends 10 per page).
  Future<PageResult<Category>> getCategoryPage(int page) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.categoriesPage(page)),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage);
    }
    final data = jsonDecode(response.body!)['data'];

    return PageResult(
      items: (data['results'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      lastPage: (data['last_page'] as num?)?.toInt() ?? 1,
    );
  }
}
