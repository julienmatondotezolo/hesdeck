import 'package:flutter/material.dart';
import 'package:my_mobile_deck/models/connection.dart';
import 'package:my_mobile_deck/providers/connection_provider.dart';
import 'package:my_mobile_deck/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:wled_api/wled_api.dart';

class DeckLightsConnections {
  static Future<void> connectToDeckLights(
    BuildContext context,
    TextEditingController ipAddressController,
  ) async {
    String ipAddress = ipAddressController.text;

    DeckLightsConnection deckLightObject =
        DeckLightsConnection(ipAddress: ipAddress);

    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    try {
      await connectionProvider.connectToDeckLights(deckLightObject);
      if (!context.mounted) return;
      Navigator.pop(context);
    } catch (e) {
      // Handle connection error here, show an error message or take appropriate action.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: const Text(
            'Failed to connect to Deck Lights. Please check the connection settings and try again.',
          ),
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
      throw Exception('Error connecting to Deck Lights: $e');
    }
  }

  static Future<void> disconnectDeckLight(
      ConnectionProvider connectionProvider) async {
    connectionProvider.disconnectFromDeckLights();
  }

  static Future<void> deleteDeckLightConnection(
    ConnectionProvider connectionProvider,
    Connection connectionObject,
  ) async {
    try {
      connectionProvider.removeConnectionFromSP(connectionObject);
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error deleting Deck Lights connection: $e');
    }
  }

  static Future<bool> checkIfConnectedToDeckLights(
    BuildContext context,
    WLED? deckLightsClient,
  ) async {
    try {
      if (deckLightsClient != null) {
        return true;
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: const Text('Not connected to Deck Lights.'),
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
              child: const Text('Connect to Deck Lights'),
            ),
          ],
        ),
      );
      return false;
    } catch (e) {
      debugPrint('Deck Lights connection error: $e');
      return false;
    }
  }
}
