import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/environment.dart';
import 'config/flavor_config.dart';
import 'routing/routing.dart';
import 'ui/core/themes/themes.dart';

/// Main entry point for Development flavor.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize flavor configuration for Dev
  FlavorConfig.initialize(Environment.dev);

  await dotenv.load(fileName: '.env.dev');

  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = FlavorConfig.instance;

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: config.isDev,
      theme: AppTheme.theme,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        if (!config.isProd) {
          return Banner(
            message: config.environment.displayName,
            location: BannerLocation.topStart,
            color: config.isDev ? Colors.green : Colors.orange,
            child: child ?? const SizedBox.shrink(),
          );
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
