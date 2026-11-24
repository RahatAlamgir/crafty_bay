import 'package:flutter/material.dart';

/// Scrollable grid (3 columns by default) of product cells.
///
/// There is no fixed cell height: each row is as tall as its tallest card and
/// every card in the row is stretched to match, at any screen width or text
/// size. The caller builds each cell (normally a `ProductCard`).
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 3,
  });

  static const double _spacing = 10;

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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: _rowCount,
      itemBuilder: _buildRow,
    );
  }
}
