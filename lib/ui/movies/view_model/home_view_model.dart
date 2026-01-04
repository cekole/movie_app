import 'package:mobx/mobx.dart';

import '../../../data/repositories/repositories.dart';
import '../../../domain/models/models.dart';

part 'home_view_model.g.dart';

enum MovieCategory { nowPlaying, popular, topRated, upcoming }

class HomeViewModel = HomeViewModelBase with _$HomeViewModel;

abstract class HomeViewModelBase with Store {
  final MovieRepository _repository = MovieRepository();

  @observable
  MovieCategory selectedCategory = MovieCategory.nowPlaying;

  @observable
  ObservableMap<MovieCategory, ObservableList<Movie>> movies =
      ObservableMap.of({
        MovieCategory.nowPlaying: ObservableList<Movie>(),
        MovieCategory.popular: ObservableList<Movie>(),
        MovieCategory.topRated: ObservableList<Movie>(),
        MovieCategory.upcoming: ObservableList<Movie>(),
      });

  @observable
  ObservableMap<MovieCategory, bool> isLoading = ObservableMap.of({
    MovieCategory.nowPlaying: false,
    MovieCategory.popular: false,
    MovieCategory.topRated: false,
    MovieCategory.upcoming: false,
  });

  @observable
  ObservableMap<MovieCategory, String?> errors = ObservableMap.of({
    MovieCategory.nowPlaying: null,
    MovieCategory.popular: null,
    MovieCategory.topRated: null,
    MovieCategory.upcoming: null,
  });

  @observable
  ObservableMap<MovieCategory, int> currentPage = ObservableMap.of({
    MovieCategory.nowPlaying: 1,
    MovieCategory.popular: 1,
    MovieCategory.topRated: 1,
    MovieCategory.upcoming: 1,
  });

  @observable
  ObservableMap<MovieCategory, bool> hasMore = ObservableMap.of({
    MovieCategory.nowPlaying: true,
    MovieCategory.popular: true,
    MovieCategory.topRated: true,
    MovieCategory.upcoming: true,
  });

  // User preferences
  @observable
  ObservableList<int> selectedGenreIds = ObservableList<int>();

  @observable
  ObservableList<int> selectedMovieIds = ObservableList<int>();

  @observable
  ObservableList<Movie> forYouMovies = ObservableList<Movie>();

  @computed
  List<Movie> get currentMovies => movies[selectedCategory]?.toList() ?? [];

  @computed
  bool get isCurrentLoading => isLoading[selectedCategory] ?? false;

  @computed
  String? get currentError => errors[selectedCategory];

  @computed
  bool get hasMoreCurrent => hasMore[selectedCategory] ?? false;

  @computed
  bool get hasData => movies[MovieCategory.nowPlaying]?.isNotEmpty ?? false;

  /// Get movies for a specific category
  List<Movie> getMoviesForCategory(MovieCategory category) {
    return movies[category]?.toList() ?? [];
  }

  /// Get personalized "For You" movies based on user preferences
  List<Movie> getForYouMovies() {
    return forYouMovies.toList();
  }

  @action
  void setCategory(MovieCategory category) {
    selectedCategory = category;
  }

  /// Set movies directly (called from splash screen after loading)
  @action
  void setMoviesForCategory(MovieCategory category, List<Movie> movieList) {
    movies[category] = ObservableList.of(movieList);
  }

  /// Load user preferences from storage
  @action
  Future<void> loadUserPreferences() async {
    final genreIds = await _repository.getSelectedGenreIds();
    final movieIds = await _repository.getSelectedMovieIds();

    selectedGenreIds = ObservableList.of(genreIds);
    selectedMovieIds = ObservableList.of(movieIds);

    _buildForYouList();
  }

  @action
  void _buildForYouList() {
    final allMovies = <Movie>[];

    for (final category in MovieCategory.values) {
      allMovies.addAll(movies[category] ?? []);
    }

    // Remove duplicates based on movie ID
    final uniqueMovies = <int, Movie>{};
    for (final movie in allMovies) {
      uniqueMovies[movie.id] = movie;
    }

    final movieList = uniqueMovies.values.toList();

    final selectedMovies = <Movie>[];
    final genreMatchedMovies = <Movie>[];
    final otherMovies = <Movie>[];

    for (final movie in movieList) {
      if (selectedMovieIds.contains(movie.id)) {
        selectedMovies.add(movie);
      } else if (selectedGenreIds.isNotEmpty &&
          movie.genreIds.any((id) => selectedGenreIds.contains(id))) {
        genreMatchedMovies.add(movie);
      } else {
        otherMovies.add(movie);
      }
    }

    genreMatchedMovies.sort((a, b) {
      final aMatches =
          a.genreIds.where((id) => selectedGenreIds.contains(id)).length;
      final bMatches =
          b.genreIds.where((id) => selectedGenreIds.contains(id)).length;
      return bMatches.compareTo(aMatches);
    });

    // Selected movies first, then genre-matched, then others
    forYouMovies = ObservableList.of([
      ...selectedMovies,
      ...genreMatchedMovies,
      ...otherMovies,
    ]);
  }

  /// Fetch all categories from API (used for refresh)
  @action
  Future<void> fetchAllCategories() async {
    await Future.wait([
      fetchMovies(MovieCategory.nowPlaying, refresh: true),
      fetchMovies(MovieCategory.popular, refresh: true),
      fetchMovies(MovieCategory.topRated, refresh: true),
      fetchMovies(MovieCategory.upcoming, refresh: true),
    ]);
    // Rebuild "For You" list after fetching
    _buildForYouList();
  }

  @action
  Future<void> fetchMovies(
    MovieCategory category, {
    bool refresh = false,
  }) async {
    if (isLoading[category] == true) return;

    if (refresh) {
      currentPage[category] = 1;
      hasMore[category] = true;
    }

    isLoading[category] = true;
    errors[category] = null;

    try {
      final page = currentPage[category] ?? 1;
      final result = await _fetchByCategory(category, page);

      if (refresh) {
        movies[category]?.clear();
      }
      movies[category]?.addAll(result);

      hasMore[category] = result.length >= 20;
      currentPage[category] = page + 1;
    } catch (e) {
      errors[category] = e.toString();
    } finally {
      isLoading[category] = false;
    }
  }

  Future<List<Movie>> _fetchByCategory(MovieCategory category, int page) async {
    switch (category) {
      case MovieCategory.nowPlaying:
        return await _repository.getNowPlayingMovies(page: page);
      case MovieCategory.popular:
        return await _repository.getPopularMovies(page: page);
      case MovieCategory.topRated:
        return await _repository.getTopRatedMovies(page: page);
      case MovieCategory.upcoming:
        return await _repository.getUpcomingMovies(page: page);
    }
  }

  @action
  Future<void> loadMore() async {
    if (!hasMoreCurrent || isCurrentLoading) return;
    await fetchMovies(selectedCategory);
  }

  @action
  Future<void> refresh() async {
    await fetchAllCategories();
  }
}
