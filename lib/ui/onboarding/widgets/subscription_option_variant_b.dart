import 'package:flutter/material.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

class SubscriptionOptionVariantB extends StatelessWidget {
  final String title;
  final String monthlyPrice;
  final String weeklyPrice;
  final bool isSelected;
  final bool isBestValue;
  final VoidCallback onTap;

  const SubscriptionOptionVariantB({
    super.key,
    required this.title,
    required this.monthlyPrice,
    required this.weeklyPrice,
    required this.isSelected,
    this.isBestValue = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.white24,
              ),
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                _RadioIndicatorVariantB(isSelected: isSelected),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 17,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        monthlyPrice,
                        style: const TextStyle(
                          color: AppColors.grayDark,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(weeklyPrice, style: AppTextStyles.bodyLarge),
              ],
            ),
          ),
          if (isBestValue) const _BestValueBadge(),
        ],
      ),
    );
  }
}

class _RadioIndicatorVariantB extends StatelessWidget {
  final bool isSelected;

  const _RadioIndicatorVariantB({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.white38,
          width: 2,
        ),
        color: isSelected ? AppColors.primary : Colors.transparent,
      ),
      child:
          isSelected
              ? const Icon(Icons.check, size: 16, color: AppColors.white)
              : null,
    );
  }
}

class _BestValueBadge extends StatelessWidget {
  const _BestValueBadge();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -10,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Best Value',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
