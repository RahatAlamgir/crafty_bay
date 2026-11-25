import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/domain/entities/product.dart';
import 'package:crafty_bay/presentation/core/api_product_card.dart';
import 'package:crafty_bay/presentation/core/product_section.dart';
import 'package:crafty_bay/presentation/feature/product_list/view/product_list_page.dart';
import 'package:flutter/material.dart';

/// Home row of API products, sized so three cards fit on screen.
/// "See All" opens a [ProductListPage] with every product.
class HomeApiProductSection extends StatelessWidget {
  const HomeApiProductSection({
    super.key,
    required this.title,
    required this.products,
    this.onSeeAllTap,
  });

  final String title;
  final List<Product> products;

  /// Replaces the default "See All" (the paged list of every product).
  final VoidCallback? onSeeAllTap;

  /// The home row only holds the first page of products, so "See All" opens
  /// a page that loads every product from the server.
  void _openAll(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductListPage(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.sizeOf(context).width - 10 - 10) / 3;

    return ProductSection(
      title: title,
      seeAllLabel: AppStrings.seeAll,
      onSeeAllTap: onSeeAllTap ?? () => _openAll(context),
      itemCount: products.length,
      itemBuilder: (_, i) =>
          ApiProductCard(product: products[i], width: cardWidth),
    );
  }
}
