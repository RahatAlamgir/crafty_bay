import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/presentation/core/product_grid.dart';
import 'package:flutter/material.dart';

/// Reusable page that shows products in a grid (3 columns by default) under
/// a titled app bar with a back button.
///
/// Used for Wish List, product list by category, "See All", etc.
/// The caller supplies the [title] and builds each cell (normally a
/// `ProductCard`) through [itemBuilder], so the page holds no data logic.
class ProductGridPage extends StatelessWidget {
  const ProductGridPage({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 3,
  });

  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ProductGrid(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        crossAxisCount: crossAxisCount,
      ),
    );
  }
}
