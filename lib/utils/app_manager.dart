import 'package:flutter/material.dart';

class AppManager {
  AppManager._privateConstructor();

  static final AppManager instance = AppManager._privateConstructor();

  final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

  // Player keys
  final GlobalKey<NavigatorState> playerSoloChallengesKey = GlobalKey<NavigatorState>();

  // Admin keys
  final GlobalKey<NavigatorState> adminSoloChallengesKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> adminTeamChallengesKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> adminTeamsKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> adminUsersKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> adminFormsKey = GlobalKey<NavigatorState>();

  // Global keys
  final GlobalKey<NavigatorState> soloWaitingValidationsKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> teamChallengesKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> profileKey = GlobalKey<NavigatorState>();

  // To avoid providders issue we need this
  void popToFirstRoute(BuildContext context) {
    if (playerSoloChallengesKey.currentState != null) {
      playerSoloChallengesKey.currentState!.popUntil((route) => route.isFirst);
    }

    if (adminSoloChallengesKey.currentState != null) {
      adminSoloChallengesKey.currentState!.popUntil((route) => route.isFirst);
    }

    if (adminTeamsKey.currentState != null) {
      adminTeamsKey.currentState!.popUntil((route) => route.isFirst);
    }

    if (adminTeamChallengesKey.currentState != null) {
      adminTeamChallengesKey.currentState!.popUntil((route) => route.isFirst);
    }

    if (adminUsersKey.currentState != null) {
      adminUsersKey.currentState!.popUntil((route) => route.isFirst);
    }

    if (adminFormsKey.currentState != null) {
      adminFormsKey.currentState!.popUntil((route) => route.isFirst);
    }

    if (soloWaitingValidationsKey.currentState != null) {
      soloWaitingValidationsKey.currentState!.popUntil((route) => route.isFirst);
    }

    if (teamChallengesKey.currentState != null) {
      teamChallengesKey.currentState!.popUntil((route) => route.isFirst);
    }

    if (profileKey.currentState != null) {
      profileKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

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
    if (adminSoloChallengesKey.currentState != null && adminSoloChallengesKey.currentState!.canPop()) {
      adminSoloChallengesKey.currentState!.pop();
      return Future.value(false);
    }

    if (adminTeamChallengesKey.currentState != null && adminTeamChallengesKey.currentState!.canPop()) {
      adminTeamChallengesKey.currentState!.pop();
      return Future.value(false);
    }

    if (adminTeamsKey.currentState != null && adminTeamsKey.currentState!.canPop()) {
      adminTeamsKey.currentState!.pop();
      return Future.value(false);
    }

    if (adminUsersKey.currentState != null && adminUsersKey.currentState!.canPop()) {
      adminUsersKey.currentState!.pop();
      return Future.value(false);
    }

    if (adminFormsKey.currentState != null && adminFormsKey.currentState!.canPop()) {
      adminFormsKey.currentState!.pop();
      return Future.value(false);
    }

    // Global ones
    if (soloWaitingValidationsKey.currentState != null && soloWaitingValidationsKey.currentState!.canPop()) {
      soloWaitingValidationsKey.currentState!.pop();
      return Future.value(false);
    }

    if (teamChallengesKey.currentState != null && teamChallengesKey.currentState!.canPop()) {
      teamChallengesKey.currentState!.pop();
      return Future.value(false);
    }

    if (profileKey.currentState != null && profileKey.currentState!.canPop()) {
      profileKey.currentState!.pop();
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