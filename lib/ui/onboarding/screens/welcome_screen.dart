import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

import '../../core/widgets/inverted_list_wheel_scroll_view.dart';
import '../view_model/welcome_view_model.dart';
import '../widgets/continue_button.dart';
import '../widgets/movie_selection_card.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final WelcomeViewModel viewModel;

  const WelcomeScreen({
    super.key,
    required this.onContinue,
    required this.viewModel,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController();
    _scrollController.addListener(_onScroll);
    widget.viewModel.initialize();
  }

  void _onScroll() {
    final movies = widget.viewModel.movies;
    if (movies.isEmpty) return;

    final currentIndex = _scrollController.selectedItem;
    // Load more when user is near the end
    if (currentIndex >= movies.length - 5 &&
        !widget.viewModel.isLoading &&
        widget.viewModel.hasMore) {
      widget.viewModel.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Observer(
                builder:
                    (_) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!widget.viewModel.canContinue)
                          const Text('Welcome', style: AppTextStyles.headline2),
                        const SizedBox(height: 8),
                        widget.viewModel.canContinue
                            ? Text(
                              'Continue to next step 👉',
                              style: AppTextStyles.headline2,
                            )
                            : const Text(
                              'Choose your 3 favorite movies',
                              style: AppTextStyles.headline3,
                            ),
                      ],
                    ),
              ),
            ),
            const Spacer(),
            Observer(
              builder: (_) {
                final movies = widget.viewModel.movies;
                return SizedBox(
                  height: screenHeight * 0.5,
                  child:
                      movies.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : RotatedBox(
                            quarterTurns: -1,
                            child: InvertedListWheelScrollView.useDelegate(
                              controller: _scrollController,
                              itemExtent: screenWidth * 0.5,
                              perspective: -0.0004,
                              physics: const FixedExtentScrollPhysics(),
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: movies.length,
                                builder: (context, index) {
                                  final movie = movies[index];
                                  return RotatedBox(
                                    quarterTurns: 1,
                                    child: SizedBox(
                                      width: screenWidth * 0.45,
                                      child: Observer(
                                        builder:
                                            (_) => MovieSelectionCard(
                                              movie: movie,
                                              isSelected: widget
                                                  .viewModel
                                                  .selectedMovieIds
                                                  .contains(movie.id),
                                              onTap:
                                                  () => widget.viewModel
                                                      .toggleMovie(movie.id),
                                            ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Observer(
                builder:
                    (_) => ContinueButton(
                      enabled: widget.viewModel.canContinue,
                      onPressed: () async {
                        await widget.viewModel.saveSelections();
                        widget.onContinue();
                      },
                    ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
