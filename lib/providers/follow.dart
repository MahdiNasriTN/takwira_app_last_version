import 'package:flutter_riverpod/flutter_riverpod.dart';

class Follow extends StateNotifier<bool> {
  Follow() : super(true);
  void followPressed() {
    state = !state;
  }
}
