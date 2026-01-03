/// App-wide constants
abstract class AppConfig {
  static const String appName = 'Movie App';
  static const String favoritesKey = 'favorites_movies';

  // Display counts
  static const int forYouMoviesCount = 9;
  static const int categoryMoviesCount = 9;

  // Cache keys
  static const String cachedGenresKey = 'cached_genres';
  static const String cachedNowPlayingKey = 'cached_now_playing';
  static const String cachedPopularKey = 'cached_popular';
  static const String cachedTopRatedKey = 'cached_top_rated';
  static const String cachedUpcomingKey = 'cached_upcoming';
  static const String cachedMovieDetailsPrefix = 'cached_movie_detail_';
  static const String cacheTimestampKey = 'cache_timestamp';

  // User preference keys
  static const String selectedGenreIdsKey = 'selected_genre_ids';
  static const String selectedMovieIdsKey = 'selected_movie_ids';
  static const String onboardingCompletedKey = 'onboarding_completed';

  // Cache duration, 1 day as movies data can change frequently
  static const int cacheDurationHours = 24;
}
