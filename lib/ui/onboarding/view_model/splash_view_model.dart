import 'package:mobx/mobx.dart';

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
