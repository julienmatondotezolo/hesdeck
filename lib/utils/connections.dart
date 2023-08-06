import 'package:flutter/material.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:provider/provider.dart';

class Connections {
  static Future<void> disconnectOBS(BuildContext context) async {
    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    connectionProvider.disconnectFromOBS();
  }

  static Future<void> connectToOBS(
      BuildContext context,
      GlobalKey<FormState> formKey,
      TextEditingController ipAddressController,
      TextEditingController portController,
      TextEditingController passwordController) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    String ipAddress = ipAddressController.text;
    String port = portController.text;
    String password = passwordController.text;

    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    try {
      await connectionProvider.updateConnectionSettings(
          ipAddress, port, password);
      await connectionProvider.connectToOBS();
    } catch (e) {
      // Handle connection error here, show an error message or take appropriate action.
      print('Error connecting to OBS: $e');
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
    }
  }

  static Future<SceneListResponse?> getScenes(
      ObsWebSocket? obsWebSocket) async {
    SceneListResponse? response = await obsWebSocket?.scenes.getSceneList();
    print('[SCENES]: $response');
    return response;
  }

  static Future<void> changeScenes(
      ObsWebSocket? obsWebSocket, String sceneName) async {
    try {
      await obsWebSocket?.scenes.setCurrentPreviewScene(sceneName);
      print('[SCENES CHNAGED TO]: $sceneName');
    } catch (e) {
      // Handle any errors that occur while changing the scene
      print('Error changing scene: $e');
      // Show an error message or take appropriate action
    }
  }
}
