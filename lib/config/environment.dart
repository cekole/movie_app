/// Defines the available application environments/flavors.
enum Environment { dev, staging, prod }

/// Extension to provide human-readable names for environments.
extension EnvironmentExtension on Environment {
  String get displayName {
    switch (this) {
      case Environment.dev:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.prod:
        return 'Production';
    }
  }

  String get suffix {
    switch (this) {
      case Environment.dev:
        return '.dev';
      case Environment.staging:
        return '.staging';
      case Environment.prod:
        return '';
    }
  }
}
