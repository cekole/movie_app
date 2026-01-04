import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

class PaywallCloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PaywallCloseButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 16,
      child: IconButton(
        onPressed: onPressed,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: AppColors.white, size: 20),
        ),
      ),
    );
  }
}
