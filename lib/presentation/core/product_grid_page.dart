import 'package:crafty_bay/core/app_colors.dart';
import 'package:flutter/material.dart';

/// Reusable page that shows products in a grid (3 columns by default) under
/// a titled app bar with a back button.
///
/// Used for Wish List, product list by category, search results, etc.
/// The caller supplies the [title] and builds each cell (normally a
/// `ProductCard`) through [itemBuilder], so the page holds no data logic.
///
/// There is no fixed cell height: each row is as tall as its tallest card and
/// every card in the row is stretched to match, at any screen width or text
/// size.
class ProductGridPage extends StatelessWidget {
  const ProductGridPage({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 3,
  });

  static const double _spacing = 10;

  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final int crossAxisCount;

  int get _rowCount => (itemCount / crossAxisCount).ceil();

  Widget _buildRow(BuildContext context, int row) {
    final first = row * crossAxisCount;

    return Padding(
      padding: EdgeInsets.only(bottom: row == _rowCount - 1 ? 0 : _spacing),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var col = 0; col < crossAxisCount; col++) ...[
              if (col > 0) const SizedBox(width: _spacing),
              // Empty slots keep the last row's cards the same width.
              Expanded(
                child: first + col < itemCount
                    ? itemBuilder(context, first + col)
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      ),
    );
  }

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _rowCount,
        itemBuilder: _buildRow,
      ),
    );
  }
}
