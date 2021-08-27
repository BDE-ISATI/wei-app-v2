import 'package:flutter/material.dart';
import 'package:isati_integration/models/team_challenge.dart';
import 'package:isati_integration/services/team_challenges_service.dart';

class TeamChallengesStore with ChangeNotifier {
  Map<String, TeamChallenge>? _challenges;

  Future<List<TeamChallenge>> getChallenges(String authorization, {bool forceRefresh = false}) async {
    if (forceRefresh) {
      _challenges = null;
    }

    _challenges ??= await TeamChallengesService.instance.getChallenges(authorization);

    return _challenges!.values.toList();
  } 

  Map<String, TeamChallenge> get challenges => _challenges!;
  List<TeamChallenge> get challengesList => _challenges!.values.toList();

  void receivedUpdate() {
    notifyListeners();
  }

  void addChallenge(TeamChallenge challenge) {
    _challenges![challenge.id!] = challenge;

    notifyListeners();
  }
}