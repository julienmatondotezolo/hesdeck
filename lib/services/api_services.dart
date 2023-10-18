import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ApiServices {
  static const String baseUrl =
      'https://api.example.com'; // Replace with your API base URL

  // Function to make a GET request to the API
  static Future<dynamic> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      // If the request is successful, parse the response JSON
      return json.decode(response.body);
    } else {
      // If the request fails, throw an exception with the error message
      throw Exception('Failed to load data');
    }
  }

  // Function to fetch data from a local JSON file
  static Future<dynamic> fetchActions(String fileName) async {
    try {
      // Load the JSON data from the local file using rootBundle
      String jsonString = await rootBundle.loadString('assets/$fileName');
      // Parse the JSON data and return it
      return json.decode(jsonString);
    } catch (e) {
      // If there's an error, throw an exception with the error message
      throw Exception('Failed to load data');
    }
  }

  // Function to fetch data from a local JSON file
  static Future<dynamic> fetchConnections(String fileName) async {
    try {
      // Load the JSON data from the local file using rootBundle
      String jsonString = await rootBundle.loadString('assets/$fileName');
      // Parse the JSON data and return it
      return json.decode(jsonString);
    } catch (e) {
      // If there's an error, throw an exception with the error message
      throw Exception('Failed to load data');
    }
  }
}
