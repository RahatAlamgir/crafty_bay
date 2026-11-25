import 'package:crafty_bay/presentation/feature/product_list/provider/product_list_provider.dart';
import 'package:crafty_bay/presentation/feature/product_list/view/product_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      create: (_) =>
          ProductListProvider(categoryId: categoryId, brandId: brandId)
            ..fetchProducts(),
      child: ProductListView(title: title),
    );
  }
}
