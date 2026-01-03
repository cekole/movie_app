import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

import '../../../domain/models/movie.dart';
import '../../core/widgets/inverted_list_wheel_scroll_view.dart';
import '../view_model/welcome_view_model.dart';
import '../widgets/continue_button.dart';
import '../widgets/movie_selection_card.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final List<Movie> movies;
  final WelcomeViewModel viewModel;

  const WelcomeScreen({
    super.key,
    required this.onContinue,
    required this.movies,
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
  }

  @override
  void dispose() {
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
            SizedBox(
              height: screenHeight * 0.5,
              child: RotatedBox(
                quarterTurns: -1,
                child: InvertedListWheelScrollView.useDelegate(
                  controller: _scrollController,
                  itemExtent: screenWidth * 0.5,
                  perspective: -0.0004,
                  physics: const FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: widget.movies.length,
                    builder: (context, index) {
                      final movie = widget.movies[index];
                      return RotatedBox(
                        quarterTurns: 1,
                        child: SizedBox(
                          width: screenWidth * 0.45,
                          child: Observer(
                            builder:
                                (_) => MovieSelectionCard(
                                  movie: movie,
                                  isSelected: widget.viewModel.selectedMovieIds
                                      .contains(movie.id),
                                  onTap:
                                      () => widget.viewModel.toggleMovie(
                                        movie.id,
                                      ),
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
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
