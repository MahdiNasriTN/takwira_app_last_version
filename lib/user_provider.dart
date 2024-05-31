import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  bool get isAuthenticated => _user != null;
}

class User {
  final String username;
  final String email;

  User({required this.username, required this.email});
}
