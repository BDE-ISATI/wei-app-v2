import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:isati_integration/models/team_validation.dart';
import 'package:isati_integration/utils/constants.dart';

class TeamValidationsService {
  TeamValidationsService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/validations/team";

  static final TeamValidationsService instance = TeamValidationsService._privateConstructor();

   Future<List<TeamValidation>> getValidations(String authorization) async {
    final http.Response response = await http.get(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonValidations = jsonDecode(response.body) as List<dynamic>;
      final List<TeamValidation> validations = [];

      for (final map in jsonValidations) {
        validations.add(
          TeamValidation.fromMap(map as Map<String, dynamic>)
        );
      }

      return validations;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future submiValidation(String challengeId, String teamId, int membersCount, int extraPoints, {required String authorization}) async {
    final http.Response response = await http.post(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        "challengeId": challengeId,
        "teamId": teamId,
        "extraPoints": extraPoints,
        "membersCount": membersCount
      })
    );

    if (response.statusCode != 200) {
      throw PlatformException(code: response.statusCode.toString(), message: response.body);
    }
  }
}