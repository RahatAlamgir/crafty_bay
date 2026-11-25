import 'package:crafty_bay/core/app_assets.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/data/service/cache/cache_service.dart';
import 'package:crafty_bay/presentation/core/confirm_dialog.dart';
import 'package:crafty_bay/presentation/feature/auth/auth_redirect.dart';
import 'package:crafty_bay/presentation/feature/auth/provider/auth_provider.dart';
import 'package:crafty_bay/presentation/feature/cart/provider/cart_provider.dart';
import 'package:crafty_bay/presentation/feature/home/widgets/home_circle_icon_button.dart';
import 'package:crafty_bay/presentation/feature/profile/provider/profile_provider.dart';
import 'package:crafty_bay/presentation/feature/profile/view/profile_page.dart';
import 'package:crafty_bay/presentation/feature/wishlist/provider/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// Home top row: logo on the left, profile / call / notification / logout actions.
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  void _onProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  Future<void> _onLogout(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: AppStrings.logoutTitle,
      message: AppStrings.logoutMessage,
      confirmLabel: AppStrings.logout,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final auth = context.read<AuthProvider>();
    final cart = context.read<CartProvider>();
    final wishlist = context.read<WishlistProvider>();
    final profile = context.read<ProfileProvider>();
    await auth.logout();
    cart.clear();
    wishlist.clear();
    profile.clear();
    AuthRedirect.toLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SvgPicture.asset(AppAssets.logoNav, height: 28),
          const Spacer(),
          HomeCircleIconButton(
            icon: Icons.person_outline,
            onTap: () => _onProfile(context),
          ),
          const SizedBox(width: 8),
          const HomeCircleIconButton(icon: Icons.call_outlined),
          const SizedBox(width: 8),
          const HomeCircleIconButton(icon: Icons.notifications_none),
          const SizedBox(width: 8),
          // Logged out: offer Login instead of a Logout that does nothing.
          if (CacheService.isLoggedIn)
            HomeCircleIconButton(
              icon: Icons.logout,
              onTap: () => _onLogout(context),
            )
          else
            HomeCircleIconButton(
              icon: Icons.login,
              onTap: AuthRedirect.toLogin,
            ),
        ],
      ),
    );
  }
}
