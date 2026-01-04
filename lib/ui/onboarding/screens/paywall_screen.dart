import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movie_app/config/app_config.dart';
import 'package:movie_app/ui/core/themes/app_text_styles.dart';

import '../../core/themes/app_colors.dart';
import '../view_model/paywall_view_model.dart';
import '../widgets/auto_renewable_text.dart';
import '../widgets/feature_comparison_table.dart';
import '../widgets/free_trial_toggle.dart';
import '../widgets/paywall_cta_button.dart';
import '../widgets/paywall_terms_links.dart';
import '../widgets/subscription_option_card.dart';

class PaywallScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const PaywallScreen({super.key, required this.onContinue});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen>
    with TickerProviderStateMixin {
  final PaywallViewModel _viewModel = PaywallViewModel();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
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
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
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
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
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
                scale: _scaleAnimation,
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
                opacity: _fadeAnimation,
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
                opacity: _fadeAnimation,
                child: const PaywallTermsLinks(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
