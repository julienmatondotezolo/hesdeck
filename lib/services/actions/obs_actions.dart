import 'package:flutter/material.dart';
import 'package:hessdeck/services/connections/obs_connections.dart';
import 'package:obs_websocket/obs_websocket.dart';

const changSceneMethod = 'Change scene';
const startRecordMethod = 'Start record';
const stopRecordMethod = 'Stop record';
const startStreamMethod = 'Start stream';
const stopStreamMethod = 'Stop stream';

class OBSMethodMetadata {
  final List<String> parameterNames;

  OBSMethodMetadata(this.parameterNames);
}

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

  static final Map<String, OBSMethodMetadata> obsMethodMetadata = {
    changSceneMethod: OBSMethodMetadata(['String', 'Int']),
    startRecordMethod: OBSMethodMetadata([]),
    stopRecordMethod: OBSMethodMetadata([]),
    startStreamMethod: OBSMethodMetadata([]),
    stopStreamMethod: OBSMethodMetadata([]),
  };

  List<String> getMethodParameters(String methodName) {
    return obsMethodMetadata[methodName]?.parameterNames ?? [];
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
