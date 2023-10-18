import 'package:flutter/material.dart';
import 'package:hessdeck/services/connections/obs_connections.dart';
import 'package:hessdeck/services/connections/twitch_connections%20.dart';

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
    } else if (connectionType == 'Twitch') {
      await TwitchConnections.connectToTwitch(
        context,
        controllers[0],
        controllers[1],
        controllers[2],
      );
    } else {
      print('No CONNECTION for [$connectionType] exists in this services.');
    }
  }
}
