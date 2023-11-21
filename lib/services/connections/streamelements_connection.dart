import 'dart:convert';
import 'package:http/http.dart' as http;

class StreamElements {
  final String? jwtToken;
  final String? accountID;
  final String baseUrl = "https://api.streamelements.com/kappa/v2/";
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer '
  };

  StreamElements(this.jwtToken, this.accountID) {
    headers['Authorization'] = 'Bearer $jwtToken';
  }

  Future connect(String jwtToken, String accountID) async {
    headers['Authorization'] = 'Bearer $jwtToken';
    final Uri uri = Uri.parse('$baseUrl/users/current');
    final response = await http.get(uri, headers: headers);

    StreamElements streamElementsObject;

    if (response.statusCode == 200) {
      streamElementsObject = StreamElements(jwtToken, accountID);
      return streamElementsObject;
    } else {
      throw Exception('Authentication error wrong credentials');
    }
  }

  Future<Map<String, dynamic>> getAllOverlays() async {
    final Uri uri =
        Uri.parse('$baseUrl/overlays/$accountID/?search=a&type=regular');

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get overlays data');
    }
  }
}

String jwtToken = 'your_jwt_token';
String accountID = 'your_account_id';

StreamElements streamElements = StreamElements(jwtToken, accountID);

Future<Map<String, dynamic>> overlays = streamElements.getAllOverlays();

print(overlays) {
  // TODO: implement print
  throw UnimplementedError();
}
