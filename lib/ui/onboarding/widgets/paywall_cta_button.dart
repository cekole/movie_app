import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

class PaywallCTAButton extends StatefulWidget {
  final String text;
  final bool twoLines;
  final bool enableWidthPulse;
  final VoidCallback onPressed;

  const PaywallCTAButton({
    super.key,
    required this.text,
    required this.twoLines,
    this.enableWidthPulse = false,
    required this.onPressed,
  });

  @override
  State<PaywallCTAButton> createState() => _PaywallCTAButtonState();
}

class _PaywallCTAButtonState extends State<PaywallCTAButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _widthPulseController;
  late Animation<double> _widthPulseAnimation;

  @override
  void initState() {
    super.initState();
    _widthPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _widthPulseAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _widthPulseController, curve: Curves.easeInOut),
    );

    if (widget.enableWidthPulse) {
      _widthPulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PaywallCTAButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enableWidthPulse && !oldWidget.enableWidthPulse) {
      _widthPulseController.repeat(reverse: true);
    } else if (!widget.enableWidthPulse && oldWidget.enableWidthPulse) {
      _widthPulseController.stop();
      _widthPulseController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  @override
  void dispose() {
    _widthPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _widthPulseAnimation,
      builder: (context, child) {
        final widthFactor =
            widget.enableWidthPulse ? _widthPulseAnimation.value : 1.0;
        return FractionallySizedBox(
          widthFactor: widthFactor,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: widget.twoLines ? 64 : 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  widget.text,
                  key: ValueKey(widget.text),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
