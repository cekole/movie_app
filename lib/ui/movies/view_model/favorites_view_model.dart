import 'package:mobx/mobx.dart';

import '../../../data/repositories/repositories.dart';
import '../../../domain/models/models.dart';

part 'favorites_view_model.g.dart';

class FavoritesViewModel = FavoritesViewModelBase with _$FavoritesViewModel;

abstract class FavoritesViewModelBase with Store {
  final MovieRepository _repository = MovieRepository();

  @observable
  ObservableList<Movie> favorites = ObservableList<Movie>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get isEmpty => favorites.isEmpty;

  @computed
  int get count => favorites.length;

  @action
  Future<void> fetchFavorites() async {
    isLoading = true;
    errorMessage = null;

    try {
      final result = await _repository.getFavorites();
      favorites.clear();
      favorites.addAll(result);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> removeFromFavorites(int movieId) async {
    try {
      await _repository.removeFromFavorites(movieId);
      favorites.removeWhere((movie) => movie.id == movieId);
    } catch (e) {
      errorMessage = 'Failed to remove from favorites';
    }
  }

  @action
  Future<void> clearAllFavorites() async {
    try {
      await _repository.clearFavorites();
      favorites.clear();
    } catch (e) {
      errorMessage = 'Failed to clear favorites';
    }
  }

  @action
  Future<void> refresh() async {
    await fetchFavorites();
  }
}
