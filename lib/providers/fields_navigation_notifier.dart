import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'fields_navigation_notifier.g.dart';

@riverpod
class FieldsNavigationNotifier extends _$FieldsNavigationNotifier {
  @override
  build() {
    return 4;
  }

  void setSelectedIndex(int index) {
    state = index;
  }
}
