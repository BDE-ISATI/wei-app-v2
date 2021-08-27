import 'package:flutter/material.dart';
import 'package:isati_integration/models/solo_validation.dart';
import 'package:isati_integration/services/solo_validations_service.dart';
import 'package:isati_integration/src/providers/solo_challenges_store.dart';

class SoloValidationsStore with ChangeNotifier {
  List<SoloValidation>? _validations;

  Future<List<SoloValidation>> getValidations(String authorization, {bool forceRefresh = false}) async {
    if (forceRefresh) {
      _validations = null;
    }

    _validations ??= await SoloValidationsService.instance.getValidations(authorization);

    return _validations!;
  } 

  List<SoloValidation> get validations => _validations!;

  void addValidation(SoloValidation validation) {
    _validations!.add(validation);

    notifyListeners();
  }

  void removeValidation(SoloValidation validation) {
    _validations!.remove(validation);

    notifyListeners();
  }

  void updateChallenges(SoloChallengesStore challengesStore) {
    for (final validation in validations) {
      if (challengesStore.challenges[validation.challengeId] != null) {
        final challenge = challengesStore.challenges[validation.challengeId]!;

        challenge.numberOfRepetitions -= 1;
        if (!challenge.userWaitsValidation) {
          challenge.userWaitsValidation = validation.status == SoloValidationStatus.waiting;
        }
      }
    }
  }
}