import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'players_navigation_notifier.g.dart';

@riverpod
class PlayersNavigationNotifier extends _$PlayersNavigationNotifier {
  @override
  build() {
    return 3;
  }

  void setSelectedIndex(int index) {
    state = index;
  }
}
