import 'dart:convert';

import '../../core/end_points.dart';
import '../../domain/entities/page_result.dart';
import '../../domain/entities/wishlist_item.dart';
import '../model/wishlist_item_model.dart';
import 'network/auth_headers.dart';
import 'network/network_caller.dart';

class WishlistService {
  final _networkCaller = NetworkCaller();

  /// Every wished item, all pages. Each heart button needs to know whether
  /// its product is wished, so this loads all pages instead of the first.
  Future<List<WishlistItem>> getWishlist() async {
    final first = await _getPage(1);
    final rest = await Future.wait([
      for (var page = 2; page <= first.lastPage; page++) _getPage(page),
    ]);

    return [first, ...rest].expand((p) => p.items).toList();
  }

  Future<PageResult<WishlistItem>> _getPage(int page) async {
    final response = await _networkCaller.get(
      Uri.parse(page == 1 ? EndPoints.wishlist : EndPoints.wishlistPage(page)),
      headers: AuthHeaders.build(),
    );
    _throwIfFailed(response.isSuccess, response.errorMessage);
    final data = jsonDecode(response.body!)['data'];
    final list = switch (data) {
      List() => data,
      Map() => data['results'] ?? data['items'] ?? data['wishlist'] ?? const [],
      _ => const [],
    };
    final lastPage = data is Map ? (data['last_page'] as num?)?.toInt() : null;

    return PageResult(
      items: (list as List)
          .whereType<Map<String, dynamic>>()
          .map(WishlistItemModel.tryFromJson)
          .whereType<WishlistItem>()
          .toList(),
      lastPage: lastPage ?? 1,
    );
  }

  Future<void> addToWishlist(String productId) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.wishlist),
      headers: AuthHeaders.build(),
      body: {'product': productId},
    );
    _throwIfFailed(response.isSuccess, response.errorMessage);
  }

  Future<void> deleteItem(String wishlistItemId) async {
    final response = await _networkCaller.delete(
      Uri.parse(EndPoints.wishlistItem(wishlistItemId)),
      headers: AuthHeaders.build(),
    );
    _throwIfFailed(response.isSuccess, response.errorMessage);
  }

  void _throwIfFailed(bool? isSuccess, String? message) {
    if (isSuccess != true) throw Exception(message);
  }
}
