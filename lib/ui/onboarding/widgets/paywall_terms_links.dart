import 'package:flutter/material.dart';
import 'package:movie_app/ui/core/themes/app_text_styles.dart';

class PaywallTermsLinks extends StatelessWidget {
  final VoidCallback? onTermsOfUse;
  final VoidCallback? onRestorePurchase;
  final VoidCallback? onPrivacyPolicy;

  const PaywallTermsLinks({
    super.key,
    this.onTermsOfUse,
    this.onRestorePurchase,
    this.onPrivacyPolicy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _TermLink(text: 'Terms of Use', onTap: onTermsOfUse),
        _TermLink(text: 'Restore Purchase', onTap: onRestorePurchase),
        _TermLink(text: 'Privacy Policy', onTap: onPrivacyPolicy),
      ],
    );
  }
}

class _TermLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const _TermLink({required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(text, style: AppTextStyles.labelSmall),
    );
  }
}
