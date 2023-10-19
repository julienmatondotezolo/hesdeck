import 'package:flutter/material.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:provider/provider.dart';

class TwitchConnections {
  static Future<void> connectToTwitch(
    BuildContext context,
    TextEditingController ipAddressController,
    TextEditingController portController,
    TextEditingController passwordController,
  ) async {
    String clientId = ipAddressController.text;
    String port = portController.text;
    String password = passwordController.text;

    TwitchConnection twitchObject = TwitchConnection(
      clientId: clientId,
      port: port,
      password: password,
    );

    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    try {
      await connectionProvider.connectToTwitch(twitchObject);
    } catch (e) {
      // Handle connection error here, show an error message or take appropriate action.
      print('Error connecting to Twitch: $e');
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
      print('Error deleting twitch connection: $e');
    }
  }
}
