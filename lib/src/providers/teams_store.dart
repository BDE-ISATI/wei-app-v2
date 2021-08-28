
import 'package:flutter/material.dart';
import 'package:isati_integration/models/team.dart';
import 'package:isati_integration/services/teams_service.dart';

class TeamsStore with ChangeNotifier {
  Map<String, Team>? _teams;

  Future<List<Team>> getTeams(String authorization, {bool forceRefresh = false}) async {
    if (forceRefresh) {
      _teams = null;
    }

    _teams ??= await TeamsService.instance.getTeams(authorization);

    return _teams!.values.toList();
  } 

  Map<String, Team> get teams => _teams!;
  List<Team> get teamsList => _teams!.values.toList();

  void addTeam(Team team) {
    _teams![team.id!] = team;

    notifyListeners();
  }
}