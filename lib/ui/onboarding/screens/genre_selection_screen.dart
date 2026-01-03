import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

import '../view_model/genre_selection_view_model.dart';
import '../widgets/continue_button.dart';
import '../widgets/genre_selection_item.dart';

class GenreSelectionScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final GenreSelectionViewModel viewModel;

  const GenreSelectionScreen({
    super.key,
    required this.onContinue,
    required this.viewModel,
  });

  @override
  State<GenreSelectionScreen> createState() => _GenreSelectionScreenState();
}

class _GenreSelectionScreenState extends State<GenreSelectionScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 48,
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
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Observer(
                builder:
                    (_) =>
                        widget.viewModel.canContinue
                            ? const SizedBox.shrink()
                            : const Text(
                              'Welcome',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
              ),
              const SizedBox(height: 8),
              Observer(
                builder:
                    (_) =>
                        widget.viewModel.canContinue
                            ? Text(
                              'Thank you 👍',
                              style: AppTextStyles.headline2,
                            )
                            : const Text(
                              'Choose your 2 favorite genres ',
                              style: AppTextStyles.headline3,
                            ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Observer(
                  builder: (_) {
                    if (widget.viewModel.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (widget.viewModel.error != null) {
                      return Center(
                        child: Text(
                          widget.viewModel.error!,
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      );
                    }

                    final genres = widget.viewModel.genres;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing:
                            MediaQuery.of(context).size.width * 0.1,
                        mainAxisSpacing:
                            MediaQuery.of(context).size.width * 0.075,
                        childAspectRatio: 1,
                      ),
                      itemCount: genres.length,
                      itemBuilder: (context, index) {
                        final genre = genres[index];
                        return Observer(
                          builder: (_) {
                            final isSelected = widget.viewModel.selectedGenreIds
                                .contains(genre.id);
                            return GenreSelectionItem(
                              genreName: genre.name,
                              isSelected: isSelected,
                              onTap:
                                  () => widget.viewModel.toggleGenre(genre.id),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
