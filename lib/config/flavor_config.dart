import 'environment.dart';

class FlavorConfig {
  final Environment environment;
  final String appName;
  final String apiBaseUrl;
  final String imageBaseUrl;
  final bool enableLogging;
  final bool enableCrashlytics;
  final bool enableAnalytics;

  static FlavorConfig? _instance;

  FlavorConfig._internal({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.imageBaseUrl,
    required this.enableLogging,
    required this.enableCrashlytics,
    required this.enableAnalytics,
  });

  static FlavorConfig get instance {
    if (_instance == null) {
      throw StateError(
        'FlavorConfig has not been initialized. '
        'Call FlavorConfig.initialize() first.',
      );
    }
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  static void initialize(Environment environment) {
    _instance = _getConfigForEnvironment(environment);
  }

  static FlavorConfig _getConfigForEnvironment(Environment environment) {
    switch (environment) {
      case Environment.dev:
        return FlavorConfig._internal(
          environment: Environment.dev,
          appName: 'Movie App Dev',
          // Dev API - can point to local server or dev backend
          apiBaseUrl: 'https://api.themoviedb.org/3',
          imageBaseUrl: 'https://image.tmdb.org/t/p',
          enableLogging: true,
          enableCrashlytics: false,
          enableAnalytics: false,
        );
      case Environment.staging:
        return FlavorConfig._internal(
          environment: Environment.staging,
          appName: 'Movie App Staging',
          // Staging API - points to staging backend
          apiBaseUrl: 'https://api.themoviedb.org/3',
          imageBaseUrl: 'https://image.tmdb.org/t/p',
          enableLogging: true,
          enableCrashlytics: true,
          enableAnalytics: false,
        );
      case Environment.prod:
        return FlavorConfig._internal(
          environment: Environment.prod,
          appName: 'Movie App',
          // Production API - points to production backend
          apiBaseUrl: 'https://api.themoviedb.org/3',
          imageBaseUrl: 'https://image.tmdb.org/t/p',
          enableLogging: false,
          enableCrashlytics: true,
          enableAnalytics: true,
        );
    }
  }

  /// Returns true if the app is running in development mode.
  bool get isDev => environment == Environment.dev;

  /// Returns true if the app is running in staging mode.
  bool get isStaging => environment == Environment.staging;

  /// Returns true if the app is running in production mode.
  bool get isProd => environment == Environment.prod;
}
