import 'package:flutter/material.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

import 'feature_icon.dart';

class FeatureRowWithoutPro extends StatelessWidget {
  final String feature;
  final bool freeIncluded;

  const FeatureRowWithoutPro({
    super.key,
    required this.feature,
    required this.freeIncluded,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(feature, style: AppTextStyles.bodyMedium)),
        SizedBox(
          width: 60,
          child: Center(child: FeatureIcon(included: freeIncluded)),
        ),
      ],
    );
  }
}
