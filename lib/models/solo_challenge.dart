import 'package:isati_integration/models/is_image.dart';
import 'package:isati_integration/services/solo_challenges_service.dart';

class SoloChallenge {
  String? id;

  late IsImage challengeImage;

  String title;
  String description;

  int value;
  int numberOfRepetitions;
  bool userWaitsValidation = false;

  DateTime startingDate;
  DateTime endingDate;

  SoloChallenge(this.id, {
    required this.title,
    required this.description,
    required this.value,
    required this.numberOfRepetitions,
    required this.startingDate,
    required this.endingDate,
    required this.challengeImage
  });

  SoloChallenge.fromMap(Map<String, dynamic> map) : 
    id = map['id'] as String,
    title = map['title'] as String,
    description = map['description'] as String,
    value = map['value'] as int,
    numberOfRepetitions = map['numberOfRepetitions'] as int,
    startingDate = DateTime.parse(map['startingDate'] as String),
    endingDate = DateTime.parse(map['endingDate'] as String) {
      challengeImage = IsImage("${SoloChallengesService.instance.serviceBaseUrl}/$id/image");
    }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "title": title,
      "description": description,
      "value": value,
      "numberOfRepetitions": numberOfRepetitions,
      "startingDate": startingDate.toIso8601String(),
      "endingDate": endingDate.toIso8601String(),
    };
  }
}