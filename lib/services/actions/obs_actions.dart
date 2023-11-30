import 'package:flutter/material.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/services/connections/obs_connections.dart';
import 'package:obs_websocket/obs_websocket.dart';

const changSceneMethod = 'Change scene';
const selectSceneMethod = 'Select OBS scene';
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
    String sceneName,
  ) async {
    ObsWebSocket? obsWebSocket = connectionProvider(context).obsWebSocket;
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

  static Future<String?> selectScenes(BuildContext context) async {
    ObsWebSocket? obsWebSocket = connectionProvider(context).obsWebSocket;
    if (await OBSConnections.checkIfConnectedToObS(context, obsWebSocket)) {
      try {
        final sceneList = await obsWebSocket?.scenes.getSceneList();

        if (sceneList?.scenes != null && sceneList!.scenes.isNotEmpty) {
          return await showModalBottomSheet<String>(
            context: context,
            builder: (context) {
              return ListView.builder(
                itemCount: sceneList.scenes.length,
                itemBuilder: (context, int index) {
                  String sceneName = sceneList.scenes[index].sceneName;
                  return ListTile(
                    title: Text(sceneName),
                    onTap: () {
                      Navigator.pop(context, sceneName);
                    },
                  );
                },
              );
            },
          );
        } else {
          // Handle the case when no scenes are available
          // You can show an error message or take appropriate action
          return '';
        }
      } catch (e) {
        throw Exception('Error getting scene: $e');
      }
    } else {
      // Handle the case when not connected to OBS
      // You can show an error message or take appropriate action
      return '';
    }
  }

  static Future<void> startRecord(BuildContext context) async {
    ObsWebSocket? obsWebSocket = connectionProvider(context).obsWebSocket;
    if (await OBSConnections.checkIfConnectedToObS(context, obsWebSocket)) {
      try {
        obsWebSocket?.record.startRecord();
        debugPrint(
            '[RECORD STATUS]: ${obsWebSocket?.record.getRecordStatus()}');
      } catch (e) {
        // Handle any errors that occur while changing the scene
        throw Exception('Error changing scene: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  static Future<void> stopRecord(BuildContext context) async {
    ObsWebSocket? obsWebSocket = connectionProvider(context).obsWebSocket;
    if (await OBSConnections.checkIfConnectedToObS(context, obsWebSocket)) {
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
  }

  static Future<void> startStream(BuildContext context) async {
    ObsWebSocket? obsWebSocket = connectionProvider(context).obsWebSocket;
    if (await OBSConnections.checkIfConnectedToObS(context, obsWebSocket)) {
      try {
        obsWebSocket?.stream.startStream();
        debugPrint(
            '[RECORD STATUS]: ${obsWebSocket?.record.getRecordStatus()}');
      } catch (e) {
        // Handle any errors that occur while changing the scene
        throw Exception('Error changing scene: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  static Future<void> stopStream(BuildContext context) async {
    ObsWebSocket? obsWebSocket = connectionProvider(context).obsWebSocket;
    if (await OBSConnections.checkIfConnectedToObS(context, obsWebSocket)) {
      try {
        obsWebSocket?.stream.stopStream();
        debugPrint(
            '[RECORD STATUS]: ${obsWebSocket?.record.getRecordStatus()}');
      } catch (e) {
        // Handle any errors that occur while changing the scene
        throw Exception('Error changing scene: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  static final Map<String, OBSMethodMetadata> obsMethodMetadata = {
    changSceneMethod: OBSMethodMetadata([selectSceneMethod]),
    startRecordMethod: OBSMethodMetadata([]),
    stopRecordMethod: OBSMethodMetadata([]),
    startStreamMethod: OBSMethodMetadata([]),
    stopStreamMethod: OBSMethodMetadata([]),
  };

  getMethodParameters(String methodName) {
    return obsMethodMetadata[methodName]?.parameterNames ?? [];
  }
}

typedef OBSMethod = Function(BuildContext, String);

final Map<String, OBSMethod> obsMethods = {
  changSceneMethod: OBSActions.changeScenes,
  // selectSceneMethod: (
  //   BuildContext context,
  //   String sceneName,
  // ) async {
  //   await OBSActions.selectScenes(context);
  // },
  startRecordMethod: (
    BuildContext context,
    String sceneName,
  ) async {
    OBSActions.startRecord(context);
  },
  stopRecordMethod: (
    BuildContext context,
    String sceneName,
  ) async {
    OBSActions.stopRecord(context);
  },
  startStreamMethod: (
    BuildContext context,
    String sceneName,
  ) async {
    OBSActions.startStream(context);
  },
  stopStreamMethod: (
    BuildContext context,
    String sceneName,
  ) async {
    OBSActions.stopStream(context);
  },
};
