import 'package:crafty_bay/core/app_navigator.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/presentation/feature/splash/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_providers.dart';
import 'app_theme.dart';

/// The root widget: wires providers, theme and the first screen together.
class CraftyBayApp extends StatelessWidget {
  const CraftyBayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.all,
      child: MaterialApp(
        navigatorKey: AppNavigator.key,
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        // The app's colors are light-only; never switch to a dark theme.
        themeMode: ThemeMode.light,
        theme: AppTheme.light,
        home: const SplashPage(),
      ),
    );
  }
}
