import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/environment.dart';
import 'config/flavor_config.dart';
import 'routing/routing.dart';
import 'ui/core/themes/themes.dart';

/// Main entry point for Production flavor.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize flavor configuration for Production
  FlavorConfig.initialize(Environment.prod);

  await dotenv.load(fileName: '.env.prod');

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
    );
  }
}
