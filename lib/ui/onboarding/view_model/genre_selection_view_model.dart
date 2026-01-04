import 'package:mobx/mobx.dart';

import '../../../data/repositories/repositories.dart';
import '../../../domain/models/models.dart';

part 'genre_selection_view_model.g.dart';

/// ViewModel for genre selection screen
class GenreSelectionViewModel = GenreSelectionViewModelBase
    with _$GenreSelectionViewModel;

abstract class GenreSelectionViewModelBase with Store {
  final MovieRepository _repository = MovieRepository();

  static const int maxSelections = 2;

  @observable
  ObservableList<Genre> genres = ObservableList<Genre>();

  @observable
  ObservableList<int> selectedGenreIds = ObservableList<int>();

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @computed
  bool get canContinue => selectedGenreIds.length >= maxSelections;

  @computed
  bool get showThankYou => selectedGenreIds.length >= maxSelections;

  @computed
  List<Genre> get selectedGenres =>
      genres.where((g) => selectedGenreIds.contains(g.id)).toList();

  @action
  Future<void> loadGenres() async {
    isLoading = true;
    error = null;

    try {
      // First try to get from cache (should be populated by splash screen)
      final cachedGenres = await _repository.getCachedGenres();
      if (cachedGenres != null && cachedGenres.isNotEmpty) {
        genres = ObservableList.of(cachedGenres);
      } else {
        // Fallback to API if cache is empty
        final fetchedGenres = await _repository.getGenres();
        genres = ObservableList.of(fetchedGenres);
        await _repository.cacheGenres(fetchedGenres);
      }
    } catch (e) {
      error = 'Failed to load genres: ${e.toString()}';
    } finally {
      isLoading = false;
    }
  }

  @action
  void toggleGenre(int genreId) {
    if (selectedGenreIds.contains(genreId)) {
      // Deselect if already selected
      selectedGenreIds.remove(genreId);
    } else if (selectedGenreIds.length < maxSelections) {
      // Add if under limit
      selectedGenreIds.add(genreId);
    } else {
      // Replace the oldest selection (first in list) with new one
      selectedGenreIds.removeAt(0);
      selectedGenreIds.add(genreId);
    }
  }

  @action
  bool isGenreSelected(int genreId) {
    return selectedGenreIds.contains(genreId);
  }

  @action
  void clearSelection() {
    selectedGenreIds.clear();
  }

  /// Save selected genres to local storage and mark onboarding as completed
  @action
  Future<void> saveSelections() async {
    await _repository.saveSelectedGenreIds(selectedGenreIds.toList());
    await _repository.setOnboardingCompleted(true);
  }
}
