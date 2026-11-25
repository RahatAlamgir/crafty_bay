import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/domain/entities/category.dart';
import 'package:crafty_bay/presentation/core/paged_footer.dart';
import 'package:crafty_bay/presentation/core/tile_grid_page.dart';
import 'package:crafty_bay/presentation/core/tile_item.dart';
import 'package:crafty_bay/presentation/feature/categories/provider/category_provider.dart';
import 'package:crafty_bay/presentation/feature/product_list/view/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// All categories in a 4-column grid. Tapping one lists its products.
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    if (provider.categories.isEmpty) {
      Future.microtask(provider.fetchCategories);
    }
  }

  void _openCategory(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductListPage(title: category.title, categoryId: category.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return TileGridPage(
      title: AppStrings.categories,
      isLoading: provider.isLoading,
      errorMessage: provider.errorMessage,
      onRetry: provider.fetchCategories,
      onEndReached: provider.fetchNextPage,
      footer: buildPagedFooter(provider),
      items: [
        for (final category in provider.categories)
          TileItem(
            iconUrl: category.icon,
            name: category.title,
            onTap: () => _openCategory(category),
          ),
      ],
    );
  }
}
