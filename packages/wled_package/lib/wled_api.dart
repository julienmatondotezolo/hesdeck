library wled;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WLED {
  final String ipAddress;

  WLED(this.ipAddress);

  static String baseUrl(String ipAddress) => 'http://$ipAddress/json/state';

  static Future<Map<String, dynamic>> getState() async {
    final Uri uri = Uri.parse(baseUrl as String);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Parse the JSON response
      var jsonResponse = json.decode(response.body);

      // Extract the desired keys
      Map<String, dynamic> extractedData = {
        "on": jsonResponse["on"],
        "bri": jsonResponse["bri"],
        "transition": jsonResponse["transition"],
        "seg": jsonResponse["seg"][0]["col"][0],
      };

      return extractedData;
    } else {
      throw Exception('Failed to load state');
    }
  }

  static Future<void> toggle() async {
    final Uri uri = Uri.parse(baseUrl as String);

    final Map<String, dynamic> ledJSON = {"on": "t", "v": true};

    final response = await http.post(
      uri,
      body: json.encode(ledJSON),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['on']) {
        debugPrint('LED state: ${jsonResponse['on']}');
        return jsonResponse['on'];
      } else {
        throw Exception('Failed to update color.');
      }
    } else {
      throw Exception('Failed to update color.');
    }
  }

  static Future<void> updateColor(
    String red,
    String green,
    String blue,
    String bri,
  ) async {
    final Uri uri = Uri.parse(baseUrl as String);

    final Map<String, dynamic> ledJSON = {
      "bri": bri,
      "transiton": 1,
      "seg": [
        {
          "col": [
            [red, green, blue]
          ]
        }
      ]
    };

    final response = await http.post(
      uri,
      body: json.encode(ledJSON),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        debugPrint('LED updated successfully.');
      } else {
        throw Exception('Failed to update color.');
      }
    } else {
      throw Exception('Failed to update color.');
    }
  }
}
