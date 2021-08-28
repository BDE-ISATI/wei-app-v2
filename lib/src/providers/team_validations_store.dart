import 'package:flutter/material.dart';
import 'package:isati_integration/models/team_validation.dart';
import 'package:isati_integration/services/team_validations_service.dart';
import 'package:isati_integration/src/providers/team_challenges_store.dart';

class TeamValidationsStore with ChangeNotifier {
  List<TeamValidation>? _validations;

  Future<List<TeamValidation>> getValidations(String authorization, {bool forceRefresh = false}) async {
    if (forceRefresh) {
      _validations = null;
    }

    _validations ??= await TeamValidationsService.instance.getValidations(authorization);

    return _validations!;
  } 

  List<TeamValidation> get validations => _validations!;

  void addValidation(TeamValidation validation) {
    _validations!.add(validation);

    notifyListeners();
  }

  void updateChallenges(TeamChallengesStore challengesStore) {
    for (final validation in validations) {
      if (challengesStore.challenges[validation.challengeId] != null) {
        final challenge = challengesStore.challenges[validation.challengeId]!;

        challenge.numberOfRepetitions -= 1;
      }
    }
  }
}