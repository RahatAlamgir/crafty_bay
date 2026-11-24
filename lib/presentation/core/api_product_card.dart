import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/domain/entities/product.dart';
import 'package:crafty_bay/presentation/core/confirm_dialog.dart';
import 'package:crafty_bay/presentation/core/product_card.dart';
import 'package:crafty_bay/presentation/feature/product_details/view/product_details_api_page.dart';
import 'package:crafty_bay/presentation/feature/wishlist/provider/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A [ProductCard] for a product from the API: the heart reflects and changes
/// the wish list (asking first before removing), and a tap opens the details.
///
/// Used by Home and Search so both behave the same.
class ApiProductCard extends StatelessWidget {
  const ApiProductCard({super.key, required this.product, this.width});

  final Product product;

  /// Fixed width for horizontal lists. Leave null inside a grid.
  final double? width;

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsApiPage(productId: product.id),
      ),
    );
  }

  /// Adding is instant; removing a wished product asks first.
  Future<void> _onWishTap(
    BuildContext context,
    WishlistProvider wishlist,
  ) async {
    if (wishlist.isWished(product.id)) {
      final confirmed = await showConfirmDialog(
        context,
        title: AppStrings.removeFromWishlistTitle,
        message: AppStrings.removeFromWishlistMessage,
        confirmLabel: AppStrings.remove,
        destructive: true,
      );
      if (!confirmed) return;
    }
    await wishlist.toggle(product.id);
  }

  @override
  Widget build(BuildContext context) {
    // Consumer (not context.watch) because this can build inside a pushed
    // route, where the parent widget's own context is not rebuilding.
    return Consumer<WishlistProvider>(
      builder: (context, wishlist, _) => ProductCard(
        width: width,
        image: NetworkImage(
          product.photos.isNotEmpty ? product.photos.first : '',
        ),
        title: product.title,
        price: '${AppStrings.currencySymbol}${product.currentPrice}',
        isWished: wishlist.isWished(product.id),
        onTap: () => _openDetails(context),
        onWishTap: () => _onWishTap(context, wishlist),
      ),
    );
  }
}
