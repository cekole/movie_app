import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../widgets/continue_button.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const WelcomeScreen({super.key, required this.onContinue});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final Set<int> _selectedMovies = {};

  bool get _canContinue => _selectedMovies.length >= 3;

  void _toggleMovie(int index) {
    setState(() {
      if (_selectedMovies.contains(index)) {
        _selectedMovies.remove(index);
      } else {
        _selectedMovies.add(index);
      }
    });
  }

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
              const Text(
                'Welcome',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your 3 favorite movies',
                style: TextStyle(color: AppColors.grayDark, fontSize: 16),
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
                    final isSelected = _selectedMovies.contains(index);
                    return _MovieSelectionItem(
                      isSelected: isSelected,
                      onTap: () => _toggleMovie(index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              ContinueButton(
                enabled: _canContinue,
                onPressed: widget.onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieSelectionItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _MovieSelectionItem({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : AppColors.grayDark,
                      width: 2,
                    ),
                    color: AppColors.surface,
                  ),
                  child: const Center(
                    child: Text(
                      'Image',
                      style: TextStyle(color: AppColors.grayDark, fontSize: 12),
                    ),
                  ),
                ),
                if (isSelected)
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
      ),
    );
  }
}
