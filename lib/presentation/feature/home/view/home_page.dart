import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/domain/entities/category.dart';
import 'package:crafty_bay/domain/entities/product.dart';
import 'package:crafty_bay/presentation/feature/product_list/view/curated_products_page.dart';
import 'package:crafty_bay/presentation/feature/categories/provider/category_provider.dart';
import 'package:crafty_bay/presentation/feature/home/provider/brand_provider.dart';
import 'package:crafty_bay/presentation/feature/home/provider/product_provider.dart';
import 'package:crafty_bay/presentation/feature/home/provider/slide_provider.dart';
import 'package:crafty_bay/presentation/feature/home/widgets/home_api_product_section.dart';
import 'package:crafty_bay/presentation/feature/home/widgets/home_brand_section.dart';
import 'package:crafty_bay/presentation/feature/categories/view/categories_page.dart';
import 'package:crafty_bay/domain/entities/brand.dart';
import 'package:crafty_bay/presentation/feature/brands/view/brands_page.dart';
import 'package:crafty_bay/presentation/feature/product_list/view/product_list_page.dart';
import 'package:crafty_bay/presentation/feature/home/widgets/home_app_bar.dart';
import 'package:crafty_bay/presentation/feature/home/widgets/home_banner_carousel.dart';
import 'package:crafty_bay/presentation/feature/home/widgets/home_category_section.dart';
import 'package:crafty_bay/presentation/feature/home/widgets/home_search_bar.dart';
import 'package:crafty_bay/presentation/feature/reviews/provider/rating_provider.dart';
import 'package:crafty_bay/presentation/feature/search/view/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<SlideProvider>(context, listen: false).fetchSlides();
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<BrandProvider>(context, listen: false).fetchBrands();
      Provider.of<ProductProvider>(context, listen: false)
        ..fetchProducts()
        ..fetchCatalog();
      Provider.of<RatingProvider>(context, listen: false).fetchRatings();
    });
  }

  void _openSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchPage()),
    );
  }

  void _openCategories(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CategoriesPage()),
    );
  }

  void _openCategory(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductListPage(title: category.title, categoryId: category.id),
      ),
    );
  }

  void _openBrands(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BrandsPage()),
    );
  }

  void _openPopular(BuildContext context, List<Product> products) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CuratedProductsPage(title: AppStrings.popular, products: products),
      ),
    );
  }

  void _openBrand(BuildContext context, Brand brand) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductListPage(title: brand.title, brandId: brand.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const HomeAppBar(),
            const SizedBox(height: 8),
            HomeSearchBar(onTap: () => _openSearch(context)),
            const SizedBox(height: 16),
            const HomeBannerCarousel(),
            const SizedBox(height: 20),
            Consumer<CategoryProvider>(
              builder: (_, provider, _) {
                if (provider.isLoading && provider.categories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return HomeCategorySection(
                  categories: provider.categories,
                  onSeeAllTap: () => _openCategories(context),
                  onCategoryTap: (c) => _openCategory(context, c),
                );
              },
            ),
            const SizedBox(height: 8),
            Consumer<BrandProvider>(
              builder: (_, provider, _) {
                if (provider.isLoading && provider.brands.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return HomeBrandSection(
                  brands: provider.brands,
                  onSeeAllTap: () => _openBrands(context),
                  onBrandTap: (b) => _openBrand(context, b),
                );
              },
            ),
            Consumer<ProductProvider>(
              builder: (_, provider, _) {
                if (provider.isLoading && provider.products.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return HomeApiProductSection(
                  title: AppStrings.product,
                  products: provider.products,
                );
              },
            ),
            Consumer2<ProductProvider, RatingProvider>(
              builder: (_, products, ratings, _) {
                final byId = {for (final p in products.catalog) p.id: p};
                final popular = [
                  for (final id in ratings.popularIds)
                    if (byId[id] != null) byId[id]!,
                ];
                if (popular.isEmpty) return const SizedBox.shrink();

                return HomeApiProductSection(
                  title: AppStrings.popular,
                  products: popular.take(10).toList(),
                  onSeeAllTap: () => _openPopular(context, popular),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
