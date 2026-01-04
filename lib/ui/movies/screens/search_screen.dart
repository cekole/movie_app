import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../core/themes/app_colors.dart';
import '../../core/ui/ui.dart';
import '../view_model/view_model.dart';
import '../widgets/search/search.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            style: const TextStyle(color: AppColors.white),
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: AppColors.grayDark),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (query) => _performSearch(query),
            onChanged: (query) {
              if (query.isEmpty) {
                widget.viewModel.clearSearch();
              }
            },
          ),
        ),
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

          return SearchResultsGrid(viewModel: viewModel);
        },
      ),
    );
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      widget.viewModel.searchMovies(query);
    }
  }
}
