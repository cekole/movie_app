import 'package:mobx/mobx.dart';

import '../../../config/ab_testing_config.dart';
import '../../../data/services/ab_testing_service.dart';

part 'paywall_controller_view_model.g.dart';

class PaywallControllerViewModel = PaywallControllerViewModelBase
    with _$PaywallControllerViewModel;

abstract class PaywallControllerViewModelBase with Store {
  @observable
  PaywallVariant? variant;

  @observable
  bool isLoading = true;

  @action
  Future<void> loadVariant({PaywallVariant? forcedVariant}) async {
    if (forcedVariant != null) {
      variant = forcedVariant;
      isLoading = false;
      return;
    }

    final loadedVariant = await ABTestingService.instance.getPaywallVariant();
    variant = loadedVariant;
    isLoading = false;
  }
}
