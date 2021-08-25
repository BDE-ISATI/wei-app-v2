import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isati_integration/models/solo_challenge.dart';

class SoloChallengeStore with ChangeNotifier {
  final SoloChallenge challenge;

  SoloChallengeStore(this.challenge);

  String get title => challenge.title;
  set title(String value) {
    challenge.title = value;
    notifyListeners();
  }

  String get description => challenge.description;
  set description(String value) {
    challenge.description = value;
    notifyListeners();
  }

  int get value => challenge.value;
  set value(int newValue) {
    challenge.value = newValue;
    notifyListeners();
  }

  int get numberOfRepetitions => challenge.numberOfRepetitions;
  set numberOfRepetitions(int value) {
    challenge.numberOfRepetitions = value;
    notifyListeners();
  }

  DateTime get startingDate => challenge.startingDate;
  set startingDate(DateTime value) {
    challenge.startingDate = value;
    notifyListeners();
  }

  DateTime get endingDate => challenge.endingDate;
  set endingDate(DateTime value) {
    challenge.endingDate = value;
    notifyListeners();
  }

  void updateImage(String imageString) {
    challenge.challengeImage.image = MemoryImage(base64Decode(imageString));

    notifyListeners();
  }

  void setChallengeToWait() {
    challenge.userWaitsValidation = true;
    challenge.numberOfRepetitions--;

    notifyListeners();
  }
}