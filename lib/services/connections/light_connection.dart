import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:my_mobile_deck/models/connection.dart';
import 'package:my_mobile_deck/providers/connection_provider.dart';
import 'package:my_mobile_deck/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';

class LightConnections {
  static Future<void> connectToLights(
    BuildContext context,
    TextEditingController primaryServiceUuidController,
    TextEditingController receiveCharUuidController,
    TextEditingController sendCharUuidController,
  ) async {
    // String primaryServiceUuid = primaryServiceUuidController.text;
    // String receiveCharUuid = receiveCharUuidController.text;
    // String sendCharUuid = sendCharUuidController.text;

    String primaryServiceUuid = 'f000aa60-0451-4000-b000-000000000000';
    String receiveCharUuid = 'f000aa63-0451-4000-b000-000000000000';
    String sendCharUuid = 'f000aa61-0451-4000-b000-000000000000';

    LightsConnection lightObject = LightsConnection(
      primaryServiceUuid: primaryServiceUuid,
      receiveCharUuid: receiveCharUuid,
      sendCharUuid: sendCharUuid,
    );

    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);
    try {
      await connectionProvider.connectToLights(lightObject);
      if (!context.mounted) return;
      Navigator.pop(context);
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

  static Future<void> disconnectLights(
    BuildContext context,
    ConnectionProvider connectionProvider,
  ) async {
    try {
      connectionProvider.disconnectFromLights();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: Text('Failed to disconnect from Lights. $e'),
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

  static Future<void> deleteLightsConnection(
    ConnectionProvider connectionProvider,
    Connection connectionObject,
  ) async {
    try {
      connectionProvider.removeConnectionFromSP(connectionObject);
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error deleting Lights connection: $e');
    }
  }

  static Future<bool> checkIfConnectedToLights(
    BuildContext context,
    BluetoothDevice? lightClient,
  ) async {
    try {
      if (lightClient != null) {
        return true;
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: const Text('Not connected to Lights.'),
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
              child: const Text('Connect to Lights'),
            ),
          ],
        ),
      );
      return false;
    } catch (e) {
      debugPrint('Lights connection error: $e');
      return false;
    }
  }
}
