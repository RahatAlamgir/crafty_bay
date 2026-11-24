import 'package:crafty_bay/data/service/review_service.dart';
import 'package:crafty_bay/domain/entities/review.dart';
import 'package:flutter/foundation.dart';

/// Reviews of one product, plus submitting a new one.
///
/// Created by the Product Details page and shared with the Reviews page, so
/// the rating on the details page always matches the reviews list.
class ReviewProvider extends ChangeNotifier {
  ReviewProvider({required this.productId});

  final String productId;
  final _service = ReviewService();

  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  /// Average star rating, or 0 when there are no reviews.
  double get averageRating => _reviews.isEmpty
      ? 0
      : _reviews.fold<double>(0, (sum, r) => sum + r.rating) / _reviews.length;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchReviews() async {
    _isLoading = true;
    notifyListeners();
    try {
      _reviews = await _service.getProductReviews(productId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = _clean(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sends the review, then reloads the list so it appears at the top.
  /// Returns false (with [errorMessage] set) on failure.
  Future<bool> submit({required double rating, required String comment}) async {
    _isSubmitting = true;
    notifyListeners();
    try {
      await _service.createReview(
        productId: productId,
        rating: rating,
        comment: comment,
      );
      _errorMessage = '';
      _isSubmitting = false;
      await fetchReviews();

      return true;
    } catch (e) {
      _errorMessage = _clean(e);

      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');
}
