import 'package:flutter/material.dart';
import 'package:my_mobile_deck/models/connection.dart';
import 'package:my_mobile_deck/providers/connection_provider.dart';
import 'package:provider/provider.dart';

class AppleMusicConnections {
  static Future<void> connectToAppleMusic(
    BuildContext context,
    TextEditingController clientIdController,
    TextEditingController clientSecretController,
  ) async {
    String clientId = clientIdController.text;
    String clientSecret = clientSecretController.text;

    AppleMusicConnection appleMusicObject = AppleMusicConnection(
      clientId: clientId,
      clientSecret: clientSecret,
    );

    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    try {
      await connectionProvider.connectToAppleMusic(appleMusicObject);
    } catch (e) {
      // Handle connection error here, show an error message or take appropriate action.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: const Text(
              'Failed to connect to Apple Music. Please check the connection settings and try again.'),
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
      throw Exception('Error connecting to Apple Music: $e');
    }
  }

  static Future<void> disconnectAppleMusic(
      ConnectionProvider connectionProvider) async {
    connectionProvider.disconnectFromAppleMusic();
  }

  static Future<void> deleteAppleMusicConnection(
    ConnectionProvider connectionProvider,
    Connection connectionObject,
  ) async {
    try {
      connectionProvider.removeConnectionFromSP(connectionObject);
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error deleting Apple Music connection: $e');
    }
  }
}
