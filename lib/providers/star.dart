import 'package:flutter_riverpod/flutter_riverpod.dart';

class Star extends StateNotifier<int> {
  Star() : super(0);

  void starFilled(int index) {
    state = index + 1;
  }
}
