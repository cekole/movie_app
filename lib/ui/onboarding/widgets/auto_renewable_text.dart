import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

class AutoRenewableText extends StatelessWidget {
  const AutoRenewableText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/shield_check.svg',
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 8),
        Text('Auto Renewable, Cancel Anytime', style: AppTextStyles.labelSmall),
      ],
    );
  }
}
