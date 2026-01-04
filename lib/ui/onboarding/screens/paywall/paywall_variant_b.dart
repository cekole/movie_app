import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movie_app/config/app_config.dart';
import 'package:movie_app/ui/core/themes/app_text_styles.dart';

import '../../../../config/ab_testing_config.dart';
import '../../../core/themes/app_colors.dart';
import '../../view_model/paywall_view_model.dart';
import '../../widgets/auto_renewable_text.dart';
import '../../widgets/paywall_close_button.dart';
import '../../widgets/paywall_cta_button.dart';
import '../../widgets/paywall_features_list.dart';
import '../../widgets/paywall_terms_links.dart';
import '../../widgets/subscription_option_variant_b.dart';
import 'base_paywall_variant.dart';

class PaywallVariantB extends BasePaywallVariant {
  const PaywallVariantB({super.key, required super.onContinue});

  @override
  PaywallVariant get variant => PaywallVariant.variantB;

  @override
  State<PaywallVariantB> createState() => _PaywallVariantBState();
}

class _PaywallVariantBState extends State<PaywallVariantB>
    with TickerProviderStateMixin, PaywallAnimationMixin {
  final PaywallViewModel _viewModel = PaywallViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.selectPlan(SubscriptionPlan.yearly);
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
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRect(
                  child: Transform.scale(
                    scale:
                        MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height *
                        3,
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/images/paywall_hero.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primary.withValues(alpha: 0.3),
                                AppColors.background,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Gradient overlay for smooth transition to content
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.6, 1.0],
                      colors: [
                        Colors.transparent,
                        AppColors.background.withValues(alpha: 0.5),
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.3,
            ),
            child: _PaywallVariantBContent(
              viewModel: _viewModel,
              fadeAnimation: fadeAnimation,
              slideAnimation: slideAnimation,
              scaleAnimation: scaleAnimation,
              onContinue: widget.onContinue,
            ),
          ),

          PaywallCloseButton(onPressed: widget.onContinue),
        ],
      ),
    );
  }
}

/// Content section for Variant B paywall
class _PaywallVariantBContent extends StatelessWidget {
  final PaywallViewModel viewModel;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> scaleAnimation;
  final VoidCallback onContinue;

  const _PaywallVariantBContent({
    required this.viewModel,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.scaleAnimation,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          FadeTransition(
            opacity: fadeAnimation,
            child: Text(
              AppConfig.appName,
              style: AppTextStyles.headline1.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: const PaywallFeaturesList(),
            ),
          ),
          const SizedBox(height: 32),
          ScaleTransition(
            scale: scaleAnimation,
            child: Observer(
              builder:
                  (_) => Column(
                    children: [
                      SubscriptionOptionVariantB(
                        title: 'Monthly',
                        monthlyPrice: '\$11,99/month',
                        weeklyPrice: '\$2,99 / week',
                        isSelected:
                            viewModel.selectedPlan == SubscriptionPlan.monthly,
                        onTap:
                            () =>
                                viewModel.selectPlan(SubscriptionPlan.monthly),
                      ),
                      const SizedBox(height: 12),
                      SubscriptionOptionVariantB(
                        title: 'Yearly',
                        monthlyPrice: '\$44,99/month',
                        weeklyPrice: '\$0,96 / week',
                        isSelected:
                            viewModel.selectedPlan == SubscriptionPlan.yearly,
                        isBestValue: true,
                        onTap:
                            () => viewModel.selectPlan(SubscriptionPlan.yearly),
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
                  text: 'Continue',
                  onPressed: onContinue,
                  showArrow: true,
                ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: fadeAnimation,
            child: const PaywallTermsLinks(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
