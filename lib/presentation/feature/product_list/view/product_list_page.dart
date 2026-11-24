import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/presentation/core/api_product_card.dart';
import 'package:crafty_bay/presentation/core/paged_footer.dart';
import 'package:crafty_bay/presentation/core/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_list_provider.dart';

/// Products of one category or one brand (or all products when neither is
/// given), loaded page by page as the user scrolls.
/// [title] is the name shown on top.
class ProductListPage extends StatelessWidget {
  const ProductListPage({
    super.key,
    required this.title,
    this.categoryId,
    this.brandId,
  });

  final String title;
  final String? categoryId;
  final String? brandId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductListProvider(
        categoryId: categoryId,
        brandId: brandId,
      )..fetchProducts(),
      child: _ProductListView(title: title),
    );
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView({required this.title});

  final String title;

  Widget _buildBody(ProductListProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.errorMessage.isNotEmpty) {
      return _Message(
        text: provider.errorMessage,
        actionLabel: AppStrings.retry,
        onAction: provider.fetchProducts,
      );
    }
    if (provider.products.isEmpty) {
      return const _Message(text: AppStrings.noProductsHere);
    }

    return ProductGrid(
      itemCount: provider.products.length,
      itemBuilder: (_, i) => ApiProductCard(product: provider.products[i]),
      onEndReached: provider.fetchNextPage,
      footer: buildPagedFooter(provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductListProvider>();

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
      body: _buildBody(provider),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.actionLabel, this.onAction});

  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            if (actionLabel != null)
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ),
      ),
    );
  }
}
