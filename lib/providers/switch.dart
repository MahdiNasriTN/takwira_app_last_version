import 'package:flutter_riverpod/flutter_riverpod.dart';

class Switched extends StateNotifier<bool> {
  Switched() : super(false);
  void toggleSwitch(bool value) {
    if (state == false) {
      state = true;
    } else {
      state = false;
    }
  }
}
