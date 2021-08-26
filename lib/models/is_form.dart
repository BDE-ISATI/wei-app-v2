import 'package:isati_integration/models/is_form_qa.dart';
import 'package:isati_integration/models/is_image.dart';
import 'package:isati_integration/services/forms_service.dart';

class IsForm {
  final String userId;
  final int totalScore;

  late IsImage drawing1;
  late IsImage drawing2;
  late IsImage drawing3;

  final List<IsFormQA> formQas = [];

  IsForm.fromMap(Map<String, dynamic> map) :
    userId = map['userId'] as String,
    totalScore = map['totalScore'] as int {
      final imageSources = "${FormsService.instance.serviceBaseUrl}/drawing";

      final drawing1Id = map["drawing1Id"] as String;
      final drawing2Id = map["drawing2Id"] as String;
      final drawing3Id = map["drawing3Id"] as String;

      drawing1 = IsImage("$imageSources/$drawing1Id");
      drawing2 = IsImage("$imageSources/$drawing2Id");
      drawing3 = IsImage("$imageSources/$drawing3Id");

      final qasJson = map['qAs'] as List<dynamic>;
      for (final qaJson in qasJson) {
        formQas.add(IsFormQA.fromMap(qaJson as Map<String, dynamic>));
      }
    }

}