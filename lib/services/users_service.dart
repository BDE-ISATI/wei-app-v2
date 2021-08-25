import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:isati_integration/models/team.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/services/teams_service.dart';
import 'package:isati_integration/utils/constants.dart';

class UsersService {
  UsersService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/users";

  static final UsersService instance = UsersService._privateConstructor();

  Future<Map<String, User>> getUsers(String authorization) async {
    final http.Response response = await http.get(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonUsers = jsonDecode(response.body) as List<dynamic>;
      final Map<String, User> teams = {};

      for (final map in jsonUsers) {
        teams[map['id'] as String] = User.fromMap(map as Map<String, dynamic>);
      }

      return teams;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<User> getUser(String id, {required String authorization}) async {
    final http.Response response = await http.get(
      Uri.parse("$serviceBaseUrl/$id"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization
      }
    );

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body) as Map<String, dynamic>;
      Team? userTeam;      

      if ((map['teamId'] as String?) != null) {
        userTeam = await TeamsService.instance.getTeam(map["teamId"] as String, authorization: authorization);
      }

      return User.fromMap(map, team: userTeam);
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }
}