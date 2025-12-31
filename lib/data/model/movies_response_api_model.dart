import 'movie_api_model.dart';

class MoviesResponseApiModel {
  final int page;
  final List<MovieApiModel> results;
  final int totalPages;
  final int totalResults;

  const MoviesResponseApiModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResponseApiModel.fromJson(Map<String, dynamic> json) {
    return MoviesResponseApiModel(
      page: json['page'] as int,
      results:
          (json['results'] as List<dynamic>)
              .map((e) => MovieApiModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );
  }

  /// Check if there are more pages
  bool get hasMorePages => page < totalPages;

  /// Check if results are empty
  bool get isEmpty => results.isEmpty;
}
