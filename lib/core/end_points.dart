import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API URLs. `BASE_URL` is read from `.env`, loaded in `main()`.
///
/// Customer endpoints only; admin-only routes (create/update/delete of
/// brands, categories, products, slides) are intentionally left out.
class EndPoints {
  EndPoints._();

  static String get baseUrl => dotenv.env['BASE_URL']!;

  // --- Auth ---
  static String get login => '$baseUrl/auth/login';
  static String get signup => '$baseUrl/auth/signup';
  static String get verifyOtp => '$baseUrl/auth/verify-otp';
  static String get resendOtp => '$baseUrl/auth/resend-otp';
  static String get profile => '$baseUrl/auth/profile'; // GET, PATCH

  // --- Home ---
  static String get slides => '$baseUrl/slides';
  static String get brands => '$baseUrl/brands';
  static String brandsPage(int page) => '$baseUrl/brands?page=$page';
  static String get categories => '$baseUrl/categories';
  static String categoriesPage(int page) => '$baseUrl/categories?page=$page';

  // --- Products ---
  static String get products => '$baseUrl/products';

  /// One page of products, optionally only those of a category and/or brand.
  static String productsPage(
    int page, {
    String? categoryId,
    String? brandId,
    int? count,
  }) {
    final query = {
      'page': '$page',
      'category': ?categoryId,
      'brand': ?brandId,
      'count': ?count?.toString(),
    };

    return Uri.parse('$baseUrl/products')
        .replace(queryParameters: query)
        .toString();
  }

  static String productBySlug(String slug) => '$baseUrl/products/$slug';
  static String productById(String id) => '$baseUrl/products/id/$id';

  // --- Reviews ---
  static String get reviews => '$baseUrl/reviews'; // GET ?product=<id>
  static String reviewsPage(String productId, int page, {int? count}) =>
      '$baseUrl/reviews?product=$productId&page=$page'
      '${count == null ? '' : '&count=$count'}';
  static String get createReview => '$baseUrl/review';
  static String review(String id) => '$baseUrl/reviews/$id'; // PATCH, DELETE

  // --- Cart ---
  static String get cart => '$baseUrl/cart'; // GET, POST
  static String cartPage(int page) => '$baseUrl/cart?page=$page';
  static String cartItem(String id) => '$baseUrl/cart/$id'; // PATCH, DELETE

  // --- Wishlist ---
  static String get wishlist => '$baseUrl/wishlist'; // GET, POST
  static String wishlistPage(int page) => '$baseUrl/wishlist?page=$page';
  static String wishlistItem(String id) => '$baseUrl/wishlist/$id'; // DELETE

  // --- Orders ---
  static String get orders => '$baseUrl/orders'; // GET
  static String get createOrder => '$baseUrl/order';
  static String order(String id) => '$baseUrl/orders/$id';
  static String cancelOrder(String id) => '$baseUrl/orders/$id/cancel'; // PATCH
}
