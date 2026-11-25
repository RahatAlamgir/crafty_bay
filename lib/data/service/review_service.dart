import 'dart:convert';

import '../../core/end_points.dart';
import '../../domain/entities/page_result.dart';
import '../../domain/entities/review.dart';
import '../model/review_model.dart';
import 'network/auth_headers.dart';
import 'network/network_caller.dart';

class ReviewService {
  final _networkCaller = NetworkCaller();

  /// The server requires a `product` value on the reviews list but ignores it
  /// and returns every product's reviews. This placeholder is used when the
  /// caller wants all of them.
  static const _anyProduct = '000000000000000000000000';

  /// Reviews per request. The server honours `count`, so the whole list
  /// normally arrives in one request instead of one request per 10 reviews.
  static const _pageSize = 100;

  /// How long the downloaded list is reused before asking the server again.
  static const _maxAge = Duration(minutes: 2);

  // Shared by every ReviewService instance: the home cards, the details page
  // and the reviews page all read the same download.
  static List<Review>? _cache;
  static DateTime? _cachedAt;
  static Future<List<Review>>? _inFlight;

  /// Every review of every product. Reuses a recent download (and any request
  /// already running); pass [forceRefresh] to go to the server.
  Future<List<Review>> getAllReviews({bool forceRefresh = false}) {
    final cached = _cache;
    final fresh =
        _cachedAt != null && DateTime.now().difference(_cachedAt!) < _maxAge;
    if (!forceRefresh && cached != null && fresh) return Future.value(cached);

    return _inFlight ??= _download().whenComplete(() => _inFlight = null);
  }

  /// Reviews of one product, newest first.
  Future<List<Review>> getProductReviews(
    String productId, {
    bool forceRefresh = false,
  }) async {
    final all = await getAllReviews(forceRefresh: forceRefresh);
    final reviews = all.where((r) => r.productId == productId).toList();
    reviews.sort((a, b) => _time(b).compareTo(_time(a)));

    return reviews;
  }

  Future<List<Review>> _download() async {
    final first = await _getPage(1);
    final rest = await Future.wait([
      for (var page = 2; page <= first.lastPage; page++) _getPage(page),
    ]);
    final all = [first, ...rest].expand((p) => p.items).toList();
    _cache = all;
    _cachedAt = DateTime.now();

    return all;
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
    // The list changed on the server, so the saved copy is out of date.
    _cache = null;
    _cachedAt = null;
  }

  Future<PageResult<Review>> _getPage(int page) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.reviewsPage(_anyProduct, page, count: _pageSize)),
      headers: {'accept': 'application/json'},
    );
    if (response.isSuccess != true) throw Exception(response.errorMessage);
    final data = jsonDecode(response.body!)['data'];

    return PageResult<Review>(
      items: (data['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map(ReviewModel.fromJson)
          .toList(),
      lastPage: (data['last_page'] as num?)?.toInt() ?? 1,
    );
  }

  DateTime _time(Review r) =>
      r.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
}
