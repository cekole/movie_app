import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

import '../../core/themes/app_colors.dart';
import '../../core/ui/ui.dart';
import '../view_model/view_model.dart';
import '../widgets/home/home.dart';

class HomeScreen extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeScreen({super.key, required this.viewModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<MovieCategory, GlobalKey> _sectionKeys = {};
  bool _isScrollingFromTap = false;

  @override
  void initState() {
    super.initState();
    // Initialize keys for each category section
    for (final category in MovieCategory.values) {
      _sectionKeys[category] = GlobalKey();
    }
    _scrollController.addListener(_onScroll);
    widget.viewModel.fetchAllCategories();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isScrollingFromTap) return;

    // Find which section is currently most visible
    MovieCategory? visibleCategory;
    double minDistance = double.infinity;

    for (final category in MovieCategory.values) {
      final key = _sectionKeys[category];
      if (key?.currentContext != null) {
        final RenderBox? box =
            key!.currentContext!.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          // Check distance from top of screen (with some offset for the header)
          final distance = (position.dy - 300).abs();
          if (distance < minDistance) {
            minDistance = distance;
            visibleCategory = category;
          }
        }
      }
    }

    if (visibleCategory != null &&
        visibleCategory != widget.viewModel.selectedCategory) {
      widget.viewModel.setCategory(visibleCategory);
    }
  }

  void _scrollToCategory(MovieCategory category) async {
    final key = _sectionKeys[category];
    if (key?.currentContext != null) {
      _isScrollingFromTap = true;
      widget.viewModel.setCategory(category);

      await Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );

      _isScrollingFromTap = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildContent()));
  }

  Widget _buildContent() {
    return Observer(
      builder: (_) {
        if (widget.viewModel.isInitialLoading) {
          return const LoadingWidget(message: 'Loading movies...');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed header section
            _buildHeader(),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Build all category sections
                    for (final category in MovieCategory.values)
                      _buildCategorySection(category),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('For You ⭐️', style: AppTextStyles.headline2),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: Observer(
            builder: (_) {
              final allMovies = widget.viewModel.getMoviesForCategory(
                MovieCategory.nowPlaying,
              );
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: allMovies.length > 10 ? 10 : allMovies.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final movie = allMovies[index];
                  return GestureDetector(
                    onTap: () => context.push('/movie/${movie.id}'),
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                      ),
                      child: ClipOval(
                        child:
                            movie.fullPosterPath != null
                                ? Image.network(
                                  movie.fullPosterPath!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          _buildPlaceholder(),
                                )
                                : _buildPlaceholder(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 16, color: AppColors.gray),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Movies 🎬', style: AppTextStyles.headline2),
        ),
        const SizedBox(height: 16),
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () => context.push('/search'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.grayDark),
                  const SizedBox(width: 12),
                  Text(
                    'Search',
                    style: TextStyle(color: AppColors.grayDark, fontSize: 16),
                  ),
                  const Spacer(),
                  Icon(Icons.mic, color: AppColors.grayDark),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Category tabs
        CategoryTabs(
          viewModel: widget.viewModel,
          onCategoryTap: _scrollToCategory,
        ),
      ],
    );
  }

  Widget _buildCategorySection(MovieCategory category) {
    return Observer(
      builder: (_) {
        final categoryMovies = widget.viewModel.getMoviesForCategory(category);
        if (categoryMovies.isEmpty) return const SizedBox.shrink();

        return Column(
          key: _sectionKeys[category],
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _getCategoryLabel(category),
                style: AppTextStyles.headline2,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount:
                    categoryMovies.length > 9 ? 9 : categoryMovies.length,
                itemBuilder: (context, index) {
                  final movie = categoryMovies[index];
                  return MovieCard(
                    movie: movie,
                    onTap: () => context.push('/movie/${movie.id}'),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Text('Image', style: TextStyle(color: AppColors.grayDark)),
      ),
    );
  }

  String _getCategoryLabel(MovieCategory category) {
    switch (category) {
      case MovieCategory.nowPlaying:
        return 'Action';
      case MovieCategory.popular:
        return 'Adventure';
      case MovieCategory.topRated:
        return 'Animation';
      case MovieCategory.upcoming:
        return 'Comedy';
    }
  }
}
