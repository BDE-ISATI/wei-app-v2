
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  AuthenticationService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/authentication";

  static final AuthenticationService instance = AuthenticationService._privateConstructor();

  // Web services
  Future<User> login(String username, String password) async {
    final http.Response response = await http.post(
      Uri.parse("$serviceBaseUrl/login"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String> {
        "email": username,
        "password": password
      })
    );

    if (response.statusCode == 200) {
      final User loggedUser = User.fromMap(jsonDecode(response.body) as Map<String, dynamic>);

      await _saveUserToSettings(loggedUser);

      return loggedUser;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  // Services dealing with stored preferences
  Future<User?> getLoggedUser() async => _getUserFromSettings(); 

  Future logoutUser() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.remove("user_id");

    await preferences.remove("user_firstName");
    await preferences.remove("user_lastName");
    await preferences.remove("user_email");

    await preferences.remove("user_role");
    await preferences.remove("user_token");
  }

  // Private functions
  Future _saveUserToSettings(User userToSave) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString("user_id", userToSave.id!);

    await preferences.setString("user_firstName", userToSave.firstName);
    await preferences.setString("user_lastName", userToSave.lastName);
    await preferences.setString("user_email", userToSave.email);

    await preferences.setString("user_role", userToSave.role);
    await preferences.setString("user_token", userToSave.token!);
  }

  Future<User?> _getUserFromSettings() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final String? id = preferences.getString("user_id");
    
    if (id == null) { return null; }
    
    final User user = User(
      id,
      firstName: preferences.getString("user_firstName") ?? "",
      lastName: preferences.getString("user_lastName") ?? "",
      email: preferences.getString("user_email") ?? "",
      role: preferences.getString("user_role") ?? "",
      token: preferences.getString("user_token") ?? ""
    );

    return user;
  }
}