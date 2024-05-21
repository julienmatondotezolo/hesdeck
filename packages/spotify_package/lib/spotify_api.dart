import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpotifyApi with ChangeNotifier {
  final String clientId;
  final String clientSecret;
  final String redirectUri;
  final String scope = 'user-read-playback-state user-modify-playback-state';
  late String? _accessToken = '';
  late String? _refreshToken = '';

  SpotifyApi({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
  });

  Future<bool> checkTokenValidity() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/player'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        // Unauthorized, likely due to expired token
        await refreshAccessToken(); // Refresh the access token
        // Retry the check after refreshing the token
        return await checkTokenValidity();
      } else {
        throw Exception({
          "code": response.statusCode,
          "body": json.decode(response.body)["error"]["message"],
          "reason": response.reasonPhrase,
        });
      }
    } catch (e) {
      print("Exception in checkTokenValidity: $e");
      return false;
    }
  }

  Uri createAuthenticationUri() {
    var query = [
      'response_type=code',
      'client_id=$clientId',
      'scope=${Uri.encodeComponent(scope)}',
      'redirect_uri=${Uri.encodeComponent(redirectUri)}',
    ];

    var queryString = query.join('&');
    var url = 'https://accounts.spotify.com/authorize?' + queryString;
    var parsedUrl = Uri.parse(url);
    return parsedUrl;
  }

  Future<void> launchAuthInWebView(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: Text(
              'Spotify Auth',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: WebView(
            initialUrl: createAuthenticationUri().toString(),
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) async {
              if (request.url.startsWith(redirectUri)) {
                final code = Uri.parse(request.url).queryParameters['code'];
                if (code != null) {
                  Navigator.pop(context); // Close the WebView screen
                  await getAccessToken(code);
                  return NavigationDecision.prevent;
                }
              }
              return NavigationDecision.navigate;
            },
          ),
        ),
      ),
    );
  }

  Future<void> launchAuth(BuildContext context) async {
    await launchAuthInWebView(context);
    await initUniLinks();
  }

  Future<void> getAccessToken(String code) async {
    try {
      var body = {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": redirectUri,
        "client_id": clientId,
        "client_secret": clientSecret
      };
      var header = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization":
            "Basic ${base64Encode(utf8.encode("$clientId:$clientSecret"))}"
      };
      var response = await http.post(
          Uri.parse("https://accounts.spotify.com/api/token"),
          body: body,
          headers: header);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String accessToken = data["access_token"];
        String refreshToken = data["refresh_token"];
        _accessToken = accessToken;
        _refreshToken = refreshToken;
      } else {
        print("Error retrieving access token: ${response.body}");
        throw Exception('Failed to retrieve access token');
      }
    } catch (e) {
      print("Exception in getAccessToken: $e");
      throw Exception('Failed to retrieve access token');
    }
  }

  Future<void> refreshAccessToken() async {
    try {
      var body = {
        "grant_type": "refresh_token",
        "refresh_token": _refreshToken,
        "client_id": clientId,
        "client_secret": clientSecret
      };
      var header = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization":
            "Basic ${base64Encode(utf8.encode("$clientId:$clientSecret"))}"
      };
      var response = await http.post(
          Uri.parse("https://accounts.spotify.com/api/token"),
          body: body,
          headers: header);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String newAccessToken = data["access_token"];
        _accessToken = newAccessToken;
        // Optionally, update the refresh token if it's included in the response
        if (data.containsKey("refresh_token")) {
          _refreshToken = data["refresh_token"];
        }
      } else {
        print("Error refreshing access token: ${response.body}");
        throw Exception('Failed to refresh access token');
      }
    } catch (e) {
      print("Exception in refreshAccessToken: $e");
      throw Exception('Failed to refresh access token');
    }
  }

  Future<void> initUniLinks() async {
    String? initialLink = await getInitialLink();
    print('initialLink: $initialLink');

    if (initialLink != null && initialLink.contains("code=")) {
      String code = initialLink.split("code=")[1];
      getAccessToken(code);
    } else {
      print("Nothing");
    }
  }

  Future<List> getAllDevices() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/player/devices'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List devices = data['devices'];
        return devices;
      } else {
        print("Error retrieving devices: ${response.body}");
        throw Exception('Failed to retrieve devices');
      }
    } catch (e) {
      throw Exception('Failed to get devices: $e');
    }
  }

  Future<Map<String, dynamic>?> getCurrentPlaybackState() async {
    if (await checkTokenValidity()) {
      try {
        final response = await http.get(
          Uri.parse('https://api.spotify.com/v1/me/player'),
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        );

        if (response.statusCode == 200) {
          // The request was successful, return the playback state
          return json.decode(response.body);
        } else if (response.statusCode == 204) {
          // The request was successful but no content was returned, indicating no active playback
          return null;
        } else {
          throw Exception({
            "code": response.statusCode,
            "reason": response.reasonPhrase,
          });
        }
      } catch (e) {
        throw Exception('Failed to get playback state $e');
      }
    }
    return null;
  }

  Future<void> startPlayback(String deviceId) async {
    if (await checkTokenValidity()) {
      try {
        // Then, start playback on that device
        final responsePlay = await http.put(
          Uri.parse('https://api.spotify.com/v1/me/player/play'),
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
          body: json.encode({
            'device_id': deviceId,
          }),
        );

        print('responsePlay ${responsePlay.body}');

        if (responsePlay.statusCode == 204) {
          print('responsePlay: ${responsePlay.body}');
        } else if (responsePlay.statusCode == 403) {
          throw Exception(
              {"code": responsePlay.body, "reason": responsePlay.reasonPhrase});
        } else {
          throw Exception({
            "code": responsePlay.statusCode,
            "reason": responsePlay.reasonPhrase
          });
        }
      } catch (e) {
        throw Exception('Failed to start playback: $e');
      }
    }
  }

  Future<void> pausePlayback(String deviceId) async {
    try {
      // Then, start playback on that device
      final responsePause = await http.put(
        Uri.parse('https://api.spotify.com/v1/me/player/pause'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({
          'device_id': deviceId,
        }),
      );

      if (responsePause.statusCode == 204) {
        print('responsePause: ${responsePause.body}');
      } else {
        throw Exception({
          "code": responsePause.statusCode,
          "reason": responsePause.reasonPhrase
        });
      }
    } catch (e) {
      throw Exception('Failed to pause playback: $e');
    }
  }

  Future<void> nextPlayback(String deviceId) async {
    if (await checkTokenValidity()) {
      try {
        // Then, start playback on that device
        final responseNext = await http.post(
          Uri.parse('https://api.spotify.com/v1/me/player/next'),
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
          body: json.encode({
            'device_id': deviceId,
          }),
        );

        if (responseNext.statusCode == 204) {
          print('responseNext: ${responseNext.body}');
        } else {
          throw Exception({
            "code": responseNext.statusCode,
            "reason": responseNext.reasonPhrase
          });
        }
      } catch (e) {
        throw Exception('Failed to next playback: $e');
      }
    }
  }

  Future<void> previousPlayback(String deviceId) async {
    try {
      // Then, start playback on that device
      final responsePrevious = await http.post(
        Uri.parse('https://api.spotify.com/v1/me/player/previous'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({
          'device_id': deviceId,
        }),
      );

      if (responsePrevious.statusCode == 204) {
        print('responseprevious: ${responsePrevious.body}');
      } else {
        throw Exception({
          "code": responsePrevious.statusCode,
          "reason": responsePrevious.reasonPhrase
        });
      }
    } catch (e) {
      throw Exception('Failed to previous playback: $e');
    }
  }

  Future<void> volumeUp(String deviceId) async {
    try {
      // Get current playback state
      var playBackStateResponse = await getCurrentPlaybackState();
      int currentVolume = playBackStateResponse?["device"]["volume_percent"];
      int updatedVolume = currentVolume + 10;

      int newVolume = updatedVolume > 100 ? 100 : updatedVolume;

      // Then, start playback on that device
      final responseVolume = await http.put(
        Uri.parse(
          'https://api.spotify.com/v1/me/player/volume?volume_percent=$newVolume',
        ),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({'device_id': deviceId}),
      );

      if (responseVolume.statusCode == 204) {
        print('responseVolume: ${responseVolume.body}');
      } else {
        throw Exception({
          "code": responseVolume.statusCode,
          "reason": responseVolume.reasonPhrase
        });
      }
    } catch (e) {
      throw Exception('Failed to volume up state: $e');
    }
  }

  Future<void> volumeDown(String deviceId) async {
    try {
      // Get current playback state
      var playBackStateResponse = await getCurrentPlaybackState();
      int currentVolume = playBackStateResponse?["device"]["volume_percent"];
      int updatedVolume = currentVolume - 10;

      int newVolume = updatedVolume < 0 ? 0 : updatedVolume;

      // Then, start playback on that device
      final responseVolume = await http.put(
        Uri.parse(
          'https://api.spotify.com/v1/me/player/volume?volume_percent=$newVolume',
        ),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({
          'device_id': deviceId,
        }),
      );

      if (responseVolume.statusCode == 204) {
        print('responseVolume: ${responseVolume.body}');
      } else {
        throw Exception({
          "code": responseVolume.statusCode,
          "reason": responseVolume.reasonPhrase
        });
      }
    } catch (e) {
      throw Exception('Failed to volume down state: $e');
    }
  }

  Future<void> volume(String deviceId, int volume) async {
    try {
      // Then, start playback on that device
      final responseVolume = await http.post(
        Uri.parse('https://api.spotify.com/v1/me/player/volume'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({
          'device_id': deviceId,
          'volume_percent': volume,
        }),
      );

      if (responseVolume.statusCode == 204) {
        print('responseVolume: ${responseVolume.body}');
      } else {
        throw Exception({
          "code": responseVolume.statusCode,
          "reason": responseVolume.reasonPhrase
        });
      }
    } catch (e) {
      throw Exception('Failed to previous playback: $e');
    }
  }

  Future<void> disconnect() async {
    _accessToken = null;
  }
}
