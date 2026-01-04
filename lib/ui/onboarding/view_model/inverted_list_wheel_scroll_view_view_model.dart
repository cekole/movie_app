import 'package:mobx/mobx.dart';

part 'inverted_list_wheel_scroll_view_view_model.g.dart';

class InvertedListWheelScrollViewViewModel = InvertedListWheelScrollViewViewModelBase
    with _$InvertedListWheelScrollViewViewModel;

abstract class InvertedListWheelScrollViewViewModelBase with Store {
  @observable
  double scrollOffset = 0;

  @action
  void updateScrollOffset(double offset) {
    scrollOffset = offset;
  }
}
