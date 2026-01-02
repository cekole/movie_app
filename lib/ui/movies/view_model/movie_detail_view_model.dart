import 'package:mobx/mobx.dart';

import '../../../data/repositories/repositories.dart';
import '../../../domain/models/models.dart';

part 'movie_detail_view_model.g.dart';

class MovieDetailViewModel = MovieDetailViewModelBase
    with _$MovieDetailViewModel;

abstract class MovieDetailViewModelBase with Store {
  final MovieRepository _repository = MovieRepository();

  @observable
  MovieDetail? movieDetail;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  bool isFavorite = false;

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get hasData => movieDetail != null;

  @action
  Future<void> fetchMovieDetail(int movieId) async {
    errorMessage = null;

    try {
      final cached = await _repository.getCachedMovieDetail(movieId);
      if (cached != null) {
        movieDetail = cached;
        isFavorite = await _repository.isFavorite(movieId);
        return;
      }

      isLoading = true;
      movieDetail = await _repository.getMovieDetailsWithCache(movieId);
      isFavorite = await _repository.isFavorite(movieId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> toggleFavorite() async {
    if (movieDetail == null) return;

    try {
      final movie = Movie(
        id: movieDetail!.id,
        title: movieDetail!.title,
        posterPath: movieDetail!.posterPath,
        backdropPath: movieDetail!.backdropPath,
        overview: movieDetail!.overview,
        voteAverage: movieDetail!.voteAverage,
        voteCount: movieDetail!.voteCount,
        releaseDate: movieDetail!.releaseDate,
        genreIds: movieDetail!.genres.map((g) => g.id).toList(),
        popularity: movieDetail!.popularity,
      );

      isFavorite = await _repository.toggleFavorite(movie);
    } catch (e) {
      errorMessage = 'Failed to update favorites';
    }
  }

  @action
  void clear() {
    movieDetail = null;
    isLoading = false;
    errorMessage = null;
    isFavorite = false;
  }
}
