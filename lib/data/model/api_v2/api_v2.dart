/// API v2 Models barrel file
///
/// These models handle the "breaking change" scenario where
/// the API response structure changes significantly.
///
/// Key changes in API v2:
/// - Field names changed (title -> name, overview -> description)
/// - Nested structures introduced (media.poster.path instead of poster_path)
/// - New pagination structure
/// - Genre IDs now include full category objects
///
/// The mapping layer (toDomain/fromDomain) handles all transformations,
/// keeping the domain models and UI completely unchanged.
library;

export 'movie_api_model_v2.dart';
export 'movie_detail_api_model_v2.dart';
export 'movies_response_api_model_v2.dart';
