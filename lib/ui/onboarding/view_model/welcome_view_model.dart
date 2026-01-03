import 'package:mobx/mobx.dart';

import '../../../data/repositories/repositories.dart';
import '../../../domain/models/models.dart';

part 'welcome_view_model.g.dart';

/// ViewModel for welcome screen
class WelcomeViewModel = WelcomeViewModelBase with _$WelcomeViewModel;

abstract class WelcomeViewModelBase with Store {
  final MovieRepository _repository = MovieRepository();

  static const int maxSelections = 3;

  @observable
  ObservableList<int> selectedMovieIds = ObservableList<int>();

  @computed
  bool get canContinue => selectedMovieIds.length >= maxSelections;

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
