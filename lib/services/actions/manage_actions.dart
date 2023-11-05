import 'package:flutter/material.dart';
import 'package:hessdeck/services/actions/obs_actions.dart';

class ManageAcions {
  static Future<void> selectAction(
    BuildContext context,
    String connectionType,
    String actionName,
    String? actionParameter,
  ) async {
    switch (connectionType) {
      case 'OBS':
        obsMethods[actionName]!(context, actionParameter!);
        break;
      default:
        throw Exception(
          'No ACTIONS for [$connectionType] exists in this services.',
        );
    }
  }

  static Map<String, OBSMethod> getAllActions() {
    return obsMethods;
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
}
