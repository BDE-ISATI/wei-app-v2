
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

  String firstName;
  String lastName;
  String email;

  String role;
  String? token;
  
  String? newPassword;
  
  String get fullName =>  "$firstName $lastName";
  String get authenticationHeader => "Bearer $token";

  User(this.id, {
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.token
  });

  User.fromMap(Map<String, dynamic> map) : 
    id = map['id'] as String,
    firstName = map['firstName'] as String,
    lastName = map['lastName'] as String,
    email = map['email'] as String,

    role = map['role'] as String,
    token = map['token'] as String?;

  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": newPassword
    };
  }
}