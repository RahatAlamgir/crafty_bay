import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/domain/entities/category.dart';
import 'package:crafty_bay/presentation/core/category_card.dart';
import 'package:crafty_bay/presentation/core/product_section.dart';
import 'package:flutter/material.dart';

/// "All Categories" header followed by a horizontally scrolling row of every
/// category tile. "See All" opens the full grid.
class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({
    super.key,
    required this.categories,
    this.onSeeAllTap,
    this.onCategoryTap,
  });

  final List<Category> categories;
  final VoidCallback? onSeeAllTap;
  final ValueChanged<Category>? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final tileSize = CategoryCard.tileSize(context);

    return ProductSection(
      title: AppStrings.allCategories,
      onSeeAllTap: onSeeAllTap,
      itemCount: categories.length,
      itemBuilder: (_, i) => CategoryCard(
        iconUrl: categories[i].icon,
        name: categories[i].title,
        size: tileSize,
        onTap: () => onCategoryTap?.call(categories[i]),
      ),
    );
  }
}
