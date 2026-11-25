import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/presentation/core/api_product_card.dart';
import 'package:crafty_bay/presentation/core/paged_footer.dart';
import 'package:crafty_bay/presentation/core/product_grid.dart';
import 'package:crafty_bay/presentation/feature/product_list/provider/product_list_provider.dart';
import 'package:crafty_bay/presentation/feature/product_list/widgets/product_list_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The screen itself: app bar plus a spinner, an error with Retry, an empty
/// message, or the paged product grid. Reads the provider above it.
class ProductListView extends StatelessWidget {
  const ProductListView({super.key, required this.title});

  final String title;

  Widget _buildBody(ProductListProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.errorMessage.isNotEmpty) {
      return ProductListMessage(
        text: provider.errorMessage,
        actionLabel: AppStrings.retry,
        onAction: provider.fetchProducts,
      );
    }
    if (provider.products.isEmpty) {
      return const ProductListMessage(text: AppStrings.noProductsHere);
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
