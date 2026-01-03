import '../../domain/models/models.dart';
import '../model/model.dart';
import '../services/services.dart';

class MovieRepository {
  final MovieApiService _apiService = MovieApiService();
  final LocalStorageService _localService = LocalStorageService();
  final CacheService _cacheService = CacheService();

  // Remote Methods

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final response = await _apiService.getNowPlayingMovies(page: page);
    return response.results.map((m) => m.toDomain()).toList();
  }

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final response = await _apiService.getPopularMovies(page: page);
    return response.results.map((m) => m.toDomain()).toList();
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final response = await _apiService.getTopRatedMovies(page: page);
    return response.results.map((m) => m.toDomain()).toList();
  }

  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final response = await _apiService.getUpcomingMovies(page: page);
    return response.results.map((m) => m.toDomain()).toList();
  }

  Future<MovieDetail> getMovieDetails(int movieId) async {
    final response = await _apiService.getMovieDetails(movieId);
    return response.toDomain();
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final response = await _apiService.searchMovies(query, page: page);
    return response.results.map((m) => m.toDomain()).toList();
  }

  // Local Methods

  Future<List<Movie>> getFavorites() async {
    final favorites = await _localService.getFavorites();
    return favorites.map((m) => m.toDomain()).toList();
  }

  Future<void> addToFavorites(Movie movie) async {
    final apiModel = MovieApiModel.fromDomain(movie);
    await _localService.addFavorite(apiModel);
  }

  Future<void> removeFromFavorites(int movieId) async {
    await _localService.removeFavorite(movieId);
  }

  Future<bool> isFavorite(int movieId) async {
    return await _localService.isFavorite(movieId);
  }

  Future<bool> toggleFavorite(Movie movie) async {
    final isFav = await isFavorite(movie.id);
    if (isFav) {
      await removeFromFavorites(movie.id);
      return false;
    } else {
      await addToFavorites(movie);
      return true;
    }
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    await _localService.clearFavorites();
  }

  Future<List<Genre>> getGenres() async {
    final response = await _apiService.getGenres();
    return response.genres.map((g) => g.toDomain()).toList();
  }

  // Cache Methods

  CacheService get cacheService => _cacheService;

  Future<bool> isCacheValid() => _cacheService.isCacheValid();
  Future<bool> hasCache() => _cacheService.hasCache();

  Future<void> cacheGenres(List<Genre> genres) async {
    await _cacheService.cacheGenres(genres);
  }

  Future<List<Genre>?> getCachedGenres() async {
    return _cacheService.getCachedGenres();
  }

  Future<void> cacheNowPlayingMovies(List<Movie> movies) async {
    await _cacheService.cacheNowPlayingMovies(movies);
  }

  Future<List<Movie>?> getCachedNowPlayingMovies() async {
    return _cacheService.getCachedNowPlayingMovies();
  }

  Future<void> cachePopularMovies(List<Movie> movies) async {
    await _cacheService.cachePopularMovies(movies);
  }

  Future<List<Movie>?> getCachedPopularMovies() async {
    return _cacheService.getCachedPopularMovies();
  }

  Future<void> cacheTopRatedMovies(List<Movie> movies) async {
    await _cacheService.cacheTopRatedMovies(movies);
  }

  Future<List<Movie>?> getCachedTopRatedMovies() async {
    return _cacheService.getCachedTopRatedMovies();
  }

  Future<void> cacheUpcomingMovies(List<Movie> movies) async {
    await _cacheService.cacheUpcomingMovies(movies);
  }

  Future<List<Movie>?> getCachedUpcomingMovies() async {
    return _cacheService.getCachedUpcomingMovies();
  }

  Future<void> clearCache() async {
    await _cacheService.clearCache();
  }

  // Movie Detail Cache Methods

  Future<MovieDetail> getMovieDetailsWithCache(int movieId) async {
    // Check if already cached
    final cached = await _cacheService.getCachedMovieDetail(movieId);
    if (cached != null) {
      return cached;
    }

    final detail = await getMovieDetails(movieId);
    await _cacheService.cacheMovieDetail(detail);
    return detail;
  }

  Future<void> cacheMovieDetail(MovieDetail detail) async {
    await _cacheService.cacheMovieDetail(detail);
  }

  Future<MovieDetail?> getCachedMovieDetail(int movieId) async {
    return _cacheService.getCachedMovieDetail(movieId);
  }

  // User Preferences Methods

  Future<void> saveSelectedGenreIds(List<int> genreIds) async {
    await _localService.saveSelectedGenreIds(genreIds);
  }

  Future<List<int>> getSelectedGenreIds() async {
    return _localService.getSelectedGenreIds();
  }

  Future<void> saveSelectedMovieIds(List<int> movieIds) async {
    await _localService.saveSelectedMovieIds(movieIds);
  }

  Future<List<int>> getSelectedMovieIds() async {
    return _localService.getSelectedMovieIds();
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _localService.setOnboardingCompleted(completed);
  }

  Future<bool> isOnboardingCompleted() async {
    return _localService.isOnboardingCompleted();
  }
}
