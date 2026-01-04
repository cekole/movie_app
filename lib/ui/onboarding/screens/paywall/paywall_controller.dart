import 'package:flutter/material.dart';

import '../../../../config/ab_testing_config.dart';
import '../../../../data/services/ab_testing_service.dart';
import 'paywall_variant_a.dart';
import 'paywall_variant_b.dart';

class PaywallVariantFactory {
  static final Map<PaywallVariant, Widget Function(VoidCallback onContinue)>
  _variantBuilders = {
    PaywallVariant.variantA:
        (onContinue) => PaywallVariantA(onContinue: onContinue),
    PaywallVariant.variantB:
        (onContinue) => PaywallVariantB(onContinue: onContinue),
  };

  static Widget create({
    required PaywallVariant variant,
    required VoidCallback onContinue,
  }) {
    final builder = _variantBuilders[variant];
    if (builder == null) {
      // Fallback to variant A if unknown variant
      return PaywallVariantA(onContinue: onContinue);
    }
    return builder(onContinue);
  }

  static void registerVariant(
    PaywallVariant variant,
    Widget Function(VoidCallback onContinue) builder,
  ) {
    _variantBuilders[variant] = builder;
  }
}

class PaywallController extends StatefulWidget {
  final VoidCallback onContinue;

  final PaywallVariant? forcedVariant;

  const PaywallController({
    super.key,
    required this.onContinue,
    this.forcedVariant,
  });

  @override
  State<PaywallController> createState() => _PaywallControllerState();
}

class _PaywallControllerState extends State<PaywallController> {
  PaywallVariant? _variant;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVariant();
  }

  Future<void> _loadVariant() async {
    if (widget.forcedVariant != null) {
      setState(() {
        _variant = widget.forcedVariant;
        _isLoading = false;
      });
      return;
    }

    final variant = await ABTestingService.instance.getPaywallVariant();
    if (mounted) {
      setState(() {
        _variant = variant;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _variant == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PaywallVariantFactory.create(
      variant: _variant!,
      onContinue: widget.onContinue,
    );
  }
}
