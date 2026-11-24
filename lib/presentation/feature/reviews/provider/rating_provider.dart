import 'package:crafty_bay/data/service/review_service.dart';
import 'package:flutter/foundation.dart';

/// Average star rating of every product, for the small rating on product
/// cards.
///
/// The server has no per-product rating, so this loads all reviews once and
/// averages them per product. Call [fetchRatings] again after a new review.
class RatingProvider extends ChangeNotifier {
  final _service = ReviewService();

  Map<String, double> _averages = {};
  bool _isLoading = false;

  /// Average rating of [productId], or null when it has no reviews yet (the
  /// card then shows no rating at all).
  double? ratingFor(String productId) => _averages[productId];

  Future<void> fetchRatings() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      final reviews = await _service.getAllReviews();
      final byProduct = <String, List<double>>{};
      for (final review in reviews) {
        byProduct.putIfAbsent(review.productId, () => []).add(review.rating);
      }
      _averages = {
        for (final entry in byProduct.entries)
          entry.key: entry.value.reduce((a, b) => a + b) / entry.value.length,
      };
      notifyListeners();
    } catch (_) {
      // Ratings are a nicety: if loading fails, cards simply show no rating.
    } finally {
      _isLoading = false;
    }
  }
}
