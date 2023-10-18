import 'package:flutter/material.dart';
import 'package:hessdeck/services/connections/obs_connections.dart';

class ManageConnections {
  static Future<void> selectConnection(
    BuildContext context,
    String connectionType,
    List<TextEditingController> controllers,
  ) async {
    if (connectionType == 'OBS') {
      await OBSConnections.connectToOBS(
        context,
        controllers[0],
        controllers[1],
        controllers[2],
      );
    }

    if (connectionType == 'Twitch') {
      print("Twitch connection...");
    }
  }
}
