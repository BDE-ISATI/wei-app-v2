
import 'package:isati_integration/models/is_image.dart';
import 'package:isati_integration/models/team.dart';
import 'package:isati_integration/services/users_service.dart';

mixin UserRoles {
  static const String admin = "Admin";
  static const String captain = "Captain";
  static const String player = "Player";

  static const Map<String, String> detailled = {
    admin: "Administrateur",
    captain: "Capitaine",
    player: "Joueur"
  };
}

class User {
  final String? id;

  late IsImage profilePicture;

  Team? team;

  String firstName;
  String lastName;
  String email;

  int score = 0;

  String role;
  String? token;
  
  String get fullName =>  "$firstName $lastName";
  String get authenticationHeader => "Bearer $token";

  User(this.id, {
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.token
  }) {
    profilePicture = IsImage("");
  }

  User.fromMap(Map<String, dynamic> map, {
    this.team
  }) : 
    id = map['id'] as String,
    firstName = map['firstName'] as String,
    lastName = map['lastName'] as String,
    email = map['email'] as String? ?? "unknown",

    score = map['score'] as int,

    role = map['role'] as String,
    // ignore: unnecessary_parenthesis
    token = (map['token'] as String?) {
      profilePicture = IsImage("${UsersService.instance.serviceBaseUrl}/$id/profile_picture");
    }

  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "teamId": team != null ? team!.id : null,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "role": role,
      "score": score,
    };
  }
}