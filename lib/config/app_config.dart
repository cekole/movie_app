/// App-wide constants
abstract class AppConfig {
  static const String appName = 'Movie App';
  static const String favoritesKey = 'favorites_movies';

  // Display counts
  static const int forYouMoviesCount = 10;
  static const int categoryMoviesCount = 9;

  // Cache keys
  static const String cachedGenresKey = 'cached_genres';
  static const String cachedNowPlayingKey = 'cached_now_playing';
  static const String cachedPopularKey = 'cached_popular';
  static const String cachedTopRatedKey = 'cached_top_rated';
  static const String cachedUpcomingKey = 'cached_upcoming';
  static const String cachedMovieDetailsPrefix = 'cached_movie_detail_';
  static const String cacheTimestampKey = 'cache_timestamp';

  // Cache duration, 1 day as movies data can change frequently
  static const int cacheDurationHours = 24;
}
