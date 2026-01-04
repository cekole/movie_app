import 'package:flutter/material.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

import '../view_model/paywall_view_model.dart';

class SubscriptionOptionCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final String title;
  final String price;
  final String subtitle;
  final bool isSelected;
  final bool isBestValue;
  final VoidCallback onTap;

  const SubscriptionOptionCard({
    super.key,
    required this.plan,
    required this.title,
    required this.price,
    required this.subtitle,
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.white24,
              ),
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                // Radio button
                _RadioIndicator(isSelected: isSelected),
                const SizedBox(width: 14),
                // Title and subtitle
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
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.grayDark,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Price
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Best Value badge
          if (isBestValue) const _BestValueBadge(),
        ],
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool isSelected;

  const _RadioIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
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
              ? const Center(
                child: Icon(Icons.check, color: AppColors.white, size: 14),
              )
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
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.redLight,
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
      ),
    );
  }
}
