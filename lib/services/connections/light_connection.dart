import 'package:flutter/material.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:provider/provider.dart';

class LightConnections {
  static Future<void> connectToLights(
    BuildContext context,
    TextEditingController primaryServiceUuidController,
    TextEditingController receiveCharUuidController,
    TextEditingController sendCharUuidController,
  ) async {
    String primaryServiceUuid = primaryServiceUuidController.text;
    String receiveCharUuid = receiveCharUuidController.text;
    String sendCharUuid = sendCharUuidController.text;

    LightsConnection lightObject = LightsConnection(
      primaryServiceUuid: primaryServiceUuid,
      receiveCharUuid: receiveCharUuid,
      sendCharUuid: sendCharUuid,
    );

    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);
    try {
      await connectionProvider.connectToLights(lightObject);
    } catch (e) {
      if (!context.mounted) return;
      // Handle connection error here, show an error message or take appropriate action.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: const Text(
              'Failed to connect to Lights. Please check the connection settings and try again.'),
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
      throw Exception('Error connecting to Lights: $e');
    }
  }
}
