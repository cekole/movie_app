enum PaywallVariant {
  variantA('variant_a', 'Original table-based paywall'),
  variantB('variant_b', 'Image hero paywall with features list');

  final String id;
  final String description;

  const PaywallVariant(this.id, this.description);

  static PaywallVariant fromId(String id) {
    return PaywallVariant.values.firstWhere(
      (v) => v.id == id,
      orElse: () => PaywallVariant.variantA,
    );
  }
}

abstract class ABTestingConfig {
  static const String paywallVariantKey = 'ab_paywall_variant';

  /// Default variant weights for random assignment
  static const Map<PaywallVariant, int> defaultPaywallWeights = {
    PaywallVariant.variantA: 50,
    PaywallVariant.variantB: 50,
  };
}
