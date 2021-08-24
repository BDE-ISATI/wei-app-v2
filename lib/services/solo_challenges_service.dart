import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:isati_integration/models/solo_challenge.dart';
import 'package:isati_integration/utils/constants.dart';

class SoloChallengesService {
  SoloChallengesService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/solochallenges";

  static final SoloChallengesService instance = SoloChallengesService._privateConstructor();

  Future<List<SoloChallenge>> getChallenges(String authorization) async {
    final http.Response response = await http.get(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonChallenges = jsonDecode(response.body) as List<dynamic>;
      final List<SoloChallenge> challenges = [];

      for (final map in jsonChallenges) {
        challenges.add(
          SoloChallenge.fromMap(map as Map<String, dynamic>)
        );
      }

      return challenges;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }
}