import '../../../domain/models/models.dart';

/// API v2 Movie Model
///
/// Breaking changes from v1:
/// - `title` renamed to `name`
/// - `poster_path` moved to `media.poster.path`
/// - `backdrop_path` moved to `media.backdrop.path`
/// - `vote_average` moved to `ratings.score`
/// - `vote_count` moved to `ratings.count`
/// - `genre_ids` changed to `categories` with objects instead of IDs
/// - `release_date` moved to `metadata.release_date`
/// - `popularity` moved to `metadata.popularity_score`
/// - New nested structure for media assets
class MovieApiModelV2 {
  final int id;
  final String name; // was: title
  final MediaAssetsV2? media; // was: poster_path, backdrop_path at root
  final String description; // was: overview
  final RatingsV2 ratings; // was: vote_average, vote_count at root
  final List<CategoryV2> categories; // was: genre_ids (just int list)
  final MetadataV2 metadata; // was: release_date, popularity at root
  final bool isAdult; // was: adult
  final OriginalInfoV2 original; // was: original_language, original_title at root
  final bool hasVideo; // was: video

  const MovieApiModelV2({
    required this.id,
    required this.name,
    this.media,
    required this.description,
    required this.ratings,
    required this.categories,
    required this.metadata,
    required this.isAdult,
    required this.original,
    required this.hasVideo,
  });

  factory MovieApiModelV2.fromJson(Map<String, dynamic> json) {
    return MovieApiModelV2(
      id: json['id'] as int,
      name: json['name'] as String,
      media:
          json['media'] != null
              ? MediaAssetsV2.fromJson(json['media'] as Map<String, dynamic>)
              : null,
      description: json['description'] as String? ?? '',
      ratings: RatingsV2.fromJson(
        json['ratings'] as Map<String, dynamic>? ?? {},
      ),
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      metadata: MetadataV2.fromJson(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
      isAdult: json['is_adult'] as bool? ?? false,
      original: OriginalInfoV2.fromJson(
        json['original'] as Map<String, dynamic>? ?? {},
      ),
      hasVideo: json['has_video'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'media': media?.toJson(),
      'description': description,
      'ratings': ratings.toJson(),
      'categories': categories.map((e) => e.toJson()).toList(),
      'metadata': metadata.toJson(),
      'is_adult': isAdult,
      'original': original.toJson(),
      'has_video': hasVideo,
    };
  }

  /// Convert to domain model - THIS IS THE KEY MAPPING LAYER
  /// The domain model stays exactly the same, only the mapper changes
  Movie toDomain() {
    return Movie(
      id: id,
      title: name, // Map 'name' back to 'title'
      posterPath: media?.poster?.path, // Extract from nested structure
      backdropPath: media?.backdrop?.path, // Extract from nested structure
      overview: description, // Map 'description' to 'overview'
      voteAverage: ratings.score, // Extract from ratings object
      voteCount: ratings.count, // Extract from ratings object
      releaseDate: metadata.releaseDate, // Extract from metadata
      genreIds: categories.map((c) => c.id).toList(), // Extract IDs from objects
      popularity: metadata.popularityScore, // Extract from metadata
    );
  }

  /// Create from domain model (for caching/local storage)
  factory MovieApiModelV2.fromDomain(Movie movie) {
    return MovieApiModelV2(
      id: movie.id,
      name: movie.title,
      media: MediaAssetsV2(
        poster:
            movie.posterPath != null
                ? ImageAssetV2(path: movie.posterPath!)
                : null,
        backdrop:
            movie.backdropPath != null
                ? ImageAssetV2(path: movie.backdropPath!)
                : null,
      ),
      description: movie.overview,
      ratings: RatingsV2(
        score: movie.voteAverage,
        count: movie.voteCount,
      ),
      categories: movie.genreIds.map((id) => CategoryV2(id: id, name: '')).toList(),
      metadata: MetadataV2(
        releaseDate: movie.releaseDate,
        popularityScore: movie.popularity,
      ),
      isAdult: false,
      original: const OriginalInfoV2(language: '', title: ''),
      hasVideo: false,
    );
  }
}

/// Nested media assets structure (new in v2)
class MediaAssetsV2 {
  final ImageAssetV2? poster;
  final ImageAssetV2? backdrop;
  final ImageAssetV2? logo;

  const MediaAssetsV2({
    this.poster,
    this.backdrop,
    this.logo,
  });

  factory MediaAssetsV2.fromJson(Map<String, dynamic> json) {
    return MediaAssetsV2(
      poster:
          json['poster'] != null
              ? ImageAssetV2.fromJson(json['poster'] as Map<String, dynamic>)
              : null,
      backdrop:
          json['backdrop'] != null
              ? ImageAssetV2.fromJson(json['backdrop'] as Map<String, dynamic>)
              : null,
      logo:
          json['logo'] != null
              ? ImageAssetV2.fromJson(json['logo'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poster': poster?.toJson(),
      'backdrop': backdrop?.toJson(),
      'logo': logo?.toJson(),
    };
  }
}

/// Image asset with path and optional dimensions (new in v2)
class ImageAssetV2 {
  final String path;
  final int? width;
  final int? height;
  final String? aspectRatio;

  const ImageAssetV2({
    required this.path,
    this.width,
    this.height,
    this.aspectRatio,
  });

  factory ImageAssetV2.fromJson(Map<String, dynamic> json) {
    return ImageAssetV2(
      path: json['path'] as String,
      width: json['width'] as int?,
      height: json['height'] as int?,
      aspectRatio: json['aspect_ratio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'width': width,
      'height': height,
      'aspect_ratio': aspectRatio,
    };
  }
}

/// Ratings structure (new in v2, was flat fields)
class RatingsV2 {
  final double score; // was: vote_average
  final int count; // was: vote_count
  final String? source;

  const RatingsV2({
    required this.score,
    required this.count,
    this.source,
  });

  factory RatingsV2.fromJson(Map<String, dynamic> json) {
    return RatingsV2(
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] as int? ?? 0,
      source: json['source'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'count': count,
      'source': source,
    };
  }
}

/// Category (genre) with full object (new in v2, was just ID list)
class CategoryV2 {
  final int id;
  final String name;

  const CategoryV2({
    required this.id,
    required this.name,
  });

  factory CategoryV2.fromJson(Map<String, dynamic> json) {
    return CategoryV2(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

/// Metadata structure (new in v2, was flat fields)
class MetadataV2 {
  final String? releaseDate;
  final double popularityScore; // was: popularity
  final String? status;
  final String? language;

  const MetadataV2({
    this.releaseDate,
    required this.popularityScore,
    this.status,
    this.language,
  });

  factory MetadataV2.fromJson(Map<String, dynamic> json) {
    return MetadataV2(
      releaseDate: json['release_date'] as String?,
      popularityScore: (json['popularity_score'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String?,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'release_date': releaseDate,
      'popularity_score': popularityScore,
      'status': status,
      'language': language,
    };
  }
}

/// Original info structure (new in v2, was flat fields)
class OriginalInfoV2 {
  final String language; // was: original_language
  final String title; // was: original_title

  const OriginalInfoV2({
    required this.language,
    required this.title,
  });

  factory OriginalInfoV2.fromJson(Map<String, dynamic> json) {
    return OriginalInfoV2(
      language: json['language'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'title': title,
    };
  }
}
