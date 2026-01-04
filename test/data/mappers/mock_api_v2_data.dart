class MockApiV2Data {
  /// Sample v2 movie list response
  static const Map<String, dynamic> moviesResponseV2 = {
    'api_version': '2.0',
    'items': [
      singleMovieV2,
      {
        'id': 456,
        'name': 'Another Great Movie',
        'description': 'Another amazing story about heroes.',
        'media': {
          'poster': {
            'path': '/another_poster.jpg',
            'width': 500,
            'height': 750,
          },
          'backdrop': {
            'path': '/another_backdrop.jpg',
            'width': 1280,
            'height': 720,
          },
        },
        'ratings': {'score': 7.5, 'count': 2000, 'source': 'tmdb'},
        'categories': [
          {'id': 28, 'name': 'Action'},
          {'id': 12, 'name': 'Adventure'},
        ],
        'metadata': {
          'release_date': '2025-06-15',
          'popularity_score': 150.5,
          'status': 'Released',
        },
        'is_adult': false,
        'original': {'language': 'en', 'title': 'Another Great Movie'},
        'has_video': true,
      },
    ],
    'pagination': {
      'current_page': 1,
      'total_pages': 10,
      'total_items': 200,
      'items_per_page': 20,
    },
  };

  /// Sample v2 single movie
  static const Map<String, dynamic> singleMovieV2 = {
    'id': 123,
    'name': 'The Great Adventure', // was: title
    'description': 'An epic journey through unknown lands.', // was: overview
    'media': {
      // was: poster_path, backdrop_path at root
      'poster': {
        'path': '/poster123.jpg',
        'width': 500,
        'height': 750,
        'aspect_ratio': '2:3',
      },
      'backdrop': {
        'path': '/backdrop123.jpg',
        'width': 1280,
        'height': 720,
        'aspect_ratio': '16:9',
      },
      'logo': null,
    },
    'ratings': {
      // was: vote_average, vote_count at root
      'score': 8.5,
      'count': 1500,
      'source': 'tmdb',
    },
    'categories': [
      // was: genre_ids (just int list)
      {'id': 28, 'name': 'Action'},
      {'id': 12, 'name': 'Adventure'},
      {'id': 14, 'name': 'Fantasy'},
    ],
    'metadata': {
      // was: release_date, popularity at root
      'release_date': '2025-03-15',
      'popularity_score': 250.75,
      'status': 'Released',
      'language': 'en',
    },
    'is_adult': false, // was: adult
    'original': {
      // was: original_language, original_title at root
      'language': 'en',
      'title': 'The Great Adventure',
    },
    'has_video': true, // was: video
  };

  /// Sample v2 movie detail response
  static const Map<String, dynamic> movieDetailV2 = {
    'id': 123,
    'name': 'The Great Adventure',
    'description':
        'An epic journey through unknown lands. Join our heroes as they discover ancient secrets and face unimaginable challenges.',
    'media': {
      'poster': {
        'path': '/poster123.jpg',
        'width': 500,
        'height': 750,
        'aspect_ratio': '2:3',
      },
      'backdrop': {
        'path': '/backdrop123.jpg',
        'width': 1280,
        'height': 720,
        'aspect_ratio': '16:9',
      },
    },
    'ratings': {'score': 8.5, 'count': 1500, 'source': 'tmdb'},
    'categories': [
      {'id': 28, 'name': 'Action'},
      {'id': 12, 'name': 'Adventure'},
      {'id': 14, 'name': 'Fantasy'},
    ],
    'metadata': {
      'release_date': '2025-03-15',
      'popularity_score': 250.75,
      'runtime_minutes': 142,
      'tagline': 'The journey of a lifetime',
      'status': 'Released',
      'language': 'en',
    },
    'financials': {
      'budget': 150000000,
      'revenue': 750000000,
      'currency': 'USD',
    },
    'external_links': {
      'homepage': 'https://www.thegreatadventure.com',
      'imdb_id': 'tt1234567',
      'twitter_handle': '@greatadventure',
      'facebook_page': 'TheGreatAdventureMovie',
    },
    'is_adult': false,
    'original': {'language': 'en', 'title': 'The Great Adventure'},
    'has_video': true,
  };

  /// Sample v1 movie list response (for comparison)
  static const Map<String, dynamic> moviesResponseV1 = {
    'page': 1,
    'results': [
      {
        'id': 123,
        'title': 'The Great Adventure',
        'poster_path': '/poster123.jpg',
        'backdrop_path': '/backdrop123.jpg',
        'overview': 'An epic journey through unknown lands.',
        'vote_average': 8.5,
        'vote_count': 1500,
        'release_date': '2025-03-15',
        'genre_ids': [28, 12, 14],
        'popularity': 250.75,
        'adult': false,
        'original_language': 'en',
        'original_title': 'The Great Adventure',
        'video': true,
      },
    ],
    'total_pages': 10,
    'total_results': 200,
  };

  /// Sample v1 single movie (for comparison)
  static const Map<String, dynamic> singleMovieV1 = {
    'id': 123,
    'title': 'The Great Adventure',
    'poster_path': '/poster123.jpg',
    'backdrop_path': '/backdrop123.jpg',
    'overview': 'An epic journey through unknown lands.',
    'vote_average': 8.5,
    'vote_count': 1500,
    'release_date': '2025-03-15',
    'genre_ids': [28, 12, 14],
    'popularity': 250.75,
    'adult': false,
    'original_language': 'en',
    'original_title': 'The Great Adventure',
    'video': true,
  };

  /// Sample v1 movie detail (for comparison)
  static const Map<String, dynamic> movieDetailV1 = {
    'id': 123,
    'title': 'The Great Adventure',
    'poster_path': '/poster123.jpg',
    'backdrop_path': '/backdrop123.jpg',
    'overview':
        'An epic journey through unknown lands. Join our heroes as they discover ancient secrets and face unimaginable challenges.',
    'vote_average': 8.5,
    'vote_count': 1500,
    'release_date': '2025-03-15',
    'genres': [
      {'id': 28, 'name': 'Action'},
      {'id': 12, 'name': 'Adventure'},
      {'id': 14, 'name': 'Fantasy'},
    ],
    'runtime': 142,
    'tagline': 'The journey of a lifetime',
    'status': 'Released',
    'budget': 150000000,
    'revenue': 750000000,
    'homepage': 'https://www.thegreatadventure.com',
    'imdb_id': 'tt1234567',
    'popularity': 250.75,
    'adult': false,
    'original_language': 'en',
    'original_title': 'The Great Adventure',
    'video': true,
  };
}
