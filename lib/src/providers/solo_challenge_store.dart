import 'package:flutter/material.dart';
import 'package:isati_integration/models/solo_challenge.dart';

class SoloChallengeStore with ChangeNotifier {
  final SoloChallenge challenge;

  SoloChallengeStore(this.challenge);

  void setChallengeToWait() {
    challenge.userWaitsValidation = true;
    challenge.numberOfRepetitions--;

    notifyListeners();
  }
}