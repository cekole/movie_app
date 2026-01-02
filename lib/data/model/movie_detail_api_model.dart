import '../../domain/models/models.dart';
import 'genre_api_model.dart';

class MovieDetailApiModel {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String? releaseDate;
  final List<GenreApiModel> genres;
  final int? runtime;
  final String? tagline;
  final String status;
  final int? budget;
  final int? revenue;
  final String? homepage;
  final String? imdbId;
  final double popularity;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final bool video;

  const MovieDetailApiModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    this.releaseDate,
    required this.genres,
    this.runtime,
    this.tagline,
    required this.status,
    this.budget,
    this.revenue,
    this.homepage,
    this.imdbId,
    required this.popularity,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.video,
  });

  factory MovieDetailApiModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailApiModel(
      id: json['id'] as int,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String? ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
      releaseDate: json['release_date'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreApiModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      runtime: json['runtime'] as int?,
      tagline: json['tagline'] as String?,
      status: json['status'] as String? ?? '',
      budget: json['budget'] as int?,
      revenue: json['revenue'] as int?,
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
      popularity: (json['popularity'] as num).toDouble(),
      adult: json['adult'] as bool? ?? false,
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      video: json['video'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'overview': overview,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'genres': genres.map((e) => e.toJson()).toList(),
      'runtime': runtime,
      'tagline': tagline,
      'status': status,
      'budget': budget,
      'revenue': revenue,
      'homepage': homepage,
      'imdb_id': imdbId,
      'popularity': popularity,
      'adult': adult,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'video': video,
    };
  }

  /// Convert to domain model
  MovieDetail toDomain() {
    return MovieDetail(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      overview: overview,
      voteAverage: voteAverage,
      voteCount: voteCount,
      releaseDate: releaseDate,
      genres: genres.map((g) => g.toDomain()).toList(),
      runtime: runtime,
      tagline: tagline,
      status: status,
      budget: budget,
      revenue: revenue,
      homepage: homepage,
      imdbId: imdbId,
      popularity: popularity,
    );
  }

  /// Create from domain model
  factory MovieDetailApiModel.fromDomain(MovieDetail detail) {
    return MovieDetailApiModel(
      id: detail.id,
      title: detail.title,
      posterPath: detail.posterPath,
      backdropPath: detail.backdropPath,
      overview: detail.overview,
      voteAverage: detail.voteAverage,
      voteCount: detail.voteCount,
      releaseDate: detail.releaseDate,
      genres: detail.genres.map((g) => GenreApiModel.fromDomain(g)).toList(),
      runtime: detail.runtime,
      tagline: detail.tagline,
      status: detail.status,
      budget: detail.budget,
      revenue: detail.revenue,
      homepage: detail.homepage,
      imdbId: detail.imdbId,
      popularity: detail.popularity,
      adult: false,
      originalLanguage: '',
      originalTitle: detail.title,
      video: false,
    );
  }
}
