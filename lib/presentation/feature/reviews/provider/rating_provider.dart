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
  Map<String, int> _counts = {};
  bool _isLoading = false;

  /// Average rating of [productId], or null when it has no reviews yet (the
  /// card then shows no rating at all).
  double? ratingFor(String productId) => _averages[productId];

  // A product with one 5-star review should not beat one with 20 reviews
  // averaging 4.5, so the ranking pulls small samples towards the middle:
  // it behaves as if every product also had [_priorWeight] reviews of
  // [_priorRating] stars.
  static const double _priorRating = 3.5;
  static const int _priorWeight = 3;

  /// Ids of the reviewed products, best first (see the note above).
  List<String> get popularIds {
    double score(String id) =>
        (_averages[id]! * _counts[id]! + _priorRating * _priorWeight) /
        (_counts[id]! + _priorWeight);

    return _averages.keys.toList()
      ..sort((a, b) => score(b).compareTo(score(a)));
  }

  Future<void> fetchRatings() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      final reviews = await _service.getAllReviews();
      final byProduct = <String, List<double>>{};
      for (final review in reviews) {
        byProduct.putIfAbsent(review.productId, () => []).add(review.rating);
      }
      _counts = {
        for (final entry in byProduct.entries) entry.key: entry.value.length,
      };
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
