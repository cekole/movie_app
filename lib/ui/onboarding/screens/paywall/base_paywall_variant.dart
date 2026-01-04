import 'package:flutter/material.dart';

import '../../../../config/ab_testing_config.dart';

abstract class BasePaywallVariant extends StatefulWidget {
  final VoidCallback onContinue;

  const BasePaywallVariant({super.key, required this.onContinue});

  PaywallVariant get variant;
}

/// Mixin providing common paywall functionality
mixin PaywallAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController fadeController;
  late AnimationController slideController;
  late AnimationController scaleController;

  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;

  @protected
  void initPaywallAnimations() {
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeOut,
    );

    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: slideController, curve: Curves.easeOutCubic),
    );

    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    scaleAnimation = CurvedAnimation(
      parent: scaleController,
      curve: Curves.elasticOut,
    );
  }

  @protected
  void startPaywallAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    slideController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    scaleController.forward();
  }

  @protected
  void disposePaywallAnimations() {
    fadeController.dispose();
    slideController.dispose();
    scaleController.dispose();
  }
}
