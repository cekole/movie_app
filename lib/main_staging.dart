import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/environment.dart';
import 'config/flavor_config.dart';
import 'routing/routing.dart';
import 'ui/core/themes/themes.dart';

/// Main entry point for Staging flavor.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize flavor configuration for Staging
  FlavorConfig.initialize(Environment.staging);

  await dotenv.load(fileName: '.env.staging');

  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = FlavorConfig.instance;

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        if (!config.isProd) {
          return Banner(
            message: config.environment.displayName,
            location: BannerLocation.topStart,
            color: Colors.orange,
            child: child ?? const SizedBox.shrink(),
          );
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
