import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart';
import '../../domain/models/models.dart';
import '../model/model.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();

  factory CacheService() => _instance;

  CacheService._internal();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<bool> isCacheValid() async {
    final preferences = await prefs;
    final timestamp = preferences.getInt(AppConfig.cacheTimestampKey);

    if (timestamp == null) return false;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cacheTime);

    return difference.inHours < AppConfig.cacheDurationHours;
  }

  Future<void> _updateTimestamp() async {
    final preferences = await prefs;
    await preferences.setInt(
      AppConfig.cacheTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Genre caching methods

  Future<void> cacheGenres(List<Genre> genres) async {
    final preferences = await prefs;
    final genresJson =
        genres
            .map((g) => jsonEncode(GenreApiModel.fromDomain(g).toJson()))
            .toList();
    await preferences.setStringList(AppConfig.cachedGenresKey, genresJson);
    await _updateTimestamp();
  }

  Future<List<Genre>?> getCachedGenres() async {
    final preferences = await prefs;
    final genresJson = preferences.getStringList(AppConfig.cachedGenresKey);

    if (genresJson == null || genresJson.isEmpty) return null;

    return genresJson
        .map(
          (json) =>
              GenreApiModel.fromJson(
                jsonDecode(json) as Map<String, dynamic>,
              ).toDomain(),
        )
        .toList();
  }

  // Movie caching methods

  Future<void> cacheMovies(String key, List<Movie> movies) async {
    final preferences = await prefs;
    final moviesJson =
        movies
            .map((m) => jsonEncode(MovieApiModel.fromDomain(m).toJson()))
            .toList();
    await preferences.setStringList(key, moviesJson);
    await _updateTimestamp();
  }

  Future<List<Movie>?> getCachedMovies(String key) async {
    final preferences = await prefs;
    final moviesJson = preferences.getStringList(key);

    if (moviesJson == null || moviesJson.isEmpty) return null;

    return moviesJson
        .map(
          (json) =>
              MovieApiModel.fromJson(
                jsonDecode(json) as Map<String, dynamic>,
              ).toDomain(),
        )
        .toList();
  }

  Future<void> cacheNowPlayingMovies(List<Movie> movies) async {
    await cacheMovies(AppConfig.cachedNowPlayingKey, movies);
  }

  Future<List<Movie>?> getCachedNowPlayingMovies() async {
    return getCachedMovies(AppConfig.cachedNowPlayingKey);
  }

  Future<void> cachePopularMovies(List<Movie> movies) async {
    await cacheMovies(AppConfig.cachedPopularKey, movies);
  }

  Future<List<Movie>?> getCachedPopularMovies() async {
    return getCachedMovies(AppConfig.cachedPopularKey);
  }

  Future<void> cacheTopRatedMovies(List<Movie> movies) async {
    await cacheMovies(AppConfig.cachedTopRatedKey, movies);
  }

  Future<List<Movie>?> getCachedTopRatedMovies() async {
    return getCachedMovies(AppConfig.cachedTopRatedKey);
  }

  Future<void> cacheUpcomingMovies(List<Movie> movies) async {
    await cacheMovies(AppConfig.cachedUpcomingKey, movies);
  }

  Future<List<Movie>?> getCachedUpcomingMovies() async {
    return getCachedMovies(AppConfig.cachedUpcomingKey);
  }

  Future<void> clearCache() async {
    final preferences = await prefs;
    await preferences.remove(AppConfig.cachedGenresKey);
    await preferences.remove(AppConfig.cachedNowPlayingKey);
    await preferences.remove(AppConfig.cachedPopularKey);
    await preferences.remove(AppConfig.cachedTopRatedKey);
    await preferences.remove(AppConfig.cachedUpcomingKey);
    await preferences.remove(AppConfig.cacheTimestampKey);
  }

  Future<bool> hasCache() async {
    final genres = await getCachedGenres();
    final nowPlaying = await getCachedNowPlayingMovies();
    return genres != null && nowPlaying != null;
  }

  // Movie detail caching methods

  Future<void> cacheMovieDetail(MovieDetail detail) async {
    final preferences = await prefs;
    final key = '${AppConfig.cachedMovieDetailsPrefix}${detail.id}';
    final json = jsonEncode(MovieDetailApiModel.fromDomain(detail).toJson());
    await preferences.setString(key, json);
  }

  Future<MovieDetail?> getCachedMovieDetail(int movieId) async {
    final preferences = await prefs;
    final key = '${AppConfig.cachedMovieDetailsPrefix}$movieId';
    final json = preferences.getString(key);

    if (json == null) return null;

    return MovieDetailApiModel.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    ).toDomain();
  }

  Future<bool> hasMovieDetailCached(int movieId) async {
    final preferences = await prefs;
    final key = '${AppConfig.cachedMovieDetailsPrefix}$movieId';
    return preferences.containsKey(key);
  }
}
