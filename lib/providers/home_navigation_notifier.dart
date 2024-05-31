import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_navigation_notifier.g.dart';

@riverpod
class HomeNavigationNotifier extends _$HomeNavigationNotifier {
  @override
  build() {
    return 2;
  }

  void setSelectedIndex(int index) {
    state = index;
  }
}
