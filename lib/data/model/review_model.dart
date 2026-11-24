import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.productId,
    required super.reviewerName,
    required super.rating,
    required super.comment,
    super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    final user = json['user'];

    return ReviewModel(
      id: (json['_id'] ?? '').toString(),
      // `product` is a populated object in list responses, an id elsewhere.
      productId: product is Map
          ? (product['_id'] ?? '').toString()
          : (product ?? '').toString(),
      reviewerName: user is Map
          ? '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim()
          : '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: (json['comment'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()),
    );
  }
}
