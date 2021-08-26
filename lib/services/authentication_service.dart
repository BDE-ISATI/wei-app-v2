
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/services/users_service.dart';
import 'package:isati_integration/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  AuthenticationService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/authentication";

  static final AuthenticationService instance = AuthenticationService._privateConstructor();

  // Web services
  Future<String> register(User userToRegister, String password) async {
    final userJson = userToRegister.toJson();

    // Since password is never stored, we need to add it
    // manually to the register request
    userJson.addAll(<String, dynamic>{
      "password": password
    });

    final http.Response response = await http.post(
      Uri.parse("$serviceBaseUrl/register"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(userJson)
    );

    if (response.statusCode == 200) {
      return response.body;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

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
      final map = jsonDecode(response.body) as Map<String, dynamic>;
      final User user = await UsersService.instance.getUser(
        map["id"] as String,
        authorization: "Bearer ${map['token'] as String}"
      );

      user.token = map['token'] as String;

      await _saveUserToSettings(user);

      return user;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  // Services dealing with stored preferences
  Future<User?> getLoggedUser() async => _getUserFromSettings(); 

  Future logoutUser() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.remove("user_id");
    await preferences.remove("user_token");
  }

  // Private functions
  Future _saveUserToSettings(User userToSave) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString("user_id", userToSave.id!);
    await preferences.setString("user_token", userToSave.token!);
  }

  Future<User?> _getUserFromSettings() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final String? id = preferences.getString("user_id");
    
    if (id == null) { return null; }

    final token = preferences.getString("user_token") ?? "";

    final User user = await UsersService.instance.getUser(id, authorization: "Bearer $token");
    user.token = token;

    return user;
  }
}