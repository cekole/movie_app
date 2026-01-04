import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../config/ab_testing_config.dart';
import '../../view_model/paywall_controller_view_model.dart';
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
  final PaywallControllerViewModel _viewModel = PaywallControllerViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadVariant(forcedVariant: widget.forcedVariant);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_viewModel.isLoading || _viewModel.variant == null) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return PaywallVariantFactory.create(
          variant: _viewModel.variant!,
          onContinue: widget.onContinue,
        );
      },
    );
  }
}
