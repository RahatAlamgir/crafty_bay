import 'package:crafty_bay/core/app_colors.dart';
import 'package:flutter/material.dart';

/// Row of five stars. Read-only when [onChanged] is null; otherwise tapping a
/// star sets the rating to that whole number.
///
/// Read-only ratings can be fractional (3.5 shows three and a half stars).
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.onChanged,
    this.size = 16,
  });

  static const int _count = 5;

  final double rating;
  final ValueChanged<double>? onChanged;
  final double size;

  IconData _iconFor(int index) {
    if (rating >= index + 1) return Icons.star;
    if (rating >= index + 0.5) return Icons.star_half;

    return Icons.star_border;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _count; i++)
          GestureDetector(
            onTap: onChanged == null ? null : () => onChanged!(i + 1.0),
            child: Padding(
              padding: EdgeInsets.only(right: onChanged == null ? 2 : 6),
              child: Icon(_iconFor(i), size: size, color: AppColors.accent),
            ),
          ),
      ],
    );
  }
}
