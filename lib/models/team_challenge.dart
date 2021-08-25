class TeamChallenge {
  String? id;

  String title;
  String description;

  int value;
  int numberOfRepetitions;
  bool shouldCountMembers;

  DateTime startingDate;
  DateTime endingDate;

  TeamChallenge(this.id, {
    required this.title,
    required this.description,
    required this.value,
    required this.numberOfRepetitions,
    required this.shouldCountMembers,
    required this.startingDate,
    required this.endingDate,
  });

  TeamChallenge.fromMap(Map<String, dynamic> map) : 
    id = map['id'] as String,
    title = map['title'] as String,
    description = map['description'] as String,
    value = map['value'] as int,
    numberOfRepetitions = map['numberOfRepetitions'] as int,
    shouldCountMembers = map["shouldCountMembers"] as bool,
    startingDate = DateTime.parse(map['startingDate'] as String),
    endingDate = DateTime.parse(map['endingDate'] as String);

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