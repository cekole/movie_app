import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../config/ab_testing_config.dart';

class ABTestingService {
  static ABTestingService? _instance;
  final Random _random = Random();

  PaywallVariant? _cachedPaywallVariant;
  PaywallVariant? _remotePaywallVariant;

  ABTestingService._();

  static ABTestingService get instance {
    return _instance ??= ABTestingService._();
  }

  factory ABTestingService() => instance;

  void setRemotePaywallVariant(PaywallVariant? variant) {
    _remotePaywallVariant = variant;
  }

  Future<PaywallVariant> getPaywallVariant({
    Map<PaywallVariant, int>? customWeights,
  }) async {
    if (_remotePaywallVariant != null) {
      return _remotePaywallVariant!;
    }

    if (_cachedPaywallVariant != null) {
      return _cachedPaywallVariant!;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedVariantId = prefs.getString(ABTestingConfig.paywallVariantKey);

    if (savedVariantId != null) {
      _cachedPaywallVariant = PaywallVariant.fromId(savedVariantId);
      return _cachedPaywallVariant!;
    }

    final weights = customWeights ?? ABTestingConfig.defaultPaywallWeights;
    _cachedPaywallVariant = _assignVariant(weights);

    await prefs.setString(
      ABTestingConfig.paywallVariantKey,
      _cachedPaywallVariant!.id,
    );

    return _cachedPaywallVariant!;
  }

  /// Assign a variant based on weighted random selection
  PaywallVariant _assignVariant(Map<PaywallVariant, int> weights) {
    final totalWeight = weights.values.fold(0, (sum, w) => sum + w);
    final randomValue = _random.nextInt(totalWeight);

    int cumulativeWeight = 0;
    for (final entry in weights.entries) {
      cumulativeWeight += entry.value;
      if (randomValue < cumulativeWeight) {
        return entry.key;
      }
    }

    // Fallback to first variant
    return weights.keys.first;
  }

  Future<void> resetPaywallVariant() async {
    _cachedPaywallVariant = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ABTestingConfig.paywallVariantKey);
  }

  Future<void> forcePaywallVariant(PaywallVariant variant) async {
    _cachedPaywallVariant = variant;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ABTestingConfig.paywallVariantKey, variant.id);
  }

  PaywallVariant? get currentPaywallVariant => _cachedPaywallVariant;
}
