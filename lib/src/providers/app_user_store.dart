import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/services/authentication_service.dart';

class AppUserStore with ChangeNotifier {
  User? _user;

  Future<User?> get loggedUser async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return _user ??= await AuthenticationService.instance.getLoggedUser();
  }

  void loginUser(User loggedUser) {
    _user = loggedUser;

    notifyListeners();
  }

  Future logout() async {
    await AuthenticationService.instance.logoutUser();
    _user = null;

    notifyListeners();
  }

  User? get user => _user;

  String? get id => (_user != null) ? _user!.id : null;
  String get authenticationHeader => (_user != null) ? _user!.authenticationHeader : "Invalid";
}