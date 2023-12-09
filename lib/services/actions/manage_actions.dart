import 'package:flutter/material.dart';
import 'package:hessdeck/services/actions/obs_actions.dart';
import 'package:hessdeck/services/actions/stream_elements_actions.dart';

class ManageAcions {
  static Future<void> selectAction(
    BuildContext context,
    String connectionType,
    String actionName,
    String? actionParameter,
  ) async {
    print('connectionType: $connectionType');
    print('actionName: $actionName');
    print('actionParameter: $actionParameter');
    switch (connectionType) {
      case 'OBS':
        obsMethodParameters[actionName]!(context, actionParameter ?? '');
        break;
      case 'StreamElements':
        streamElementsMethodParameters[actionName]!(
            context, actionParameter ?? '');
        break;
      default:
        throw Exception(
          'No ACTIONS for [$connectionType] exists in this services.',
        );
    }
  }

  static Map<String, dynamic> getAllActions() {
    return {
      'OBS': obsMethods,
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
    Map<String, StreamElementsMethodMetadata> streamElementsMethodMetadata =
        StreamElementsActions.streamElementsMethodMetadata;

    methodMetadataList.addAll(obsMethodMetadata);
    methodMetadataList.addAll(streamElementsMethodMetadata);

    List<String> methodParameter =
        methodMetadataList[methodName]?.parameterNames ?? [];

    return methodParameter;
  }
}
