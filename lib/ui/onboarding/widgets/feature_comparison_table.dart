import 'package:flutter/material.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

import 'feature_icon.dart';
import 'feature_row_without_pro.dart';

class FeatureComparisonTable extends StatelessWidget {
  final bool hasDailyMovieSuggestionsPro;
  final bool hasAiPoweredInsightsPro;
  final bool hasPersonalizedWatchlistsPro;
  final bool hasAdFreeExperiencePro;

  const FeatureComparisonTable({
    super.key,
    required this.hasDailyMovieSuggestionsPro,
    required this.hasAiPoweredInsightsPro,
    required this.hasPersonalizedWatchlistsPro,
    required this.hasAdFreeExperiencePro,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      width: 60,
                      child: Center(
                        child: Text('FREE', style: AppTextStyles.bodyLarge),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const FeatureRowWithoutPro(
                  feature: 'Daily Movie Suggestions',
                  freeIncluded: true,
                ),
                const SizedBox(height: 12),
                const FeatureRowWithoutPro(
                  feature: 'AI-Powered Movie Insights',
                  freeIncluded: false,
                ),
                const SizedBox(height: 12),
                const FeatureRowWithoutPro(
                  feature: 'Personalized Watchlists',
                  freeIncluded: false,
                ),
                const SizedBox(height: 12),
                const FeatureRowWithoutPro(
                  feature: 'Ad-Free Experience',
                  freeIncluded: false,
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Column(
            children: [
              Text('PRO', style: AppTextStyles.bodyLarge),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: FeatureIcon(
                  key: ValueKey(hasDailyMovieSuggestionsPro),
                  included: hasDailyMovieSuggestionsPro,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: FeatureIcon(
                  key: ValueKey(hasAiPoweredInsightsPro),
                  included: hasAiPoweredInsightsPro,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: FeatureIcon(
                  key: ValueKey(hasPersonalizedWatchlistsPro),
                  included: hasPersonalizedWatchlistsPro,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: FeatureIcon(
                  key: ValueKey(hasAdFreeExperiencePro),
                  included: hasAdFreeExperiencePro,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
