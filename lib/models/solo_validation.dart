mixin SoloValidationStatus {
  static const String waiting = "Waiting";
  static const String validated = "Validated";
  static const String rejected = "Rejected";
} 

class SoloValidation {
  final String? id;

  String challengeId;
  String userId;
  String status;

  List<String>? filesIds;

  SoloValidation({
    this.id,
    required this.challengeId,
    required this.userId,
    this.status = SoloValidationStatus.waiting
  });

  SoloValidation.fromMap(Map<String, dynamic> map) :
    id = map['id'] as String,
    challengeId = map['challengeId'] as String,
    userId = map['userId'] as String,
    status = map['status'] as String,
    filesIds = [] {
      final filesIdsJson = map['filesIds'] as List<dynamic>;

      for (final id in filesIdsJson) {
        filesIds!.add(id as String);
      }
    }
}