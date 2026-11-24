import 'dart:convert';

import '../../core/end_points.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/page_result.dart';
import '../model/cart_item_model.dart';
import 'network/auth_headers.dart';
import 'network/network_caller.dart';

class CartService {
  final _networkCaller = NetworkCaller();

  /// Every cart line, all pages. The cart total and the badge need the whole
  /// cart, so this loads all pages instead of stopping at the first.
  Future<List<CartItem>> getCart() async {
    final first = await _getPage(1);
    final rest = await Future.wait([
      for (var page = 2; page <= first.lastPage; page++) _getPage(page),
    ]);

    return [first, ...rest].expand((p) => p.items).toList();
  }

  Future<PageResult<CartItem>> _getPage(int page) async {
    final response = await _networkCaller.get(
      Uri.parse(page == 1 ? EndPoints.cart : EndPoints.cartPage(page)),
      headers: AuthHeaders.build(),
    );
    _throwIfFailed(response.isSuccess, response.errorMessage);
    final data = jsonDecode(response.body!)['data'];
    final list = switch (data) {
      List() => data,
      Map() => data['results'] ?? data['items'] ?? data['cart'] ?? const [],
      _ => const [],
    };
    final lastPage = data is Map ? (data['last_page'] as num?)?.toInt() : null;

    return PageResult(
      items: (list as List)
          .whereType<Map<String, dynamic>>()
          .map(CartItemModel.fromJson)
          .toList(),
      lastPage: lastPage ?? 1,
    );
  }

  Future<void> addToCart({
    required String productId,
    required int quantity,
    String? color,
    String? size,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.cart),
      headers: AuthHeaders.build(),
      body: {
        'product': productId,
        'quantity': quantity,
        'color': ?color,
        'size': ?size,
      },
    );
    _throwIfFailed(response.isSuccess, response.errorMessage);
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    final response = await _networkCaller.patch(
      Uri.parse(EndPoints.cartItem(cartItemId)),
      headers: AuthHeaders.build(),
      body: {'quantity': quantity},
    );
    _throwIfFailed(response.isSuccess, response.errorMessage);
  }

  Future<void> deleteItem(String cartItemId) async {
    final response = await _networkCaller.delete(
      Uri.parse(EndPoints.cartItem(cartItemId)),
      headers: AuthHeaders.build(),
    );
    _throwIfFailed(response.isSuccess, response.errorMessage);
  }

  void _throwIfFailed(bool? isSuccess, String? message) {
    if (isSuccess != true) throw Exception(message);
  }
}
