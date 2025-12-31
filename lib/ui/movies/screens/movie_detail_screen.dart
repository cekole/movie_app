import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../core/ui/ui.dart';
import '../view_model/view_model.dart';
import '../widgets/movie_detail/movie_detail.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  final MovieDetailViewModel viewModel;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
    required this.viewModel,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchMovieDetail(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          final viewModel = widget.viewModel;

          if (viewModel.isLoading) {
            return const LoadingWidget(message: 'Loading movie details...');
          }

          if (viewModel.hasError) {
            return AppErrorWidget(
              message: viewModel.errorMessage!,
              onRetry: () => viewModel.fetchMovieDetail(widget.movieId),
            );
          }

          if (!viewModel.hasData) {
            return const SizedBox.shrink();
          }

          final movie = viewModel.movieDetail!;

          return CustomScrollView(
            slivers: [
              MovieHeader(
                movie: movie,
                isFavorite: viewModel.isFavorite,
                onFavoritePressed: () => viewModel.toggleFavorite(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      MovieMetaInfo(movie: movie),
                      const SizedBox(height: 16),
                      MovieGenres(movie: movie),
                      if (movie.tagline != null && movie.tagline!.isNotEmpty)
                        MovieTagline(tagline: movie.tagline!),
                      MovieOverview(overview: movie.overview),
                      const SizedBox(height: 24),
                      MovieInfoSection(movie: movie),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
