import 'package:flutter/material.dart';

/// Scrollable grid (3 columns by default) of product cells.
///
/// There is no fixed cell height: each row is as tall as its tallest card and
/// every card in the row is stretched to match, at any screen width or text
/// size. The caller builds each cell (normally a `ProductCard`).
///
/// For lists that load page by page, pass [onEndReached] (called when the user
/// scrolls near the bottom) and a [footer] (a spinner or retry row) shown
/// under the last row.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 3,
    this.onEndReached,
    this.footer,
  });

  static const double _spacing = 10;

  /// How close to the bottom (in pixels) the user must scroll before
  /// [onEndReached] fires, so the next page is ready before they get there.
  static const double _loadMoreDistance = 400;

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final int crossAxisCount;
  final VoidCallback? onEndReached;
  final Widget? footer;

  int get _rowCount => (itemCount / crossAxisCount).ceil();

  Widget _buildRow(BuildContext context, int row) {
    if (row == _rowCount) return footer!;
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

  void _checkEnd(ScrollMetrics metrics) {
    if (metrics.extentAfter < _loadMoreDistance) onEndReached?.call();
  }

  @override
  Widget build(BuildContext context) {
    // Two listeners: scrolling, and layout changes. The second matters when a
    // page is too short to scroll at all, so the user could never reach the
    // bottom to trigger loading the next page.
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (n) {
        _checkEnd(n.metrics);

        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          _checkEnd(n.metrics);

          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: _rowCount + (footer == null ? 0 : 1),
          itemBuilder: _buildRow,
        ),
      ),
    );
  }
}
