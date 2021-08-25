import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:isati_integration/models/solo_validation.dart';
import 'package:isati_integration/utils/constants.dart';

class SoloValidationsService {
  SoloValidationsService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/validations/solo";

  static final SoloValidationsService instance = SoloValidationsService._privateConstructor();

   Future<List<SoloValidation>> getValidations(String authorization) async {
    final http.Response response = await http.get(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonValidations = jsonDecode(response.body) as List<dynamic>;
      final List<SoloValidation> validations = [];

      for (final map in jsonValidations) {
        validations.add(
          SoloValidation.fromMap(map as Map<String, dynamic>)
        );
      }

      return validations;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<String> getValidationImage(String fileId, {required String authorization}) async {
    final http.Response response = await http.get(
      Uri.parse("$serviceBaseUrl/files/$fileId"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization
      },
    );

    if (response.statusCode == 200) {
      return response.body.replaceAll('"', '');
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<String> submitValidation(String challengeId, List<String> medias, {required String authorization}) async {
    final http.Response response = await http.post(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        "challengeId": challengeId,
        "files": medias
      })
    );

    if (response.statusCode == 200) {
      return response.body;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future acceptValidation(String id, int extraPoints, {required String authorization}) async {
    final http.Response response = await http.post(
      Uri.parse("$serviceBaseUrl/$id/validate"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        "extraPoints": extraPoints
      })
    );

    if (response.statusCode != 200) {
      throw PlatformException(code: response.statusCode.toString(), message: response.body);
    }
  }

  Future rejectValidation(String id, {required String authorization}) async {
    final http.Response response = await http.post(
      Uri.parse("$serviceBaseUrl/$id/reject"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authorization,
      },
    );

    if (response.statusCode != 200) {
      throw PlatformException(code: response.statusCode.toString(), message: response.body);
    }
  }
}