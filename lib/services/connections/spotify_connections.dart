import 'package:flutter/material.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:provider/provider.dart';

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
}
