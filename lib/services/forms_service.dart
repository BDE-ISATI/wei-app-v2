import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:isati_integration/models/is_form_qa.dart';
import 'package:isati_integration/utils/constants.dart';

class FormsService {
  FormsService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/forms";

  static final FormsService instance = FormsService._privateConstructor();

  Future<String> submitForm(String userId, List<IsFormQA> formQas, String image1, String image2, String image3) async {
    final http.Response response = await http.post(
      Uri.parse("$serviceBaseUrl/users/$userId"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        "qAs": <Map<String, dynamic>>[
          for (final question in formQas)
            question.toJson()
        ],
        "drawing1": image1,
        "drawing2": image2,
        "drawing3": image3
      })
    );

    if (response.statusCode == 200) {
      return response.body;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }
}