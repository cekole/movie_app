import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../config/app_config.dart';
import '../../../data/repositories/repositories.dart';
import '../../../domain/models/models.dart';

part 'splash_view_model.g.dart';

/// ViewModel for splash screen data fetching
/// Handles initial data loading and caching for the app
class SplashViewModel = SplashViewModelBase with _$SplashViewModel;

abstract class SplashViewModelBase with Store {
  final MovieRepository _repository = MovieRepository();

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @observable
  ObservableList<Genre> genres = ObservableList<Genre>();

  @observable
  ObservableList<Movie> nowPlayingMovies = ObservableList<Movie>();

  @observable
  ObservableList<Movie> popularMovies = ObservableList<Movie>();

  @observable
  ObservableList<Movie> topRatedMovies = ObservableList<Movie>();

  @observable
  ObservableList<Movie> upcomingMovies = ObservableList<Movie>();

  @computed
  bool get isDataLoaded =>
      genres.isNotEmpty &&
      nowPlayingMovies.isNotEmpty &&
      popularMovies.isNotEmpty &&
      topRatedMovies.isNotEmpty &&
      upcomingMovies.isNotEmpty;

  @action
  Future<void> initializeApp() async {
    isLoading = true;
    error = null;

    try {
      // Check if valid cache exists
      final hasValidCache = await _repository.isCacheValid();

      if (hasValidCache) {
        await _loadFromCache();
      } else {
        await _fetchAndCacheData();
      }
    } catch (e) {
      error = 'Failed to load data: ${e.toString()}';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _loadFromCache() async {
    final cachedGenres = await _repository.getCachedGenres();
    if (cachedGenres != null) {
      genres = ObservableList.of(cachedGenres);
    }

    final cachedNowPlaying = await _repository.getCachedNowPlayingMovies();
    if (cachedNowPlaying != null) {
      nowPlayingMovies = ObservableList.of(cachedNowPlaying);
    }

    final cachedPopular = await _repository.getCachedPopularMovies();
    if (cachedPopular != null) {
      popularMovies = ObservableList.of(cachedPopular);
    }

    final cachedTopRated = await _repository.getCachedTopRatedMovies();
    if (cachedTopRated != null) {
      topRatedMovies = ObservableList.of(cachedTopRated);
    }

    final cachedUpcoming = await _repository.getCachedUpcomingMovies();
    if (cachedUpcoming != null) {
      upcomingMovies = ObservableList.of(cachedUpcoming);
    }
  }

  @action
  Future<void> _fetchAndCacheData() async {
    final fetchedGenres = await _repository.getGenres();
    genres = ObservableList.of(fetchedGenres);
    await _repository.cacheGenres(fetchedGenres);

    final fetchedNowPlaying = await _repository.getNowPlayingMovies();
    nowPlayingMovies = ObservableList.of(fetchedNowPlaying);
    await _repository.cacheNowPlayingMovies(fetchedNowPlaying);

    final fetchedPopular = await _repository.getPopularMovies();
    popularMovies = ObservableList.of(fetchedPopular);
    await _repository.cachePopularMovies(fetchedPopular);

    final fetchedTopRated = await _repository.getTopRatedMovies();
    topRatedMovies = ObservableList.of(fetchedTopRated);
    await _repository.cacheTopRatedMovies(fetchedTopRated);

    final fetchedUpcoming = await _repository.getUpcomingMovies();
    upcomingMovies = ObservableList.of(fetchedUpcoming);
    await _repository.cacheUpcomingMovies(fetchedUpcoming);

    // Fetch and cache movie details for all displayed movies
    await _fetchAndCacheMovieDetails();
  }

  Future<void> _fetchAndCacheMovieDetails() async {
    final Set<int> movieIds = {};
    const forYouCount = AppConfig.forYouMoviesCount;
    const categoryCount = AppConfig.categoryMoviesCount;

    // "For You" section movies
    for (int i = 0; i < nowPlayingMovies.length && i < forYouCount; i++) {
      movieIds.add(nowPlayingMovies[i].id);
    }

    // Category section movies
    for (int i = 0; i < nowPlayingMovies.length && i < categoryCount; i++) {
      movieIds.add(nowPlayingMovies[i].id);
    }
    for (int i = 0; i < popularMovies.length && i < categoryCount; i++) {
      movieIds.add(popularMovies[i].id);
    }
    for (int i = 0; i < topRatedMovies.length && i < categoryCount; i++) {
      movieIds.add(topRatedMovies[i].id);
    }
    for (int i = 0; i < upcomingMovies.length && i < categoryCount; i++) {
      movieIds.add(upcomingMovies[i].id);
    }

    final List<Future<void>> futures = [];
    for (final movieId in movieIds) {
      futures.add(_fetchAndCacheMovieDetail(movieId));
    }
    await Future.wait(futures);
  }

  Future<void> _fetchAndCacheMovieDetail(int movieId) async {
    final detail = await _repository.getMovieDetails(movieId);
    await _repository.cacheMovieDetail(detail);
  }

  /// Pre-cache all movie images for offline use
  Future<void> preCacheImages() async {
    final List<String> imageUrls = [];
    const forYouCount = AppConfig.forYouMoviesCount;
    const categoryCount = AppConfig.categoryMoviesCount;

    for (int i = 0; i < nowPlayingMovies.length && i < forYouCount; i++) {
      final posterPath = nowPlayingMovies[i].fullPosterPath;
      if (posterPath != null) imageUrls.add(posterPath);
    }

    void addCategoryImages(List<Movie> movies) {
      for (int i = 0; i < movies.length && i < categoryCount; i++) {
        final posterPath = movies[i].fullPosterPath;
        if (posterPath != null) imageUrls.add(posterPath);
      }
    }

    addCategoryImages(nowPlayingMovies.toList());
    addCategoryImages(popularMovies.toList());
    addCategoryImages(topRatedMovies.toList());
    addCategoryImages(upcomingMovies.toList());

    for (final movie in nowPlayingMovies.take(forYouCount)) {
      final backdropPath = movie.fullBackdropPath;
      if (backdropPath != null) imageUrls.add(backdropPath);
    }

    await Future.wait(imageUrls.toSet().map((url) => _cacheImage(url)));
  }

  Future<void> _cacheImage(String url) async {
    CachedNetworkImageProvider(url).resolve(ImageConfiguration.empty);
  }

  @action
  Future<void> refreshData() async {
    await _repository.clearCache();
    await initializeApp();
  }

  @action
  Future<void> retry() async {
    error = null;
    await initializeApp();
  }
}
