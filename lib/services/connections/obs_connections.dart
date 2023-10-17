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
      return await obsWebSocket.listen(eventSubscription);
    }
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

  static Future<void> disconnectOBS(
      ConnectionProvider connectionProvider) async {
    connectionProvider.disconnectFromOBS();
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
      await obsWebSocket?.scenes.setCurrentProgramScene(sceneName);
      print('[SCENES CHNAGED TO]: $sceneName');
    } catch (e) {
      // Handle any errors that occur while changing the scene
      print('Error changing scene: $e');
      // Show an error message or take appropriate action
    }
  }

  static Future<void> startRecord(ObsWebSocket? obsWebSocket) async {
    try {
      obsWebSocket?.record.startRecord();
      print('[RECORD STATUS]: ${obsWebSocket?.record.getRecordStatus()}');
    } catch (e) {
      // Handle any errors that occur while changing the scene
      print('Error changing scene: $e');
      // Show an error message or take appropriate action
    }
  }

  static Future<void> stopRecord(ObsWebSocket? obsWebSocket) async {
    try {
      obsWebSocket?.record.stopRecord();
      print(
          '[RECORD STATUS]: ${obsWebSocket?.record.getRecordStatus().toString()}');
    } catch (e) {
      // Handle any errors that occur while changing the scene
      print('Error changing scene: $e');
      // Show an error message or take appropriate action
    }
  }

  static Future<void> stopStream(ObsWebSocket? obsWebSocket) async {
    try {
      obsWebSocket?.stream.stopStream();
      print('[RECORD STATUS]: ${obsWebSocket?.record.getRecordStatus()}');
    } catch (e) {
      // Handle any errors that occur while changing the scene
      print('Error changing scene: $e');
      // Show an error message or take appropriate action
    }
  }

  static Future<void> deleteOBSConnection(ConnectionProvider connectionProvider,
      OBSConnection obsConnectionObject) async {
    try {
      connectionProvider.removeConnectionFromSP(obsConnectionObject);
    } catch (e) {
      // Handle any errors that occur while changing the scene
      print('Error disconnecting from OBS: $e');
    }
  }
}
