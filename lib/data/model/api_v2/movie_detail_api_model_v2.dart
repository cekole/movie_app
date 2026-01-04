import '../../../domain/models/models.dart';
import 'movie_api_model_v2.dart';

class MovieDetailApiModelV2 {
  final int id;
  final String name; // was: title
  final MediaAssetsV2? media; // was: poster_path, backdrop_path at root
  final String description; // was: overview
  final RatingsV2 ratings; // was: vote_average, vote_count at root
  final List<CategoryV2> categories; // was: genres
  final MovieMetadataV2
  metadata; // was: release_date, popularity, runtime, tagline, status at root
  final FinancialsV2? financials; // was: budget, revenue at root
  final ExternalLinksV2? externalLinks; // was: homepage, imdb_id at root
  final bool isAdult; // was: adult
  final OriginalInfoV2
  original; // was: original_language, original_title at root
  final bool hasVideo; // was: video

  const MovieDetailApiModelV2({
    required this.id,
    required this.name,
    this.media,
    required this.description,
    required this.ratings,
    required this.categories,
    required this.metadata,
    this.financials,
    this.externalLinks,
    required this.isAdult,
    required this.original,
    required this.hasVideo,
  });

  factory MovieDetailApiModelV2.fromJson(Map<String, dynamic> json) {
    return MovieDetailApiModelV2(
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
      metadata: MovieMetadataV2.fromJson(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
      financials:
          json['financials'] != null
              ? FinancialsV2.fromJson(
                json['financials'] as Map<String, dynamic>,
              )
              : null,
      externalLinks:
          json['external_links'] != null
              ? ExternalLinksV2.fromJson(
                json['external_links'] as Map<String, dynamic>,
              )
              : null,
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
      'financials': financials?.toJson(),
      'external_links': externalLinks?.toJson(),
      'is_adult': isAdult,
      'original': original.toJson(),
      'has_video': hasVideo,
    };
  }

  MovieDetail toDomain() {
    return MovieDetail(
      id: id,
      title: name, // Map 'name' back to 'title'
      posterPath: media?.poster?.path, // Extract from nested structure
      backdropPath: media?.backdrop?.path, // Extract from nested structure
      overview: description, // Map 'description' to 'overview'
      voteAverage: ratings.score, // Extract from ratings object
      voteCount: ratings.count, // Extract from ratings object
      releaseDate: metadata.releaseDate, // Extract from metadata
      genres: categories.map((c) => Genre(id: c.id, name: c.name)).toList(),
      runtime: metadata.runtimeMinutes, // Extract from metadata
      tagline: metadata.tagline, // Extract from metadata
      status: metadata.status ?? '', // Extract from metadata
      budget: financials?.budget, // Extract from financials
      revenue: financials?.revenue, // Extract from financials
      homepage: externalLinks?.homepage, // Extract from external links
      imdbId: externalLinks?.imdbId, // Extract from external links
      popularity: metadata.popularityScore, // Extract from metadata
    );
  }

  factory MovieDetailApiModelV2.fromDomain(MovieDetail detail) {
    return MovieDetailApiModelV2(
      id: detail.id,
      name: detail.title,
      media: MediaAssetsV2(
        poster:
            detail.posterPath != null
                ? ImageAssetV2(path: detail.posterPath!)
                : null,
        backdrop:
            detail.backdropPath != null
                ? ImageAssetV2(path: detail.backdropPath!)
                : null,
      ),
      description: detail.overview,
      ratings: RatingsV2(score: detail.voteAverage, count: detail.voteCount),
      categories:
          detail.genres.map((g) => CategoryV2(id: g.id, name: g.name)).toList(),
      metadata: MovieMetadataV2(
        releaseDate: detail.releaseDate,
        popularityScore: detail.popularity,
        runtimeMinutes: detail.runtime,
        tagline: detail.tagline,
        status: detail.status,
      ),
      financials: FinancialsV2(budget: detail.budget, revenue: detail.revenue),
      externalLinks: ExternalLinksV2(
        homepage: detail.homepage,
        imdbId: detail.imdbId,
      ),
      isAdult: false,
      original: const OriginalInfoV2(language: '', title: ''),
      hasVideo: false,
    );
  }
}

class MovieMetadataV2 {
  final String? releaseDate;
  final double popularityScore; // was: popularity
  final int? runtimeMinutes; // was: runtime
  final String? tagline;
  final String? status;
  final String? language;

  const MovieMetadataV2({
    this.releaseDate,
    required this.popularityScore,
    this.runtimeMinutes,
    this.tagline,
    this.status,
    this.language,
  });

  factory MovieMetadataV2.fromJson(Map<String, dynamic> json) {
    return MovieMetadataV2(
      releaseDate: json['release_date'] as String?,
      popularityScore: (json['popularity_score'] as num?)?.toDouble() ?? 0.0,
      runtimeMinutes: json['runtime_minutes'] as int?,
      tagline: json['tagline'] as String?,
      status: json['status'] as String?,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'release_date': releaseDate,
      'popularity_score': popularityScore,
      'runtime_minutes': runtimeMinutes,
      'tagline': tagline,
      'status': status,
      'language': language,
    };
  }
}

class FinancialsV2 {
  final int? budget;
  final int? revenue;
  final String? currency;

  const FinancialsV2({this.budget, this.revenue, this.currency});

  factory FinancialsV2.fromJson(Map<String, dynamic> json) {
    return FinancialsV2(
      budget: json['budget'] as int?,
      revenue: json['revenue'] as int?,
      currency: json['currency'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'budget': budget, 'revenue': revenue, 'currency': currency};
  }
}

class ExternalLinksV2 {
  final String? homepage;
  final String? imdbId;
  final String? twitterHandle;
  final String? facebookPage;

  const ExternalLinksV2({
    this.homepage,
    this.imdbId,
    this.twitterHandle,
    this.facebookPage,
  });

  factory ExternalLinksV2.fromJson(Map<String, dynamic> json) {
    return ExternalLinksV2(
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
      twitterHandle: json['twitter_handle'] as String?,
      facebookPage: json['facebook_page'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'homepage': homepage,
      'imdb_id': imdbId,
      'twitter_handle': twitterHandle,
      'facebook_page': facebookPage,
    };
  }
}
