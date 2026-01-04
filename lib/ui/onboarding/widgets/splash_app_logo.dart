import 'package:flutter/material.dart';
import 'package:movie_app/config/app_config.dart';

import '../../core/themes/app_colors.dart';

/// App logo widget for splash screen with branding
class SplashAppLogo extends StatelessWidget {
  const SplashAppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App Logo Container
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.movie_creation_outlined,
            size: 60,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 24),
        // App Name
        const Text(
          AppConfig.appName,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
