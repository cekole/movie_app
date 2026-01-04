import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'flavor_config.dart';

/// API configuration constants
abstract class ApiConfig {
  /// Base URL for API calls - injected from flavor configuration.
  static String get baseUrl =>
      FlavorConfig.isInitialized
          ? FlavorConfig.instance.apiBaseUrl
          : 'https://api.themoviedb.org/3';

  /// Base URL for images - injected from flavor configuration.
  static String get imageBaseUrl =>
      FlavorConfig.isInitialized
          ? FlavorConfig.instance.imageBaseUrl
          : 'https://image.tmdb.org/t/p';

  // TMDB API Read Access Token (loaded from .env file)
  static String get accessToken => dotenv.env['TMDB_ACCESS_TOKEN'] ?? '';

  // Default language
  static const String defaultLanguage = 'en-US';

  // Image sizes
  static const String posterSizeW185 = '/w185';
  static const String posterSizeW500 = '/w500';
  static const String posterSizeOriginal = '/original';
  static const String backdropSizeW780 = '/w780';
  static const String backdropSizeOriginal = '/original';

  // Endpoints
  static const String nowPlayingEndpoint = '/movie/now_playing';
  static const String popularEndpoint = '/movie/popular';
  static const String topRatedEndpoint = '/movie/top_rated';
  static const String upcomingEndpoint = '/movie/upcoming';
  static const String movieDetailsEndpoint = '/movie';
  static const String searchEndpoint = '/search/movie';
  static const String genresEndpoint = '/genre/movie/list';
}
