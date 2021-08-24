class Team {
  final String? id;

  String? captainId;
  String name;
  String teamColor;

  Team(this.id, {
    this.captainId,
    required this.name,
    required this.teamColor,
  });

  Team.fromMap(Map<String, dynamic> map) : 
    id = map['id'] as String,
    captainId = map['captainId'] as String?,
    name = map['name'] as String,
    teamColor = map['teamHEXColor'] as String;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "captainId": captainId,
      "name": name,
      "teamHEXColor": teamColor
    };
  }
}