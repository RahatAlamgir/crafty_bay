import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/domain/entities/product.dart';
import 'package:crafty_bay/presentation/core/api_product_card.dart';
import 'package:crafty_bay/presentation/core/product_grid.dart';
import 'package:flutter/material.dart';

/// A fixed list of products already chosen by a rule (e.g. Popular), shown
/// as a grid. Unlike [ProductListPage] it does not load pages from the server.
class CuratedProductsPage extends StatelessWidget {
  const CuratedProductsPage({
    super.key,
    required this.title,
    required this.products,
  });

  final String title;
  final List<Product> products;

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
      body: products.isEmpty
          ? const Center(
              child: Text(
                AppStrings.noProductsHere,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ProductGrid(
              itemCount: products.length,
              itemBuilder: (_, i) => ApiProductCard(product: products[i]),
            ),
    );
  }
}
