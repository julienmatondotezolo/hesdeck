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
    switch (connectionType) {
      case 'OBS':
        obsMethods[actionName]!(context, actionParameter ?? '');
        break;
      case 'StreamElements':
        streamElementsMethods[actionName]!(context, actionParameter ?? '');
        break;
      default:
        throw Exception(
          'No ACTIONS for [$connectionType] exists in this services.',
        );
    }
  }

  // static Map<String, dynamic> getAllActions() {
  //   return {
  //     'OBS': obsMethods,
  //     'StreamElements': streamElementsMethods,
  //   };
  // }

  static Map<String, Function(BuildContext, String)> getAllActions() {
    Map<String, Function(BuildContext, String)> allActions = {};

    // Add OBS methods
    allActions.addAll(obsMethods);

    // Add StreamElements methods
    allActions.addAll(streamElementsMethods);

    return allActions;
  }
}

  // static Future<Iterable<String>> getActions(
  //   BuildContext context,
  //   String connectionType,
  // ) async {
  //   switch (connectionType) {
  //     case 'OBS':
  //       ObsWebSocket? obsWebSocket = connectionProvider(context).obsWebSocket;
  //       return obsMethods.keys;
  //       break;
  //     default:
  //       throw Exception(
  //         'No ACTIONS for [$connectionType] exists in this services.',
  //       );
  //   }
  // }