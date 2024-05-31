import 'package:flutter_riverpod/flutter_riverpod.dart';

class Loved extends StateNotifier<bool> {
  Loved() : super(false);
  void lovePressed() {
    state = !state;
  }
}
