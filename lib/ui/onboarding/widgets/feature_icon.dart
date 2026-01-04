import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

class FeatureIcon extends StatelessWidget {
  final bool included;

  const FeatureIcon({super.key, required this.included});

  static const Color greenColor = Color(0xFF2ECC71);

  @override
  Widget build(BuildContext context) {
    return Icon(
      included ? Icons.check_circle : Icons.cancel,
      color: included ? greenColor : AppColors.gray,
    );
  }
}
