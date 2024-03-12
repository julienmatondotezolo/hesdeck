library stream_elements;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StreamElements {
  final String? jwtToken;
  final String? accountID;
  static String baseUrl = "https://api.streamelements.com/kappa/v2";
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer '
  };

  StreamElements(this.jwtToken, this.accountID) {
    headers['Authorization'] = 'Bearer $jwtToken';
  }

  static Future<StreamElements> connect(
    String jwtToken,
    String accountID,
  ) async {
    headers['Authorization'] = 'Bearer $jwtToken';
    final Uri uri = Uri.parse('$baseUrl/users/current');
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final streamElementsObject = StreamElements(jwtToken, accountID);
      return streamElementsObject;
    } else {
      debugPrint('[STREAM ELEMENTS] Authentication error: ${response.body}');
      throw Exception('Authentication error wrong credentials');
    }
  }

  StreamElements disconnect() {
    headers['Authorization'] = ''; // Reset authorization token
    return StreamElements(null, null);
  }

  Future<Map<String, dynamic>> getAllOverlays() async {
    final Uri uri = Uri.parse('$baseUrl/overlays/$accountID/?type=regular');

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get overlays data');
    }
  }

  Future<Map<String, dynamic>> getOverlayByID(String overlayId) async {
    final Uri uri = Uri.parse('$baseUrl/overlays/$accountID/$overlayId');

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get overlay data');
    }
  }

  Future<Map<String, dynamic>> updateOverlayByID(
    String overlayId,
    Map<String, dynamic>? body,
  ) async {
    final Uri uri = Uri.parse('$baseUrl/overlays/$accountID/$overlayId');

    final response =
        await http.put(uri, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      print("${body?["name"]} overlay succefully updated.");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get overlay data');
    }
  }
}
