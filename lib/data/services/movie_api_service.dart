import 'package:dio/dio.dart';

import '../../config/api_config.dart';
import '../model/model.dart';

/// Service class for TMDB API calls
class MovieApiService {
  static final MovieApiService _instance = MovieApiService._internal();

  factory MovieApiService() => _instance;

  MovieApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${ApiConfig.accessToken}',
        },
      ),
    );
  }

  late final Dio _dio;

  /// Fetch now playing movies
  Future<MoviesResponseApiModel> getNowPlayingMovies({int page = 1}) async {
    final response = await _dio.get(
      ApiConfig.nowPlayingEndpoint,
      queryParameters: {'language': ApiConfig.defaultLanguage, 'page': page},
    );
    return MoviesResponseApiModel.fromJson(response.data);
  }

  /// Fetch popular movies
  Future<MoviesResponseApiModel> getPopularMovies({int page = 1}) async {
    final response = await _dio.get(
      ApiConfig.popularEndpoint,
      queryParameters: {'language': ApiConfig.defaultLanguage, 'page': page},
    );
    return MoviesResponseApiModel.fromJson(response.data);
  }

  /// Fetch top rated movies
  Future<MoviesResponseApiModel> getTopRatedMovies({int page = 1}) async {
    final response = await _dio.get(
      ApiConfig.topRatedEndpoint,
      queryParameters: {'language': ApiConfig.defaultLanguage, 'page': page},
    );
    return MoviesResponseApiModel.fromJson(response.data);
  }

  /// Fetch upcoming movies
  Future<MoviesResponseApiModel> getUpcomingMovies({int page = 1}) async {
    final response = await _dio.get(
      ApiConfig.upcomingEndpoint,
      queryParameters: {'language': ApiConfig.defaultLanguage, 'page': page},
    );
    return MoviesResponseApiModel.fromJson(response.data);
  }

  /// Fetch movie details
  Future<MovieDetailApiModel> getMovieDetails(int movieId) async {
    final response = await _dio.get(
      '${ApiConfig.movieDetailsEndpoint}/$movieId',
      queryParameters: {'language': ApiConfig.defaultLanguage},
    );
    return MovieDetailApiModel.fromJson(response.data);
  }

  /// Search movies
  Future<MoviesResponseApiModel> searchMovies(
    String query, {
    int page = 1,
  }) async {
    final response = await _dio.get(
      ApiConfig.searchEndpoint,
      queryParameters: {
        'query': query,
        'language': ApiConfig.defaultLanguage,
        'page': page,
      },
    );
    return MoviesResponseApiModel.fromJson(response.data);
  }
}
