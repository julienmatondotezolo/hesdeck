import 'package:flutter/material.dart';
import 'package:hessdeck/services/connections/obs_connections.dart';
import 'package:obs_websocket/obs_websocket.dart';

const changSceneMethod = 'Change scene';
const startRecordMethod = 'Start record';
const stopRecordMethod = 'Stop record';
const startStreamMethod = 'Start stream';
const stopStreamMethod = 'Stop stream';

class OBSActions {
  static Future<void> changeScenes(
    BuildContext context,
    ObsWebSocket? obsWebSocket,
    String sceneName,
  ) async {
    if (await OBSConnections.checkIfConnectedToObS(context, obsWebSocket)) {
      try {
        await obsWebSocket?.scenes.setCurrentProgramScene(sceneName);
        debugPrint('[SCENES CHNAGED TO]: $sceneName');
      } catch (e) {
        // Handle any errors that occur while changing the scene
        throw Exception('Error changing scene: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  static Future<void> startRecord(ObsWebSocket? obsWebSocket) async {
    try {
      obsWebSocket?.record.startRecord();
      debugPrint('[RECORD STATUS]: ${obsWebSocket?.record.getRecordStatus()}');
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error changing scene: $e');
      // Show an error message or take appropriate action
    }
  }

  static Future<void> stopRecord(ObsWebSocket? obsWebSocket) async {
    try {
      obsWebSocket?.record.stopRecord();
      debugPrint(
          '[RECORD STATUS]: ${obsWebSocket?.record.getRecordStatus().toString()}');
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error changing scene: $e');
      // Show an error message or take appropriate action
    }
  }

  static Future<void> startStream(ObsWebSocket? obsWebSocket) async {
    try {
      obsWebSocket?.stream.startStream();
      debugPrint('[RECORD STATUS]: ${obsWebSocket?.record.getRecordStatus()}');
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error changing scene: $e');
      // Show an error message or take appropriate action
    }
  }

  static Future<void> stopStream(ObsWebSocket? obsWebSocket) async {
    try {
      obsWebSocket?.stream.stopStream();
      debugPrint('[RECORD STATUS]: ${obsWebSocket?.record.getRecordStatus()}');
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error changing scene: $e');
      // Show an error message or take appropriate action
    }
  }

  static Future<List<Map<String, String>>> getRequiredParameters(
    String methodName,
  ) async {
    switch (methodName) {
      case changSceneMethod:
        return [
          {'name': 'sceneName', 'type': 'String'}
        ];
      case startRecordMethod:
        return [];
      case stopRecordMethod:
        return [];
      case startStreamMethod:
        return [];
      case stopStreamMethod:
        return [];
      default:
        throw Exception('Unknown method: $methodName');
    }
  }
}

typedef OBSMethod = Future<void> Function(BuildContext, ObsWebSocket?, String);

final Map<String, OBSMethod> obsMethods = {
  changSceneMethod: OBSActions.changeScenes,
  startRecordMethod: (
    BuildContext context,
    ObsWebSocket? obsWebSocket,
    String sceneName,
  ) async {
    await OBSActions.startRecord(obsWebSocket);
  },
  stopRecordMethod: (
    BuildContext context,
    ObsWebSocket? obsWebSocket,
    String sceneName,
  ) async {
    await OBSActions.stopRecord(obsWebSocket);
  },
  startStreamMethod: (
    BuildContext context,
    ObsWebSocket? obsWebSocket,
    String sceneName,
  ) async {
    await OBSActions.startStream(obsWebSocket);
  },
  stopStreamMethod: (
    BuildContext context,
    ObsWebSocket? obsWebSocket,
    String sceneName,
  ) async {
    await OBSActions.stopStream(obsWebSocket);
  },
};
