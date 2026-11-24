import 'dart:convert';

import '../../core/end_points.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/page_result.dart';
import '../model/brand_model.dart';
import 'network/network_caller.dart';

class BrandService {
  final _networkCaller = NetworkCaller();

  /// One page of brands (the server sends 10 per page).
  Future<PageResult<Brand>> getBrandPage(int page) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.brandsPage(page)),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) {
      throw Exception(response.errorMessage);
    }
    final data = jsonDecode(response.body!)['data'];

    return PageResult(
      items: (data['results'] as List)
          .map((e) => BrandModel.fromJson(e))
          .toList(),
      lastPage: (data['last_page'] as num?)?.toInt() ?? 1,
    );
  }
}
