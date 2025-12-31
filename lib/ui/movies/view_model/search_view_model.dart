import 'package:mobx/mobx.dart';

import '../../../data/repositories/repositories.dart';
import '../../../domain/models/models.dart';

part 'search_view_model.g.dart';

class SearchViewModel = SearchViewModelBase with _$SearchViewModel;

abstract class SearchViewModelBase with Store {
  final MovieRepository _repository = MovieRepository();

  @observable
  ObservableList<Movie> searchResults = ObservableList<Movie>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String query = '';

  @observable
  int currentPage = 1;

  @observable
  bool hasMorePages = false;

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get isEmpty => searchResults.isEmpty && query.isNotEmpty && !isLoading;

  @computed
  bool get hasResults => searchResults.isNotEmpty;

  @action
  Future<void> searchMovies(String searchQuery) async {
    if (searchQuery.trim().isEmpty) {
      clearSearch();
      return;
    }

    query = searchQuery.trim();
    currentPage = 1;
    isLoading = true;
    errorMessage = null;
    searchResults.clear();

    try {
      final results = await _repository.searchMovies(query, page: currentPage);
      searchResults.addAll(results);
      hasMorePages = results.length >= 20;
      currentPage++;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadMore() async {
    if (!hasMorePages || isLoading || query.isEmpty) return;

    isLoading = true;

    try {
      final results = await _repository.searchMovies(query, page: currentPage);
      searchResults.addAll(results);
      hasMorePages = results.length >= 20;
      currentPage++;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  void clearSearch() {
    searchResults.clear();
    query = '';
    currentPage = 1;
    hasMorePages = false;
    errorMessage = null;
  }
}
