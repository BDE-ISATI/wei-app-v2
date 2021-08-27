import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/services/authentication_service.dart';
import 'package:isati_integration/services/users_service.dart';
import 'package:isati_integration/utils/colors.dart';

class AppUserStore with ChangeNotifier {
  User? _user;

  Future<User?> get loggedUser async {
    final shouldShowSplashScreenAgain = _user == null;

    await Future<void>.delayed(const Duration(seconds: 2));
    _user ??= await AuthenticationService.instance.getLoggedUser();

    if (_user != null) {
      if (_user!.team != null) {
        colorPrimary = _user!.team!.teamColor.toColor();
      }

      if (shouldShowSplashScreenAgain) {
        notifyListeners();
      }
    }

    return _user;
  }

  Future refresh({bool shouldNotify = false}) async {
    try {
      final newUser = await UsersService.instance.getUser(id!, authorization: authenticationHeader);
      newUser.token = _user!.token;

      _user = newUser;

      if (shouldNotify) {
        notifyListeners();
      }
    } on Exception {
      log("error refreshing the user");
    }
  }

  void loginUser(User loggedUser) {
    _user = loggedUser;

    if (_user!.team != null) {
      colorPrimary = _user!.team!.teamColor.toColor();
    }

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

  void hasBeenUpdated() {
    notifyListeners();
  }
}