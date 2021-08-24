import 'package:flutter/material.dart';
import 'package:isati_integration/models/solo_challenge.dart';
import 'package:isati_integration/services/solo_challenges_service.dart';

class SoloChallengesStore with ChangeNotifier {
  List<SoloChallenge>? _challenges;

  Future<List<SoloChallenge>> getChallenges(String authorization) async {
    return _challenges ??= await SoloChallengesService.instance.getChallenges(authorization);
  } 

  List<SoloChallenge> get challenges => _challenges!;
}