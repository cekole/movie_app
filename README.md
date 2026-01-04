# Movie App

A Flutter movie application using TMDB API.

## Build Info

- **Version**: 0.1.0
- **Flutter SDK**: ^3.7.0
- **Min SDK**: Android 21 / iOS 12

## Build Flavors

```bash
# Dev (green icon)
flutter run --flavor dev -t lib/main_dev.dart

# Staging (orange icon)
flutter run --flavor staging -t lib/main_staging.dart

# Prod
flutter run --flavor prod -t lib/main_prod.dart
```

### Build Release
```bash
flutter build apk --flavor prod -t lib/main_prod.dart
flutter build ios --flavor prod -t lib/main_prod.dart
```

## Configuration

- API endpoints: `lib/config/flavor_config.dart`
- Environment secrets: `.env.dev`, `.env.staging`, `.env.prod`

## CI/CD Considerations

1. **Secrets**: Store API tokens in CI secrets, generate `.env.*` files at build time
2. **Parallel Builds**: Use build matrix for flavor parallelization
3. **Signing**: Store signing keys securely in CI/CD
4. **Distribution**: Dev → Firebase App Distribution, Staging → TestFlight/Internal Track, Prod → Stores
