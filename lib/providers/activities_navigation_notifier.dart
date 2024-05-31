import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'activities_navigation_notifier.g.dart';

@riverpod
class ActivitiesNavigationNotifier extends _$ActivitiesNavigationNotifier {
  @override
  build() {
    return 1;
  }

  void setSelectedIndex(int index) {
    state = index;
  }
}
