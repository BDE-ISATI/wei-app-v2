import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:isati_integration/models/solo_challenge.dart';
import 'package:isati_integration/utils/constants.dart';

class SoloChallengesService {
  SoloChallengesService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/challenges/solo";

  static final SoloChallengesService instance = SoloChallengesService._privateConstructor();

  Future<Map<String, SoloChallenge>> getChallenges(String authorization) async {
    final http.Response response = await http.get(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonChallenges = jsonDecode(response.body) as List<dynamic>;
      final Map<String, SoloChallenge> challenges = {};

      for (final map in jsonChallenges) {
        challenges[map['id'] as String] =  SoloChallenge.fromMap(map as Map<String, dynamic>);
      }

      return challenges;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<String> createChallenge(SoloChallenge toCreate, String image, {required String authorization}) async {
    final http.Response response = await http.post(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        ...toCreate.toJson(),
        "challengeImage": image.isNotEmpty ? image : null
      })
    );

    if (response.statusCode == 200) {
      return response.body;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future updateChallenge(SoloChallenge toUpdate, String image, {required String authorization}) async {
    final http.Response response = await http.put(
      Uri.parse("$serviceBaseUrl/${toUpdate.id}"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        ...toUpdate.toJson(),
        "challengeImage": image.isNotEmpty ? image : null
      })
    );

    if (response.statusCode != 200) {
      throw PlatformException(code: response.statusCode.toString(), message: response.body);
    }

  }
}