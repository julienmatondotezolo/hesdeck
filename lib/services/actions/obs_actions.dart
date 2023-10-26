import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';

class OBSActions {
  static Future<void> changeScenes(
    ObsWebSocket? obsWebSocket,
    String sceneName,
  ) async {
    try {
      await obsWebSocket?.scenes.setCurrentProgramScene(sceneName);
      debugPrint('[SCENES CHNAGED TO]: $sceneName');
    } catch (e) {
      // Handle any errors that occur while changing the scene
      throw Exception('Error changing scene: $e');
      // Show an error message or take appropriate action
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
}

typedef OBSMethod = Future<void> Function(ObsWebSocket?, String);

final Map<String, OBSMethod> obsMethods = {
  'Change scene': OBSActions.changeScenes,
  'Start record': (ObsWebSocket? obsWebSocket, String sceneName) async {
    await OBSActions.startRecord(obsWebSocket);
  },
  'Stop record': (ObsWebSocket? obsWebSocket, String sceneName) async {
    await OBSActions.stopRecord(obsWebSocket);
  },
  'Stop stream': (ObsWebSocket? obsWebSocket, String sceneName) async {
    await OBSActions.stopStream(obsWebSocket);
  },
};
