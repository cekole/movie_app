import 'genre.dart';

class MovieDetail {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String? releaseDate;
  final List<Genre> genres;
  final int? runtime;
  final String? tagline;
  final String status;
  final int? budget;
  final int? revenue;
  final String? homepage;
  final String? imdbId;
  final double popularity;

  const MovieDetail({
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
  });

  /// Get full poster URL
  String? get fullPosterPath {
    if (posterPath == null) return null;
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  /// Get full backdrop URL
  String? get fullBackdropPath {
    if (backdropPath == null) return null;
    return 'https://image.tmdb.org/t/p/w780$backdropPath';
  }

  /// Get formatted rating
  String get formattedRating => voteAverage.toStringAsFixed(1);

  /// Get release year
  String? get releaseYear {
    if (releaseDate == null || releaseDate!.isEmpty) return null;
    return releaseDate!.split('-').first;
  }

  /// Get formatted runtime (e.g., "2h 15m")
  String? get formattedRuntime {
    if (runtime == null || runtime == 0) return null;
    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Get comma-separated genre names
  String get genreNames => genres.map((g) => g.name).join(', ');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDetail &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'MovieDetail(id: $id, title: $title)';
}
