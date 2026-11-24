import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/domain/entities/brand.dart';
import 'package:crafty_bay/presentation/core/paged_footer.dart';
import 'package:crafty_bay/presentation/core/tile_grid_page.dart';
import 'package:crafty_bay/presentation/feature/home/provider/brand_provider.dart';
import 'package:crafty_bay/presentation/feature/product_list/view/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// All brands in a 4-column grid. Tapping one lists its products.
class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BrandProvider>(context, listen: false);
    if (provider.brands.isEmpty) {
      Future.microtask(provider.fetchBrands);
    }
  }

  void _openBrand(Brand brand) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductListPage(title: brand.title, brandId: brand.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BrandProvider>();

    return TileGridPage(
      title: AppStrings.brands,
      isLoading: provider.isLoading,
      errorMessage: provider.errorMessage,
      onRetry: provider.fetchBrands,
      onEndReached: provider.fetchNextPage,
      footer: buildPagedFooter(provider),
      items: [
        for (final brand in provider.brands)
          TileItem(
            iconUrl: brand.icon,
            name: brand.title,
            onTap: () => _openBrand(brand),
          ),
      ],
    );
  }
}
