import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../widgets/continue_button.dart';

class ThankYouScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const ThankYouScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Thank you ',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('🎉', style: TextStyle(fontSize: 28)),
                ],
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return _SelectedMovieItem(index: index);
                  },
                ),
              ),
              const SizedBox(height: 24),
              ContinueButton(enabled: true, onPressed: onContinue),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedMovieItem extends StatelessWidget {
  final int index;

  const _SelectedMovieItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                  color: AppColors.surface,
                ),
                child: const Center(
                  child: Text(
                    'Image',
                    style: TextStyle(color: AppColors.grayDark, fontSize: 12),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: AppColors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
