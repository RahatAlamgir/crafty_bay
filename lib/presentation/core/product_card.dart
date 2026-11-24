import 'package:crafty_bay/core/app_colors.dart';
import 'package:flutter/material.dart';

import 'app_image.dart';

/// Reusable product tile: image, title, price, rating and wishlist button.
///
/// Used by Home, Product list, Wishlist, etc. Receives all data and
/// callbacks via parameters — no provider access or hardcoded text.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    this.rating,
    this.width,
    this.isWished = false,
    this.onTap,
    this.onWishTap,
  });

  final ImageProvider image;
  final String title;
  final String price;

  /// Hidden when null (the products API has no rating yet).
  final double? rating;

  /// Fixed width (e.g. in a horizontal list). Leave null inside a grid.
  final double? width;
  final bool isWished;
  final VoidCallback? onTap;
  final VoidCallback? onWishTap;

  static const double _titleFontSize = 11;
  static const double _titleLineHeight = 1.3;
  static const int _titleLines = 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.border,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.20,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AppImage(image: image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Always reserves two lines, so a one-line title never makes
                  // the card shorter than its neighbours. The height comes from
                  // the font size and the user's text scale, not a fixed number.
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.textScalerOf(
                        context,
                      ).scale(_titleFontSize * _titleLineHeight * _titleLines),
                    ),
                    child: Text(
                      title,
                      maxLines: _titleLines,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: _titleFontSize,
                        height: _titleLineHeight,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        // Scales price + rating down so narrow grid cells never overflow.
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                price,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              if (rating != null) ...[
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  rating!.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: onWishTap,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            isWished ? Icons.favorite : Icons.favorite_border,
                            size: 14,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
