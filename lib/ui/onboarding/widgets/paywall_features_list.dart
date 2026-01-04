import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';

class PaywallFeaturesList extends StatelessWidget {
  const PaywallFeaturesList({super.key});

  static const List<String> _features = [
    'Daily Movie Suggestions',
    'AI-Powered Movie Insights',
    'Personalized Watchlists',
    'Ad-Free Experience',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                _features
                    .map((feature) => PaywallFeatureItem(feature: feature))
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class PaywallFeatureItem extends StatelessWidget {
  final String feature;

  const PaywallFeatureItem({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, color: AppColors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            feature,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
