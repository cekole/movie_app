import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movie_app/config/app_config.dart';
import 'package:movie_app/ui/core/themes/app_text_styles.dart';

import '../../../../config/ab_testing_config.dart';
import '../../../core/themes/app_colors.dart';
import '../../view_model/paywall_view_model.dart';
import '../../widgets/auto_renewable_text.dart';
import '../../widgets/feature_comparison_table.dart';
import '../../widgets/free_trial_toggle.dart';
import '../../widgets/paywall_cta_button.dart';
import '../../widgets/paywall_terms_links.dart';
import '../../widgets/subscription_option_card.dart';
import 'base_paywall_variant.dart';

class PaywallVariantA extends BasePaywallVariant {
  const PaywallVariantA({super.key, required super.onContinue});

  @override
  PaywallVariant get variant => PaywallVariant.variantA;

  @override
  State<PaywallVariantA> createState() => _PaywallVariantAState();
}

class _PaywallVariantAState extends State<PaywallVariantA>
    with TickerProviderStateMixin, PaywallAnimationMixin {
  final PaywallViewModel _viewModel = PaywallViewModel();

  @override
  void initState() {
    super.initState();
    initPaywallAnimations();
    startPaywallAnimations();
  }

  @override
  void dispose() {
    disposePaywallAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(AppConfig.appName, style: AppTextStyles.headline2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: widget.onContinue,
              icon: const Icon(Icons.close, color: AppColors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Feature comparison table
              SlideTransition(
                position: slideAnimation,
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: Observer(
                    builder:
                        (_) => FeatureComparisonTable(
                          hasDailyMovieSuggestionsPro:
                              _viewModel.hasDailyMovieSuggestionsPro,
                          hasAiPoweredInsightsPro:
                              _viewModel.hasAiPoweredInsightsPro,
                          hasPersonalizedWatchlistsPro:
                              _viewModel.hasPersonalizedWatchlistsPro,
                          hasAdFreeExperiencePro:
                              _viewModel.hasAdFreeExperiencePro,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SlideTransition(
                position: slideAnimation,
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: Observer(
                    builder:
                        (_) => FreeTrialToggle(
                          enabled: _viewModel.enableFreeTrial,
                          onChanged: (value) => _viewModel.setFreeTrial(value),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ScaleTransition(
                scale: scaleAnimation,
                child: Observer(
                  builder:
                      (_) => Column(
                        spacing: 16,
                        children: [
                          SubscriptionOptionCard(
                            plan: SubscriptionPlan.weekly,
                            title: 'Weekly',
                            price: '\$4,99 / week',
                            subtitle: 'Only \$4,99 per week',
                            isSelected:
                                _viewModel.selectedPlan ==
                                SubscriptionPlan.weekly,
                            onTap:
                                () => _viewModel.selectPlan(
                                  SubscriptionPlan.weekly,
                                ),
                          ),
                          SubscriptionOptionCard(
                            plan: SubscriptionPlan.monthly,
                            title: 'Monthly',
                            price: '\$11,99 / month',
                            subtitle: 'Only \$2,99 per week',
                            isSelected:
                                _viewModel.selectedPlan ==
                                SubscriptionPlan.monthly,
                            onTap:
                                () => _viewModel.selectPlan(
                                  SubscriptionPlan.monthly,
                                ),
                          ),
                          SubscriptionOptionCard(
                            plan: SubscriptionPlan.yearly,
                            title: 'Yearly',
                            price: '\$49,99 / year',
                            subtitle: 'Only \$0,96 per week',
                            isSelected:
                                _viewModel.selectedPlan ==
                                SubscriptionPlan.yearly,
                            isBestValue: true,
                            onTap:
                                () => _viewModel.selectPlan(
                                  SubscriptionPlan.yearly,
                                ),
                          ),
                        ],
                      ),
                ),
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: fadeAnimation,
                child: const AutoRenewableText(),
              ),
              const SizedBox(height: 16),
              Observer(
                builder:
                    (_) => PaywallCTAButton(
                      text: _viewModel.ctaButtonText,
                      twoLines: _viewModel.ctaButtonTwoLines,
                      enableWidthPulse: _viewModel.enableFreeTrial,
                      onPressed: widget.onContinue,
                    ),
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: fadeAnimation,
                child: const PaywallTermsLinks(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
