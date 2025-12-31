import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/ui.dart';
import '../view_model/view_model.dart';

class SearchScreen extends StatefulWidget {
  final SearchViewModel viewModel;

  const SearchScreen({super.key, required this.viewModel});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (query) => _performSearch(query),
          onChanged: (query) {
            if (query.isEmpty) {
              widget.viewModel.clearSearch();
            }
          },
        ),
        actions: [
          Observer(
            builder: (_) {
              if (widget.viewModel.query.isEmpty)
                return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  widget.viewModel.clearSearch();
                },
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          final viewModel = widget.viewModel;

          if (viewModel.query.isEmpty) {
            return const EmptyWidget(
              title: 'Search for movies',
              subtitle: 'Find your favorite movies by title',
              icon: Icons.search,
            );
          }

          if (viewModel.isLoading && viewModel.searchResults.isEmpty) {
            return const LoadingWidget(message: 'Searching...');
          }

          if (viewModel.hasError) {
            return AppErrorWidget(
              message: viewModel.errorMessage!,
              onRetry: () => _performSearch(viewModel.query),
            );
          }

          if (viewModel.isEmpty) {
            return const EmptyWidget(
              title: 'No results found',
              subtitle: 'Try searching with different keywords',
              icon: Icons.search_off,
            );
          }

          return _buildSearchResults();
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return Observer(
      builder: (_) {
        final viewModel = widget.viewModel;

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

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      widget.viewModel.searchMovies(query);
    }
  }
}
