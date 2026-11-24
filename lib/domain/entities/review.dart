/// One customer review of a product.
class Review {
  final String id;
  final String productId;
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  const Review({
    required this.id,
    required this.productId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    this.createdAt,
  });
}
