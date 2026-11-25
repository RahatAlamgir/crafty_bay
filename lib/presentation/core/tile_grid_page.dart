import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:flutter/material.dart';

import 'category_card.dart';
import 'product_grid.dart';
import 'tile_item.dart';

/// Icon tiles in a 4-column grid under a titled app bar. Used for the
/// Categories and Brands pages.
///
/// There is no fixed row height: each row is as tall as its tiles, so long
/// names or a larger text size never overflow.
class TileGridPage extends StatelessWidget {
  const TileGridPage({
    super.key,
    required this.title,
    required this.items,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    this.onEndReached,
    this.footer,
  });

  static const int _columns = 4;

  final String title;
  final List<TileItem> items;
  final bool isLoading;
  final String errorMessage;
  final VoidCallback onRetry;

  /// For lists loaded page by page: called near the bottom, and the footer
  /// (spinner or retry) shown under the last row.
  final VoidCallback? onEndReached;
  final Widget? footer;

  Widget _buildBody(BuildContext context) {
    if (items.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (items.isEmpty && errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage),
            TextButton(onPressed: onRetry, child: const Text(AppStrings.retry)),
          ],
        ),
      );
    }
    final tileSize = CategoryCard.tileSize(context);

    return ProductGrid(
      crossAxisCount: _columns,
      itemCount: items.length,
      onEndReached: onEndReached,
      footer: footer,
      // Tile keeps its size, centred in an equal quarter of the width, so
      // spare space becomes spacing — same layout as the home row.
      itemBuilder: (_, i) => Align(
        alignment: Alignment.topCenter,
        child: CategoryCard(
          iconUrl: items[i].iconUrl,
          name: items[i].name,
          size: tileSize,
          onTap: items[i].onTap,
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
      body: _buildBody(context),
    );
  }
}
