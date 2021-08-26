
import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';

class UserStore with ChangeNotifier {
  final User user;

  UserStore(this.user);

  void hasBeenUpdated() {
    notifyListeners();
  }
}