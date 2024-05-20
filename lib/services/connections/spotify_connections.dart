import 'package:flutter/material.dart';
import 'package:my_mobile_deck/models/connection.dart';
import 'package:my_mobile_deck/providers/connection_provider.dart';
import 'package:my_mobile_deck/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:spotify_api/spotify_api.dart';

class SpotifyConnections {
  static Future<void> connectToSpotify(
    BuildContext context,
  ) async {
    SpotifyConnection spotifyObject = SpotifyConnection();

    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    try {
      await connectionProvider.connectToSpotify(context, spotifyObject);
    } catch (e) {
      if (!context.mounted) return;
      // Handle connection error here, show an error message or take appropriate action.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: const Text(
              'Failed to connect to Spotify. Please check the connection settings and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      throw Exception('Error connecting to Spotify: $e');
    }
  }

  static Future<void> disconnectSpotify(
      ConnectionProvider connectionProvider) async {
    connectionProvider.disconnectFromSpotify();
  }

  static Future<void> deleteSpotifyConnection(
    ConnectionProvider connectionProvider,
    Connection connectionObject,
  ) async {
    try {
      connectionProvider.removeConnectionFromSP(connectionObject);
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error deleting Spotify connection: $e');
    }
  }

  static Future<bool> checkIfConnectedToSpotify(
    BuildContext context,
    SpotifyApi? spotifyApi,
  ) async {
    try {
      if (spotifyApi != null) {
        return true;
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: const Text('Not connected to Spotify.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                ).then((_) => Navigator.pop(context));
              },
              child: const Text('Connect to Spotify'),
            ),
          ],
        ),
      );
      return false;
    } catch (e) {
      debugPrint('Spotify connection error: $e');
      return false;
    }
  }
}
