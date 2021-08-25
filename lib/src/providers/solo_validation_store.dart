import 'package:flutter/material.dart';
import 'package:isati_integration/models/solo_validation.dart';

class SoloValidationStore with ChangeNotifier {
  final SoloValidation validation;

  SoloValidationStore(this.validation);
}