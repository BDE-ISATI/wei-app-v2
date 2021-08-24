import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:isati_integration/models/team.dart';
import 'package:isati_integration/utils/constants.dart';

class TeamsService {
  TeamsService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/teams";

  static final TeamsService instance = TeamsService._privateConstructor();

  Future<Map<String, Team>> getTeams(String authorization) async {
    final http.Response response = await http.get(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonTeams = jsonDecode(response.body) as List<dynamic>;
      final Map<String, Team> teams = {};

      for (final map in jsonTeams) {
        teams[map['id'] as String] = Team.fromMap(map as Map<String, dynamic>);
      }

      return teams;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<Team> getTeam(String id, {required String authorization}) async {
    final http.Response response = await http.get(
      Uri.parse("$serviceBaseUrl/$id"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization,
      }
    );

    if (response.statusCode == 200) {
      return Team.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<String> createTeam(Team toCreate, {required String authorization}) async {
    final http.Response response = await http.post(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(toCreate.toJson())
    );

    if (response.statusCode == 200) {
      return response.body;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future updateTeam(Team toUpdate, {required String authorization}) async {
    final http.Response response = await http.put(
      Uri.parse("$serviceBaseUrl/${toUpdate.id}"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(toUpdate.toJson())
    );

    if (response.statusCode != 200) {
      throw PlatformException(code: response.statusCode.toString(), message: response.body);
    }

  }
}
