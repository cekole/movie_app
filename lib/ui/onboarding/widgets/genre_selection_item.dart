import 'package:flutter/material.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

class GenreSelectionItem extends StatelessWidget {
  final String genreName;
  final bool isSelected;
  final VoidCallback onTap;

  const GenreSelectionItem({
    super.key,
    required this.genreName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              color: AppColors.surface,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    genreName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.grayDark,
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.width * 0.05,
            right: 0,
            child:
                isSelected
                    ? Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 14,
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
