import 'package:mobx/mobx.dart';

part 'paywall_view_model.g.dart';

enum SubscriptionPlan { weekly, monthly, yearly }

class PaywallViewModel = PaywallViewModelBase with _$PaywallViewModel;

abstract class PaywallViewModelBase with Store {
  @observable
  SubscriptionPlan selectedPlan = SubscriptionPlan.yearly;

  @observable
  bool enableFreeTrial = false;

  @computed
  bool get hasDailyMovieSuggestionsPro => true;

  @computed
  bool get hasAiPoweredInsightsPro => true;

  @computed
  bool get hasPersonalizedWatchlistsPro =>
      selectedPlan == SubscriptionPlan.monthly ||
      selectedPlan == SubscriptionPlan.yearly;

  @computed
  bool get hasAdFreeExperiencePro => selectedPlan == SubscriptionPlan.yearly;

  @computed
  String get ctaButtonText =>
      enableFreeTrial ? '3 Days Free\nNo Payment Now' : 'Unlock MovieAI PRO';

  @computed
  bool get ctaButtonTwoLines => enableFreeTrial;

  @action
  void selectPlan(SubscriptionPlan plan) {
    selectedPlan = plan;
  }

  @action
  void toggleFreeTrial() {
    enableFreeTrial = !enableFreeTrial;
  }

  @action
  void setFreeTrial(bool value) {
    enableFreeTrial = value;
  }
}
