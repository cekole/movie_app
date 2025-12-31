import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

class ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  final String text;

  const ContinueButton({
    super.key,
    required this.enabled,
    required this.onPressed,
    this.text = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              enabled
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.5),
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                enabled
                    ? AppColors.white
                    : AppColors.white.withValues(alpha: 0.5),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
