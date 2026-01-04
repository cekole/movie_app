import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movie_app/config/app_config.dart';
import 'package:movie_app/ui/core/themes/app_text_styles.dart';

import '../../../../config/ab_testing_config.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
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
    final responsive = context.responsive;
    final heroHeightRatio = responsive.ratio(
      small: 0.4,
      medium: 0.5,
      large: 0.55,
    );
    final contentTopRatio = responsive.ratio(
      small: 0.22,
      medium: 0.3,
      large: 0.35,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SizedBox(
            height: responsive.screenHeight * heroHeightRatio,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRect(
                  child: Transform.scale(
                    scale: responsive.screenWidth / responsive.screenHeight * 3,
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
              top: responsive.screenHeight * contentTopRatio,
            ),
            child: _PaywallVariantBContent(
              viewModel: _viewModel,
              fadeAnimation: fadeAnimation,
              slideAnimation: slideAnimation,
              scaleAnimation: scaleAnimation,
              onContinue: widget.onContinue,
              responsive: responsive,
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
  final ResponsiveUtils responsive;

  const _PaywallVariantBContent({
    required this.viewModel,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.scaleAnimation,
    required this.onContinue,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.horizontalPaddingLarge,
      ),
      child: Column(
        children: [
          FadeTransition(
            opacity: fadeAnimation,
            child: Text(
              AppConfig.appName,
              style: AppTextStyles.headline1.copyWith(
                fontSize: responsive.fontSize(small: 26, medium: 32, large: 36),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: responsive.spacing(small: 16, medium: 24, large: 32),
          ),
          SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: const PaywallFeaturesList(),
            ),
          ),
          SizedBox(
            height: responsive.spacing(small: 20, medium: 32, large: 40),
          ),
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
                      SizedBox(
                        height: responsive.spacing(
                          small: 8,
                          medium: 12,
                          large: 12,
                        ),
                      ),
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
          SizedBox(
            height: responsive.spacingByDevice(
              phone: 16,
              tablet: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          FadeTransition(
            opacity: fadeAnimation,
            child: const AutoRenewableText(),
          ),
          SizedBox(
            height: responsive.spacing(small: 10, medium: 16, large: 16),
          ),
          Observer(
            builder:
                (_) => PaywallCTAButton(
                  text: 'Continue',
                  onPressed: onContinue,
                  showArrow: true,
                ),
          ),
          SizedBox(
            height: responsive.spacing(small: 10, medium: 16, large: 16),
          ),
          FadeTransition(
            opacity: fadeAnimation,
            child: const PaywallTermsLinks(),
          ),
          SizedBox(
            height: responsive.spacing(small: 16, medium: 24, large: 24),
          ),
        ],
      ),
    );
  }
}
