import 'package:flutter/material.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/services/actions/obs_actions.dart';
import 'package:obs_websocket/obs_websocket.dart';

class ManageAcions {
  static Future<void> selectAction(
    BuildContext context,
    String connectionType,
    String actionName,
    String? actionParameter,
  ) async {
    switch (connectionType) {
      case 'OBS':
        ObsWebSocket? obsWebSocket = connectionProvider(context).obsWebSocket;
        obsMethods[actionName]!(context, obsWebSocket, actionParameter!);
        break;
      default:
        throw Exception(
          'No ACTIONS for [$connectionType] exists in this services.',
        );
    }
  }

  static Future<Iterable<String>> getActions(
    BuildContext context,
    String connectionType,
  ) async {
    switch (connectionType) {
      case 'OBS':
        ObsWebSocket? obsWebSocket = connectionProvider(context).obsWebSocket;
        return obsMethods.keys;
        break;
      default:
        throw Exception(
          'No ACTIONS for [$connectionType] exists in this services.',
        );
    }
  }
}
