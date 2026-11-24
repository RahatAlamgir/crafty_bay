import 'dart:convert';

import '../../core/end_points.dart';
import '../../domain/entities/review.dart';
import '../model/review_model.dart';
import 'network/auth_headers.dart';
import 'network/network_caller.dart';

/// One page of the reviews list, plus how many pages exist.
class _ReviewPage {
  final List<Review> reviews;
  final int lastPage;

  _ReviewPage({required this.reviews, required this.lastPage});
}

class ReviewService {
  final _networkCaller = NetworkCaller();

  /// The server requires a `product` value on the reviews list but ignores it
  /// and returns every product's reviews. This placeholder is used when the
  /// caller wants all of them.
  static const _anyProduct = '000000000000000000000000';

  /// Every review of every product, all pages.
  Future<List<Review>> getAllReviews() async {
    final first = await _getPage(1);
    final pages = await Future.wait([
      for (var page = 2; page <= first.lastPage; page++) _getPage(page),
    ]);

    return [first, ...pages].expand((p) => p.reviews).toList();
  }

  /// Reviews of one product, newest first.
  Future<List<Review>> getProductReviews(String productId) async {
    final all = await getAllReviews();
    final reviews = all.where((r) => r.productId == productId).toList();
    reviews.sort((a, b) => _time(b).compareTo(_time(a)));

    return reviews;
  }

  Future<void> createReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.createReview),
      headers: AuthHeaders.build(),
      body: {'product': productId, 'rating': rating, 'comment': comment},
    );
    if (response.isSuccess != true) throw Exception(response.errorMessage);
  }

  Future<_ReviewPage> _getPage(int page) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.reviewsPage(_anyProduct, page)),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) throw Exception(response.errorMessage);
    final data = jsonDecode(response.body!)['data'];

    return _ReviewPage(
      reviews: (data['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map(ReviewModel.fromJson)
          .toList(),
      lastPage: (data['last_page'] as num?)?.toInt() ?? 1,
    );
  }

  DateTime _time(Review r) =>
      r.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
}
