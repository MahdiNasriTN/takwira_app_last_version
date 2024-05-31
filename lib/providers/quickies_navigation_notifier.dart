import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'quickies_navigation_notifier.g.dart';

@riverpod
class QuickiesNavigationNotifier extends _$QuickiesNavigationNotifier {
  @override
  build() {
    return 0;
  }

  void setSelectedIndex(int index) {
    state = index;
  }
}
