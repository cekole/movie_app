import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/data/mappers/movie_api_version_adapter.dart';
import 'package:movie_app/data/model/api_v2/api_v2.dart';
import 'package:movie_app/data/model/model.dart';
import 'package:movie_app/domain/models/models.dart';

import 'mock_api_v2_data.dart';

/// Unit tests for API v2 mapping
void main() {
  group('MovieApiModelV2', () {
    test('should parse v2 JSON correctly', () {
      // Arrange
      final json = MockApiV2Data.singleMovieV2;

      // Act
      final model = MovieApiModelV2.fromJson(json);

      // Assert
      expect(model.id, 123);
      expect(model.name, 'The Great Adventure'); // Note: 'name' not 'title'
      expect(model.description, 'An epic journey through unknown lands.');
      expect(model.media?.poster?.path, '/poster123.jpg');
      expect(model.media?.backdrop?.path, '/backdrop123.jpg');
      expect(model.ratings.score, 8.5);
      expect(model.ratings.count, 1500);
      expect(model.categories.length, 3);
      expect(model.categories[0].id, 28);
      expect(model.categories[0].name, 'Action');
      expect(model.metadata.releaseDate, '2025-03-15');
      expect(model.metadata.popularityScore, 250.75);
      expect(model.isAdult, false);
      expect(model.hasVideo, true);
    });

    test('should convert v2 model to domain model correctly', () {
      // Arrange
      final json = MockApiV2Data.singleMovieV2;
      final apiModel = MovieApiModelV2.fromJson(json);

      // Act
      final domainModel = apiModel.toDomain();

      // Assert - Domain model uses original field names!
      expect(domainModel.id, 123);
      expect(domainModel.title, 'The Great Adventure'); // Mapped from 'name'
      expect(
        domainModel.overview,
        'An epic journey through unknown lands.',
      ); // Mapped from 'description'
      expect(
        domainModel.posterPath,
        '/poster123.jpg',
      ); // Extracted from nested media
      expect(
        domainModel.backdropPath,
        '/backdrop123.jpg',
      ); // Extracted from nested media
      expect(domainModel.voteAverage, 8.5); // Extracted from ratings object
      expect(domainModel.voteCount, 1500); // Extracted from ratings object
      expect(domainModel.releaseDate, '2025-03-15'); // Extracted from metadata
      expect(domainModel.genreIds, [
        28,
        12,
        14,
      ]); // Extracted IDs from category objects
      expect(domainModel.popularity, 250.75); // Extracted from metadata
    });

    test('should handle missing optional fields in v2', () {
      // Arrange
      final json = <String, dynamic>{
        'id': 999,
        'name': 'Minimal Movie',
        'description': 'A minimal movie',
        'ratings': {'score': 5.0, 'count': 100},
        'categories': <dynamic>[],
        'metadata': {'popularity_score': 50.0},
        'is_adult': false,
        'original': {'language': 'en', 'title': 'Minimal Movie'},
        'has_video': false,
        // media is null
      };

      // Act
      final model = MovieApiModelV2.fromJson(json);
      final domainModel = model.toDomain();

      // Assert
      expect(domainModel.id, 999);
      expect(domainModel.title, 'Minimal Movie');
      expect(domainModel.posterPath, isNull);
      expect(domainModel.backdropPath, isNull);
      expect(domainModel.genreIds, isEmpty);
    });

    test('should serialize to JSON correctly', () {
      // Arrange
      final json = MockApiV2Data.singleMovieV2;
      final model = MovieApiModelV2.fromJson(json);

      // Act
      final serialized = model.toJson();

      // Assert
      expect(serialized['id'], 123);
      expect(serialized['name'], 'The Great Adventure');
      expect(serialized['media']['poster']['path'], '/poster123.jpg');
    });

    test('should create v2 model from domain model', () {
      // Arrange
      const domainModel = Movie(
        id: 789,
        title: 'Test Movie',
        posterPath: '/test_poster.jpg',
        backdropPath: '/test_backdrop.jpg',
        overview: 'Test overview',
        voteAverage: 7.5,
        voteCount: 500,
        releaseDate: '2025-01-01',
        genreIds: [1, 2, 3],
        popularity: 100.0,
      );

      // Act
      final apiModel = MovieApiModelV2.fromDomain(domainModel);

      // Assert
      expect(apiModel.id, 789);
      expect(apiModel.name, 'Test Movie');
      expect(apiModel.media?.poster?.path, '/test_poster.jpg');
      expect(apiModel.ratings.score, 7.5);
      expect(apiModel.categories.length, 3);
    });
  });

  group('MoviesResponseApiModelV2', () {
    test('should parse v2 response correctly', () {
      // Arrange
      final json = MockApiV2Data.moviesResponseV2;

      // Act
      final response = MoviesResponseApiModelV2.fromJson(json);

      // Assert
      expect(response.apiVersion, '2.0');
      expect(response.items.length, 2);
      expect(response.pagination.currentPage, 1);
      expect(response.pagination.totalPages, 10);
      expect(response.pagination.totalItems, 200);

      // Verify v1-compatible getters
      expect(response.page, 1);
      expect(response.totalPages, 10);
      expect(response.totalResults, 200);
      expect(response.hasMorePages, true);
    });

    test('should convert all items to domain models', () {
      // Arrange
      final json = MockApiV2Data.moviesResponseV2;
      final response = MoviesResponseApiModelV2.fromJson(json);

      // Act
      final movies = response.items.map((m) => m.toDomain()).toList();

      // Assert
      expect(movies.length, 2);
      expect(movies[0].title, 'The Great Adventure');
      expect(movies[1].title, 'Another Great Movie');
      expect(movies[0].voteAverage, 8.5);
      expect(movies[1].voteAverage, 7.5);
    });
  });

  group('MovieDetailApiModelV2', () {
    test('should parse v2 detail correctly', () {
      // Arrange
      final json = MockApiV2Data.movieDetailV2;

      // Act
      final model = MovieDetailApiModelV2.fromJson(json);

      // Assert
      expect(model.id, 123);
      expect(model.name, 'The Great Adventure');
      expect(model.metadata.runtimeMinutes, 142);
      expect(model.metadata.tagline, 'The journey of a lifetime');
      expect(model.financials?.budget, 150000000);
      expect(model.financials?.revenue, 750000000);
      expect(
        model.externalLinks?.homepage,
        'https://www.thegreatadventure.com',
      );
      expect(model.externalLinks?.imdbId, 'tt1234567');
    });

    test('should convert v2 detail to domain model correctly', () {
      // Arrange
      final json = MockApiV2Data.movieDetailV2;
      final apiModel = MovieDetailApiModelV2.fromJson(json);

      // Act
      final domainModel = apiModel.toDomain();

      // Assert
      expect(domainModel.id, 123);
      expect(domainModel.title, 'The Great Adventure');
      expect(domainModel.overview, contains('epic journey'));
      expect(domainModel.runtime, 142);
      expect(domainModel.tagline, 'The journey of a lifetime');
      expect(domainModel.budget, 150000000);
      expect(domainModel.revenue, 750000000);
      expect(domainModel.homepage, 'https://www.thegreatadventure.com');
      expect(domainModel.imdbId, 'tt1234567');
      expect(domainModel.genres.length, 3);
      expect(domainModel.genres[0].name, 'Action');
    });
  });

  group('MovieApiVersionAdapter', () {
    test('should detect v1 API format', () {
      // Arrange
      final json = MockApiV2Data.moviesResponseV1;

      // Act
      final movies = MovieApiVersionAdapter.parseMoviesResponse(json);

      // Assert
      expect(movies.length, 1);
      expect(movies[0].title, 'The Great Adventure');
    });

    test('should detect v2 API format', () {
      // Arrange
      final json = MockApiV2Data.moviesResponseV2;

      // Act
      final movies = MovieApiVersionAdapter.parseMoviesResponse(json);

      // Assert
      expect(movies.length, 2);
      expect(movies[0].title, 'The Great Adventure');
    });

    test('should parse movie detail from v1 format', () {
      // Arrange
      final json = MockApiV2Data.movieDetailV1;

      // Act
      final detail = MovieApiVersionAdapter.parseMovieDetailResponse(json);

      // Assert
      expect(detail.id, 123);
      expect(detail.title, 'The Great Adventure');
      expect(detail.runtime, 142);
    });

    test('should parse movie detail from v2 format', () {
      // Arrange
      final json = MockApiV2Data.movieDetailV2;

      // Act
      final detail = MovieApiVersionAdapter.parseMovieDetailResponse(json);

      // Assert
      expect(detail.id, 123);
      expect(detail.title, 'The Great Adventure');
      expect(detail.runtime, 142);
    });

    test('both v1 and v2 should produce identical domain models', () {
      // This is the KEY test demonstrating Clean Architecture benefits!
      // Despite completely different API structures, the domain models are identical.

      // Arrange
      final v1Json = MockApiV2Data.singleMovieV1;
      final v2Json = MockApiV2Data.singleMovieV2;

      // Act
      final movieFromV1 = MovieApiModel.fromJson(v1Json).toDomain();
      final movieFromV2 = MovieApiModelV2.fromJson(v2Json).toDomain();

      // Assert - Domain models should be identical!
      expect(movieFromV1.id, movieFromV2.id);
      expect(movieFromV1.title, movieFromV2.title);
      expect(movieFromV1.overview, movieFromV2.overview);
      expect(movieFromV1.posterPath, movieFromV2.posterPath);
      expect(movieFromV1.backdropPath, movieFromV2.backdropPath);
      expect(movieFromV1.voteAverage, movieFromV2.voteAverage);
      expect(movieFromV1.voteCount, movieFromV2.voteCount);
      expect(movieFromV1.releaseDate, movieFromV2.releaseDate);
      expect(movieFromV1.genreIds, movieFromV2.genreIds);
      expect(movieFromV1.popularity, movieFromV2.popularity);
    });

    test('should get pagination info from v1 format', () {
      // Arrange
      final json = MockApiV2Data.moviesResponseV1;

      // Act
      final pagination = MovieApiVersionAdapter.getPaginationInfo(json);

      // Assert
      expect(pagination.currentPage, 1);
      expect(pagination.totalPages, 10);
      expect(pagination.totalResults, 200);
      expect(pagination.hasMorePages, true);
    });

    test('should get pagination info from v2 format', () {
      // Arrange
      final json = MockApiV2Data.moviesResponseV2;

      // Act
      final pagination = MovieApiVersionAdapter.getPaginationInfo(json);

      // Assert
      expect(pagination.currentPage, 1);
      expect(pagination.totalPages, 10);
      expect(pagination.totalResults, 200);
      expect(pagination.hasMorePages, true);
    });
  });

  group('Clean Architecture Isolation Test', () {
    test(
      'Domain Movie model should be used unchanged by both API versions',
      () {
        // This test verifies that the Movie domain model
        // works identically regardless of API version

        // Create movies from both API versions
        final v1Movie =
            MovieApiModel.fromJson(MockApiV2Data.singleMovieV1).toDomain();
        final v2Movie =
            MovieApiModelV2.fromJson(MockApiV2Data.singleMovieV2).toDomain();

        // Both should have working computed properties
        expect(
          v1Movie.fullPosterPath,
          'https://image.tmdb.org/t/p/w500/poster123.jpg',
        );
        expect(
          v2Movie.fullPosterPath,
          'https://image.tmdb.org/t/p/w500/poster123.jpg',
        );

        expect(v1Movie.formattedRating, '8.5');
        expect(v2Movie.formattedRating, '8.5');

        expect(v1Movie.releaseYear, '2025');
        expect(v2Movie.releaseYear, '2025');

        // Equality should work
        expect(v1Movie, equals(v2Movie));
      },
    );

    test(
      'Domain MovieDetail model should be used unchanged by both API versions',
      () {
        final v1Detail =
            MovieDetailApiModel.fromJson(
              MockApiV2Data.movieDetailV1,
            ).toDomain();
        final v2Detail =
            MovieDetailApiModelV2.fromJson(
              MockApiV2Data.movieDetailV2,
            ).toDomain();

        // Both should have working computed properties
        expect(v1Detail.formattedRuntime, '2h 22m');
        expect(v2Detail.formattedRuntime, '2h 22m');

        expect(v1Detail.genreNames, 'Action, Adventure, Fantasy');
        expect(v2Detail.genreNames, 'Action, Adventure, Fantasy');

        // Key fields should match
        expect(v1Detail.id, v2Detail.id);
        expect(v1Detail.title, v2Detail.title);
        expect(v1Detail.runtime, v2Detail.runtime);
        expect(v1Detail.budget, v2Detail.budget);
        expect(v1Detail.revenue, v2Detail.revenue);
      },
    );
  });
}
