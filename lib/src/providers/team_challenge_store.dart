import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isati_integration/models/team_challenge.dart';

class TeamChallengeStore with ChangeNotifier {
  final TeamChallenge challenge;

  TeamChallengeStore(this.challenge);

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
  
  bool get shouldCountMembers => challenge.shouldCountMembers;
  set shouldCountMembers(bool value) {
    challenge.shouldCountMembers = value;
    notifyListeners();
  }

  DateTime get startingDate => challenge.startingDate;
  set startingDate(DateTime value) {
    challenge.startingDate = value;
    notifyListeners();
  }

  void updateImage(String imageString) {
    challenge.challengeImage.image = MemoryImage(base64Decode(imageString));

    notifyListeners();
  }

  DateTime get endingDate => challenge.endingDate;
  set endingDate(DateTime value) {
    challenge.endingDate = value;
    notifyListeners();
  }
}