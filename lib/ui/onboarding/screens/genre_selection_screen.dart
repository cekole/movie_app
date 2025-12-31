import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../widgets/continue_button.dart';

class GenreSelectionScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const GenreSelectionScreen({super.key, required this.onContinue});

  @override
  State<GenreSelectionScreen> createState() => _GenreSelectionScreenState();
}

class _GenreSelectionScreenState extends State<GenreSelectionScreen> {
  final Set<int> _selectedGenres = {};

  bool get _canContinue => _selectedGenres.length >= 2;

  void _toggleGenre(int index) {
    setState(() {
      if (_selectedGenres.contains(index)) {
        _selectedGenres.remove(index);
      } else {
        _selectedGenres.add(index);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Choose your 2 favorite genres ',
                    style: TextStyle(color: AppColors.grayDark, fontSize: 16),
                  ),
                  const Text('🎬', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedGenres.contains(index);
                    return _GenreSelectionItem(
                      isSelected: isSelected,
                      onTap: () => _toggleGenre(index),
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

class _GenreSelectionItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _GenreSelectionItem({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grayDark,
            width: 2,
          ),
          color: AppColors.surface,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : Colors.transparent,
                ),
                child: const Center(
                  child: Text(
                    'Image',
                    style: TextStyle(color: AppColors.grayDark, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
