class SoloChallenge {
  String? id;

  String title;
  String description;

  int value;
  int numberOfRepetitions;

  DateTime startingDate;
  DateTime endingDate;

  SoloChallenge(this.id, {
    required this.title,
    required this.description,
    required this.value,
    required this.numberOfRepetitions,
    required this.startingDate,
    required this.endingDate,
  });

  SoloChallenge.fromMap(Map<String, dynamic> map) : 
    id = map['id'] as String,
    title = map['title'] as String,
    description = map['description'] as String,
    value = map['value'] as int,
    numberOfRepetitions = map['numberOfRepetitions'] as int,
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