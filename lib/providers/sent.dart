import 'package:flutter_riverpod/flutter_riverpod.dart';

class Sent extends StateNotifier<bool> {
  Sent() : super(false);
  void sentPressed() {
    state = !state;
  }
}
