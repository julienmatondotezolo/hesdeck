import 'package:flutter/material.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/services/connections/obs_connections.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:hessdeck/utils/helpers.dart';
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
        debugPrint('[SCENES CHANGED TO]: $sceneName');
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
        final screenHeight = MediaQuery.of(context).size.height;

        if (sceneList?.scenes != null && sceneList!.scenes.isNotEmpty) {
          // ignore: use_build_context_synchronously
          return await showModalBottomSheet<String>(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  decoration: const BoxDecoration(
                    gradient: AppColors.blueToGreyGradient,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(
                          color: AppColors.darkGrey,
                          thickness: 5,
                          indent: 140,
                          endIndent: 140,
                        ),
                        SizedBox(
                          height:
                              screenHeight * 0.03, // 3% of the screen height
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 26.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Select scene",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        for (final scene in sceneList.scenes)
                          GestureDetector(
                            onTap: () {
                              Helpers.vibration();
                              String sceneName = scene.sceneName;
                              Navigator.pop(context, sceneName);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color:
                                    AppColors.darkGrey, // Grey background color
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white10,
                                    width: 1.0,
                                  ), // Thin white border bottom
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 26.0,
                                vertical: 16.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    scene.sceneName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              });
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
  startRecordMethod: (
    BuildContext context,
    String sceneName,
  ) async {
    return await OBSActions.startRecord(context);
  },
  stopRecordMethod: (
    BuildContext context,
    String sceneName,
  ) async {
    return await OBSActions.stopRecord(context);
  },
  startStreamMethod: (
    BuildContext context,
    String sceneName,
  ) async {
    return await OBSActions.startStream(context);
  },
  stopStreamMethod: (
    BuildContext context,
    String sceneName,
  ) async {
    return await OBSActions.stopStream(context);
  },
};

final Map<String, OBSMethod> obsMethodParameters = {
  selectSceneMethod: (
    BuildContext context,
    String sceneName,
  ) async {
    return await OBSActions.selectScenes(context);
  },
};
