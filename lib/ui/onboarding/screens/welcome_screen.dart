import 'package:flutter/material.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

import '../../../domain/models/movie.dart';
import '../../core/widgets/inverted_list_wheel_scroll_view.dart';
import '../widgets/continue_button.dart';
import '../widgets/movie_selection_card.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final List<Movie> movies;

  const WelcomeScreen({
    super.key,
    required this.onContinue,
    required this.movies,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final Set<int> _selectedMovieIds = {};
  late final FixedExtentScrollController _scrollController;

  bool get _canContinue => _selectedMovieIds.length >= 3;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController();
  }

  void _toggleMovie(int movieId) {
    setState(() {
      if (_selectedMovieIds.contains(movieId)) {
        _selectedMovieIds.remove(movieId);
      } else {
        _selectedMovieIds.add(movieId);
      }
    });
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome', style: AppTextStyles.headline2),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose your 3 favorite movies',
                    style: AppTextStyles.headline3,
                  ),
                ],
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
                          child: MovieSelectionCard(
                            movie: movie,
                            isSelected: _selectedMovieIds.contains(movie.id),
                            onTap: () => _toggleMovie(movie.id),
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
              child: ContinueButton(
                enabled: _canContinue,
                onPressed: widget.onContinue,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
