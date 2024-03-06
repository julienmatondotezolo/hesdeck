import 'package:flutter/material.dart';
import 'package:hessdeck/services/actions/lights_elements_actions.dart';
import 'package:hessdeck/services/actions/obs_actions.dart';
import 'package:hessdeck/services/actions/stream_elements_actions.dart';

class ManageAcions {
  static Future<dynamic> selectAction(
    BuildContext context,
    String connectionType,
    String actionName,
    String? actionParameter,
  ) async {
    switch (connectionType) {
      case 'OBS':
        return await obsMethods[actionName]!(
          context,
          actionParameter ?? '',
        );
      case 'Lights':
        return await lightsMethods[actionName]!(
          context,
        );
      case 'StreamElements':
        return await streamElementsMethods[actionName]!(
          context,
          actionParameter ?? '',
        );
      default:
        throw Exception(
          'No ACTIONS for [$connectionType] exists in this services.',
        );
    }
  }

  static Future<dynamic> selectActionParameter(
    BuildContext context,
    String connectionType,
    String actionName,
    String? actionParameter,
  ) async {
    switch (connectionType) {
      case 'OBS':
        return await obsMethodParameters[actionName]!(
          context,
          actionParameter ?? '',
        );
      case 'StreamElements':
        return await streamElementsMethodParameters[actionName]!(
          context,
          actionParameter ?? '',
        );
      default:
        throw Exception(
          'No ACTIONS for [$connectionType] exists in this services.',
        );
    }
  }

  static Map<String, dynamic> getAllActions() {
    return {
      'OBS': obsMethods,
      'Lights': lightsMethods,
      'StreamElements': streamElementsMethods,
    };
  }

  // static Map<String, Function(BuildContext, String)> getAllActions() {
  //   Map<String, Function(BuildContext, String)> allActions = {};

  //   // Add OBS methods
  //   allActions.addAll(obsMethods);

  //   // Add StreamElements methods
  //   allActions.addAll(streamElementsMethods);

  //   return allActions;
  // }

  List<String> getMethodParameters(String methodName) {
    Map<String, dynamic> methodMetadataList = {};
    Map<String, OBSMethodMetadata> obsMethodMetadata =
        OBSActions.obsMethodMetadata;
    Map<String, LightsMethodMetadata> lightsMethodMetadata =
        LightsActions.lightsMethodMetadata;
    Map<String, StreamElementsMethodMetadata> streamElementsMethodMetadata =
        StreamElementsActions.streamElementsMethodMetadata;

    methodMetadataList.addAll(obsMethodMetadata);
    methodMetadataList.addAll(lightsMethodMetadata);
    methodMetadataList.addAll(streamElementsMethodMetadata);

    List<String> methodParameter =
        methodMetadataList[methodName]?.parameterNames ?? [];

    return methodParameter;
  }
}
