import 'package:flutter/material.dart';
import 'package:isati_integration/models/solo_challenge.dart';
import 'package:isati_integration/services/solo_challenges_service.dart';

class SoloChallengesStore with ChangeNotifier {
  Map<String, SoloChallenge>? _challenges;

  Future<List<SoloChallenge>> getChallenges(String authorization) async {
    _challenges ??= await SoloChallengesService.instance.getChallenges(authorization);

    return _challenges!.values.toList();
  } 

  Map<String, SoloChallenge> get challenges => _challenges!;
  List<SoloChallenge> get challengesList => _challenges!.values.toList();

  void receivedUpdate() {
    notifyListeners();
  }
}