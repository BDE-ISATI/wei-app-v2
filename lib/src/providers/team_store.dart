import 'package:flutter/material.dart';
import 'package:isati_integration/models/team.dart';

class TeamStore with ChangeNotifier {
  final Team team;

  TeamStore(this.team);

  String get name => team.name;
  set name(String value) {
    team.name = value;

    notifyListeners();
  }

  String? get captainId => team.captainId;
  set captainId(String? value) {
    team.captainId = value;

    notifyListeners();
  }

  String get teamColor => team.teamColor;
  set teamColor(String value) {
    team.teamColor = value;

    notifyListeners();
  }

  int get score => team.score;
}