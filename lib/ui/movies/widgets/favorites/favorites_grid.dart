import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/ui.dart';
import '../../view_model/view_model.dart';

class FavoritesGrid extends StatelessWidget {
  final FavoritesViewModel viewModel;

  const FavoritesGrid({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (viewModel.isLoading) {
          return const LoadingWidget(message: 'Loading favorites...');
        }

        if (viewModel.hasError) {
          return AppErrorWidget(
            message: viewModel.errorMessage!,
            onRetry: () => viewModel.fetchFavorites(),
          );
        }

        if (viewModel.isEmpty) {
          return const EmptyWidget(
            title: 'No favorites yet',
            subtitle: 'Start adding movies to your favorites!',
            icon: Icons.favorite_border,
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
            itemCount: viewModel.favorites.length,
            itemBuilder: (context, index) {
              final movie = viewModel.favorites[index];
              return Dismissible(
                key: Key('favorite_${movie.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  viewModel.removeFromFavorites(movie.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${movie.title} removed from favorites'),
                    ),
                  );
                },
                child: MovieCard(
                  movie: movie,
                  onTap: () => context.push('/movie/${movie.id}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
