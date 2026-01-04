import '../../domain/models/models.dart';
import '../model/model.dart';

enum ApiVersion { v1, v2 }

class MovieApiVersionAdapter {
  static ApiVersion currentVersion = ApiVersion.v2;

  static List<Movie> parseMoviesResponse(Map<String, dynamic> json) {
    // Detect API version from response
    final version = _detectApiVersion(json);

    switch (version) {
      case ApiVersion.v1:
        final response = MoviesResponseApiModel.fromJson(json);
        return response.results.map((m) => m.toDomain()).toList();
      case ApiVersion.v2:
        final response = MoviesResponseApiModelV2.fromJson(json);
        return response.items.map((m) => m.toDomain()).toList();
    }
  }

  static MovieDetail parseMovieDetailResponse(Map<String, dynamic> json) {
    final version = _detectApiVersion(json);

    switch (version) {
      case ApiVersion.v1:
        final response = MovieDetailApiModel.fromJson(json);
        return response.toDomain();
      case ApiVersion.v2:
        final response = MovieDetailApiModelV2.fromJson(json);
        return response.toDomain();
    }
  }

  static Movie parseMovie(Map<String, dynamic> json) {
    final version = _detectApiVersion(json);

    switch (version) {
      case ApiVersion.v1:
        return MovieApiModel.fromJson(json).toDomain();
      case ApiVersion.v2:
        return MovieApiModelV2.fromJson(json).toDomain();
    }
  }

  static ApiVersion _detectApiVersion(Map<String, dynamic> json) {
    // V2 indicators:
    // - Has 'api_version' field
    // - Has 'items' instead of 'results'
    // - Has 'name' instead of 'title'
    // - Has nested 'media' object

    if (json.containsKey('api_version')) {
      return ApiVersion.v2;
    }

    if (json.containsKey('items') && !json.containsKey('results')) {
      return ApiVersion.v2;
    }

    if (json.containsKey('name') && !json.containsKey('title')) {
      return ApiVersion.v2;
    }

    if (json.containsKey('media') && json['media'] is Map) {
      return ApiVersion.v2;
    }

    if (json.containsKey('pagination') && json['pagination'] is Map) {
      return ApiVersion.v2;
    }

    return ApiVersion.v1;
  }

  static PaginationInfo getPaginationInfo(Map<String, dynamic> json) {
    final version = _detectApiVersion(json);

    switch (version) {
      case ApiVersion.v1:
        final response = MoviesResponseApiModel.fromJson(json);
        return PaginationInfo(
          currentPage: response.page,
          totalPages: response.totalPages,
          totalResults: response.totalResults,
          hasMorePages: response.hasMorePages,
        );
      case ApiVersion.v2:
        final response = MoviesResponseApiModelV2.fromJson(json);
        return PaginationInfo(
          currentPage: response.page,
          totalPages: response.totalPages,
          totalResults: response.totalResults,
          hasMorePages: response.hasMorePages,
        );
    }
  }
}

class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int totalResults;
  final bool hasMorePages;

  const PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalResults,
    required this.hasMorePages,
  });
}
