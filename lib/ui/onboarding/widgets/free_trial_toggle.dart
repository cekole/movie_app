import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/ui/core/themes/themes.dart';

class FreeTrialToggle extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const FreeTrialToggle({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Enable Free Trial', style: AppTextStyles.bodyLarge),
          GestureDetector(
            onTap: () => onChanged(!enabled),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 52,
              height: 30,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color:
                    enabled
                        ? const Color(0xFF2ECC71)
                        : Colors.white.withValues(alpha: 0.3),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment:
                    enabled ? Alignment.centerRight : Alignment.centerLeft,
                child: CupertinoSwitch(value: enabled, onChanged: onChanged),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
