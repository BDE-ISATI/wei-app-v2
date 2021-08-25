class TeamValidation {
  final String? id;

  String challengeId;
  String teamId;

  TeamValidation({
    this.id,
    required this.challengeId,
    required this.teamId,
  });

  TeamValidation.fromMap(Map<String, dynamic> map) :
    id = map['id'] as String,
    challengeId = map['challengeId'] as String,
    teamId = map['teamId'] as String;
}