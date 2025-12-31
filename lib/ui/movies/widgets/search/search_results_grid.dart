import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/ui.dart';
import '../../view_model/view_model.dart';

class SearchResultsGrid extends StatelessWidget {
  final SearchViewModel viewModel;

  const SearchResultsGrid({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount:
              viewModel.searchResults.length + (viewModel.hasMorePages ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= viewModel.searchResults.length) {
              viewModel.loadMore();
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }

            final movie = viewModel.searchResults[index];
            return MovieCard(
              movie: movie,
              onTap: () => context.push('/movie/${movie.id}'),
            );
          },
        );
      },
    );
  }
}
