import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/themes/app_colors.dart';
import '../../view_model/view_model.dart';

class CategoryTabs extends StatelessWidget {
  final HomeViewModel viewModel;
  final void Function(MovieCategory)? onCategoryTap;

  const CategoryTabs({super.key, required this.viewModel, this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children:
                MovieCategory.values.map((category) {
                  final isSelected = viewModel.selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (onCategoryTap != null) {
                          onCategoryTap!(category);
                        } else {
                          viewModel.setCategory(category);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border:
                              isSelected
                                  ? null
                                  : Border.all(color: AppColors.grayDark),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected)
                              const Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Text(
                                  '✓',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            Text(
                              _getCategoryLabel(category),
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? AppColors.white
                                        : AppColors.black,
                                fontSize: 14,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
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
