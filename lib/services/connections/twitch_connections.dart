import 'package:flutter/material.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:provider/provider.dart';

class TwitchConnections {
  static Future<void> connectToTwitch(
    BuildContext context,
    TextEditingController ipAddressController,
    TextEditingController usernameController,
    TextEditingController passwordController,
  ) async {
    String clientId = ipAddressController.text;
    String username = usernameController.text;
    String password = passwordController.text;

    TwitchConnection twitchObject = TwitchConnection(
      clientId: clientId,
      username: username,
      password: password,
    );

    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    try {
      await connectionProvider.connectToTwitch(twitchObject);
      if (!context.mounted) return;
      Navigator.pop(context);
    } catch (e) {
      // Handle connection error here, show an error message or take appropriate action.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: const Text(
              'Failed to connect to Twitch. Please check the connection settings and try again.'),
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
      throw Exception('Error connecting to Twitch: $e');
    }
  }

  static Future<void> disconnectTwitch(
      ConnectionProvider connectionProvider) async {
    connectionProvider.disconnectFromTwitch();
  }

  static Future<void> deleteTwitchConnection(
    ConnectionProvider connectionProvider,
    Connection connectionObject,
  ) async {
    try {
      connectionProvider.removeConnectionFromSP(connectionObject);
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error deleting twitch connection: $e');
    }
  }
}
