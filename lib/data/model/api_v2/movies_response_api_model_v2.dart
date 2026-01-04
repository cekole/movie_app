import 'movie_api_model_v2.dart';

class MoviesResponseApiModelV2 {
  final String apiVersion;
  final List<MovieApiModelV2> items; // was: results
  final PaginationV2 pagination; // was: flat fields

  const MoviesResponseApiModelV2({
    required this.apiVersion,
    required this.items,
    required this.pagination,
  });

  factory MoviesResponseApiModelV2.fromJson(Map<String, dynamic> json) {
    return MoviesResponseApiModelV2(
      apiVersion: json['api_version'] as String? ?? '2.0',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => MovieApiModelV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationV2.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'api_version': apiVersion,
      'items': items.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  bool get hasMorePages => pagination.currentPage < pagination.totalPages;

  bool get isEmpty => items.isEmpty;

  int get page => pagination.currentPage;

  int get totalPages => pagination.totalPages;

  int get totalResults => pagination.totalItems;
}

class PaginationV2 {
  final int currentPage; // was: page
  final int totalPages; // was: total_pages
  final int totalItems; // was: total_results
  final int? itemsPerPage;

  const PaginationV2({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.itemsPerPage,
  });

  factory PaginationV2.fromJson(Map<String, dynamic> json) {
    return PaginationV2(
      currentPage: json['current_page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalItems: json['total_items'] as int? ?? 0,
      itemsPerPage: json['items_per_page'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_items': totalItems,
      'items_per_page': itemsPerPage,
    };
  }
}
