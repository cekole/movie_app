import 'package:flutter/material.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

class AutoRenewableText extends StatelessWidget {
  const AutoRenewableText({super.key});

  static const Color _greenColor = Color(0xFF2ECC71);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: _greenColor,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        Text('Auto Renewable, Cancel Anytime', style: AppTextStyles.labelSmall),
      ],
    );
  }
}
