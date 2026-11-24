import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/crafty_bay_app.dart';
import 'data/service/cache/cache_service.dart';
import 'data/service/network/session_expired.dart';
import 'presentation/feature/auth/auth_redirect.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await CacheService.init();
  // Any authenticated request that gets a 401 sends the user to login.
  SessionExpired.onExpired = AuthRedirect.toLogin;
  runApp(const CraftyBayApp());
}
