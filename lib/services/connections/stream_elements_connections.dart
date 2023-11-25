import 'package:flutter/material.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:provider/provider.dart';
import 'package:stream_elements_package/stream_elements.dart';

class StreamElementsConnections {
  static Future<void> connectToStreamElements(
    BuildContext context,
    TextEditingController jwtTokenController,
    TextEditingController accounIdController,
  ) async {
    String jwtToken = jwtTokenController.text;
    String accounId = accounIdController.text;

    StreamElementsConnection streamElementsObject = StreamElementsConnection(
      jwtToken: jwtToken,
      accounId: accounId,
    );

    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);
    try {
      await connectionProvider.connectToStreamElements(streamElementsObject);
    } catch (e) {
      // Handle connection error here, show an error message or take appropriate action.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: const Text(
              'Failed to connect to StreamElements. Please check the connection settings and try again.'),
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
      throw Exception('Error connecting to StreamElements: $e');
    }
  }

  static Future<Map<String, dynamic>> getOverlays(
      StreamElements? streamElementsClient) async {
    final response = await streamElementsClient!.getAllOverlays();
    debugPrint('[OVERLAYS]: $response');
    return response;
  }

  static Future<void> disconnectStreamElements(
    BuildContext context,
    ConnectionProvider connectionProvider,
  ) async {
    try {
      connectionProvider.disconnectFromStreamElements();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: Text('Failed to disconnect from StreamElements. $e'),
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

  static Future<void> deleteStreamElementsConnection(
    ConnectionProvider connectionProvider,
    Connection connectionObject,
  ) async {
    try {
      connectionProvider.removeConnectionFromSP(connectionObject);
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error deleting StreamElements connection: $e');
    }
  }
}
