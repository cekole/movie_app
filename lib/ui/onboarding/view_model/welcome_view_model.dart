import 'package:mobx/mobx.dart';

import '../../../data/repositories/repositories.dart';
import '../../../domain/models/models.dart';

part 'welcome_view_model.g.dart';

/// ViewModel for welcome screen
class WelcomeViewModel = WelcomeViewModelBase with _$WelcomeViewModel;

abstract class WelcomeViewModelBase with Store {
  final MovieRepository _repository = MovieRepository();

  static const int maxSelections = 3;
  static const int _pageSize = 20;

  @observable
  ObservableList<int> selectedMovieIds = ObservableList<int>();

  @observable
  ObservableList<Movie> movies = ObservableList<Movie>();

  @observable
  int _currentPage = 1;

  @observable
  bool isLoading = false;

  @observable
  bool hasMore = true;

  @observable
  String? error;

  @computed
  bool get canContinue => selectedMovieIds.length >= maxSelections;

  @action
  Future<void> initialize() async {
    if (movies.isNotEmpty) return; // Already initialized
    await _loadMovies();
  }

  @action
  Future<void> _loadMovies() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    error = null;

    try {
      final result = await _repository.getPopularMovies(page: _currentPage);
      movies.addAll(result);
      hasMore = result.length >= _pageSize;
      _currentPage++;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  /// Load more movies (infinite scroll)
  @action
  Future<void> loadMore() async {
    await _loadMovies();
  }

  @computed
  List<int> get selectedIds => selectedMovieIds.toList();

  @action
  void toggleMovie(int movieId) {
    if (selectedMovieIds.contains(movieId)) {
      // Deselect if already selected
      selectedMovieIds.remove(movieId);
    } else if (selectedMovieIds.length < maxSelections) {
      // Add if under limit
      selectedMovieIds.add(movieId);
    } else {
      // Replace the oldest selection (first in list) with new one
      selectedMovieIds.removeAt(0);
      selectedMovieIds.add(movieId);
    }
  }

  @action
  bool isMovieSelected(int movieId) {
    return selectedMovieIds.contains(movieId);
  }

  @action
  void clearSelection() {
    selectedMovieIds.clear();
  }

  /// Save selected movies to local storage
  @action
  Future<void> saveSelections() async {
    await _repository.saveSelectedMovieIds(selectedMovieIds.toList());
  }
}
