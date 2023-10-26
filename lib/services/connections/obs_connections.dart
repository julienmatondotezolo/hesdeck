import 'package:flutter/material.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:provider/provider.dart';

class OBSConnections {
  static Future<void> listenToEvents(BuildContext context,
      ObsWebSocket? obsWebSocket, int eventSubscription) async {
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);
    final obsWebSocket = connectionProvider.obsWebSocket;

    if (obsWebSocket != null) {
      // return await obsWebSocket.listen(eventSubscription);
    }
  }

  static Future<void> connectToOBS(
    BuildContext context,
    TextEditingController ipAddressController,
    TextEditingController portController,
    TextEditingController passwordController,
  ) async {
    String ipAddress = ipAddressController.text;
    String port = portController.text;
    String password = passwordController.text;

    OBSConnection obsObject = OBSConnection(
      ipAddress: ipAddress,
      port: port,
      password: password,
    );

    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    try {
      await connectionProvider.connectToOBS(obsObject);
    } catch (e) {
      // Handle connection error here, show an error message or take appropriate action.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: const Text(
              'Failed to connect to OBS. Please check the connection settings and try again.'),
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
      throw Exception('Error connecting to OBS: $e');
    }
  }

  static Future<void> disconnectOBS(
    BuildContext context,
    ConnectionProvider connectionProvider,
  ) async {
    try {
      connectionProvider.disconnectFromOBS();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Connection Error'),
          content: Text('Failed to disconnect from OBS. $e'),
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

  static Future<SceneListResponse?> getScenes(
    ObsWebSocket? obsWebSocket,
  ) async {
    SceneListResponse? response = await obsWebSocket?.scenes.getSceneList();
    debugPrint('[SCENES]: $response');
    return response;
  }

  static Future<void> deleteOBSConnection(
    ConnectionProvider connectionProvider,
    Connection connectionObject,
  ) async {
    try {
      connectionProvider.removeConnectionFromSP(connectionObject);
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error deleting OBS connection: $e');
    }
  }
}
