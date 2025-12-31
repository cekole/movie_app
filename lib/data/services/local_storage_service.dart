import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart';
import '../model/model.dart';

/// Service for local storage operations (favorites)
class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Get all favorite movies
  Future<List<MovieApiModel>> getFavorites() async {
    final preferences = await prefs;
    final favoritesJson =
        preferences.getStringList(AppConfig.favoritesKey) ?? [];

    return favoritesJson
        .map(
          (json) =>
              MovieApiModel.fromJson(jsonDecode(json) as Map<String, dynamic>),
        )
        .toList();
  }

  /// Add a movie to favorites
  Future<void> addFavorite(MovieApiModel movie) async {
    final preferences = await prefs;
    final favorites = await getFavorites();

    if (favorites.any((m) => m.id == movie.id)) {
      return;
    }

    final favoritesJson =
        preferences.getStringList(AppConfig.favoritesKey) ?? [];
    favoritesJson.add(jsonEncode(movie.toJson()));
    await preferences.setStringList(AppConfig.favoritesKey, favoritesJson);
  }

  /// Remove a movie from favorites
  Future<void> removeFavorite(int movieId) async {
    final preferences = await prefs;
    final favorites = await getFavorites();

    favorites.removeWhere((movie) => movie.id == movieId);

    final favoritesJson = favorites.map((m) => jsonEncode(m.toJson())).toList();
    await preferences.setStringList(AppConfig.favoritesKey, favoritesJson);
  }

  /// Check if a movie is in favorites
  Future<bool> isFavorite(int movieId) async {
    final favorites = await getFavorites();
    return favorites.any((movie) => movie.id == movieId);
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    final preferences = await prefs;
    await preferences.remove(AppConfig.favoritesKey);
  }
}
