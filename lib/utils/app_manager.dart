import 'package:flutter/material.dart';

class AppManager {
  AppManager._privateConstructor();

  static final AppManager instance = AppManager._privateConstructor();

  final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

  // Player keys
  final GlobalKey<NavigatorState> playerSoloChallengesKey = GlobalKey<NavigatorState>();

  // Admin keys
  final GlobalKey<NavigatorState> adminTeamsKey = GlobalKey<NavigatorState>();

  // Global keys
  final GlobalKey<NavigatorState> soloWaitingValidationsKey = GlobalKey<NavigatorState>();

  // Because we are calling this from the main widget we have to check
  // nested navigators status.
  Future<bool?> showCloseAppConfirmation(BuildContext context) {
    // Check current context navigator Main App Navigator
    // Players ones
    if (playerSoloChallengesKey.currentState != null && playerSoloChallengesKey.currentState!.canPop()) {
      playerSoloChallengesKey.currentState!.pop();
      return Future.value(false);
    }

    // Admin ones
    if (adminTeamsKey.currentState != null && adminTeamsKey.currentState!.canPop()) {
      adminTeamsKey.currentState!.pop();
      return Future.value(false);
    }

    // Global ones
    if (soloWaitingValidationsKey.currentState != null && soloWaitingValidationsKey.currentState!.canPop()) {
      soloWaitingValidationsKey.currentState!.pop();
      return Future.value(false);
    }

    if (appNavigatorKey.currentState!.canPop()) {
      appNavigatorKey.currentState!.pop();
      return Future.value(false);
    }

    // We show the close app confirmation dialog
    return showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text("Etes vous sur de vouloir quitter l'application ?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }
}