import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/ui.dart';
import '../../view_model/view_model.dart';

class MovieGrid extends StatelessWidget {
  final HomeViewModel viewModel;

  const MovieGrid({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (viewModel.isCurrentLoading && viewModel.currentMovies.isEmpty) {
          return const LoadingWidget(message: 'Loading movies...');
        }

        if (viewModel.currentError != null && viewModel.currentMovies.isEmpty) {
          return AppErrorWidget(
            message: viewModel.currentError!,
            onRetry: () => viewModel.refresh(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.refresh(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount:
                viewModel.currentMovies.length +
                (viewModel.hasMoreCurrent ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= viewModel.currentMovies.length) {
                viewModel.loadMore();
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              final movie = viewModel.currentMovies[index];
              return MovieCard(
                movie: movie,
                onTap: () => context.push('/movie/${movie.id}'),
              );
            },
          ),
        );
      },
    );
  }
}
