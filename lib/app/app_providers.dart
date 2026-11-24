import 'package:crafty_bay/presentation/feature/auth/provider/auth_provider.dart';
import 'package:crafty_bay/presentation/feature/cart/provider/cart_provider.dart';
import 'package:crafty_bay/presentation/feature/categories/provider/category_provider.dart';
import 'package:crafty_bay/presentation/feature/home/provider/brand_provider.dart';
import 'package:crafty_bay/presentation/feature/home/provider/product_provider.dart';
import 'package:crafty_bay/presentation/feature/home/provider/slide_provider.dart';
import 'package:crafty_bay/presentation/feature/profile/provider/profile_provider.dart';
import 'package:crafty_bay/presentation/feature/wishlist/provider/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Every app-wide provider. Add a new provider here.
class AppProviders {
  AppProviders._();

  static List<SingleChildWidget> get all => [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => WishlistProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => SlideProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_) => BrandProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
  ];
}
