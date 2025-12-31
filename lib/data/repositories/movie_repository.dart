import '../../domain/models/models.dart';
import '../model/model.dart';
import '../services/services.dart';

class MovieRepository {
  final MovieApiService _apiService = MovieApiService();
  final LocalStorageService _localService = LocalStorageService();

  // Remote Methods

  /// Fetch now playing movies
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final response = await _apiService.getNowPlayingMovies(page: page);
    return response.results.map((m) => m.toDomain()).toList();
  }

  /// Fetch popular movies
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final response = await _apiService.getPopularMovies(page: page);
    return response.results.map((m) => m.toDomain()).toList();
  }

  /// Fetch top rated movies
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final response = await _apiService.getTopRatedMovies(page: page);
    return response.results.map((m) => m.toDomain()).toList();
  }

  /// Fetch upcoming movies
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final response = await _apiService.getUpcomingMovies(page: page);
    return response.results.map((m) => m.toDomain()).toList();
  }

  /// Fetch movie details by ID
  Future<MovieDetail> getMovieDetails(int movieId) async {
    final response = await _apiService.getMovieDetails(movieId);
    return response.toDomain();
  }

  /// Search movies by query
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final response = await _apiService.searchMovies(query, page: page);
    return response.results.map((m) => m.toDomain()).toList();
  }

  // Local Methods

  /// Get all favorite movies
  Future<List<Movie>> getFavorites() async {
    final favorites = await _localService.getFavorites();
    return favorites.map((m) => m.toDomain()).toList();
  }

  /// Add movie to favorites
  Future<void> addToFavorites(Movie movie) async {
    final apiModel = MovieApiModel.fromDomain(movie);
    await _localService.addFavorite(apiModel);
  }

  /// Remove movie from favorites
  Future<void> removeFromFavorites(int movieId) async {
    await _localService.removeFavorite(movieId);
  }

  /// Check if movie is in favorites
  Future<bool> isFavorite(int movieId) async {
    return await _localService.isFavorite(movieId);
  }

  /// Toggle favorite status, returns new status
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
}
