import 'package:flutter/material.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/services/connections/apple_music_connections.dart';
import 'package:hessdeck/services/connections/light_connection.dart';
import 'package:hessdeck/services/connections/obs_connections.dart';
import 'package:hessdeck/services/connections/spotify_connections.dart';
import 'package:hessdeck/services/connections/stream_elements_connections.dart';
import 'package:hessdeck/services/connections/twitch_connections.dart';

class ManageConnections {
  static Future<void> selectConnection(
    BuildContext context,
    String connectionType,
    List<TextEditingController> controllers,
  ) async {
    if (connectionType == 'Apple Music') {
      await AppleMusicConnections.connectToAppleMusic(
        context,
        controllers[0],
        controllers[1],
      );
    } else if (connectionType == 'OBS') {
      await OBSConnections.connectToOBS(
        context,
        controllers[0],
        controllers[1],
        controllers[2],
      );
    } else if (connectionType == 'Lights') {
      await LightConnections.connectToLights(
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
    } else if (connectionType == 'Spotify') {
      await SpotifyConnections.connectToSpotify(context);
    } else if (connectionType == 'StreamElements') {
      await StreamElementsConnections.connectToStreamElements(
        context,
        controllers[0],
        controllers[1],
      );
    } else {
      throw Exception(
        'No CONNECTION for [$connectionType] exists in this services.',
      );
    }
  }

  static Future<void> selectDisconnection(
    BuildContext context,
    String connectionType,
    ConnectionProvider connectionProvider,
  ) async {
    if (connectionType == 'Apple Music') {
      await AppleMusicConnections.disconnectAppleMusic(connectionProvider);
    } else if (connectionType == 'OBS') {
      await OBSConnections.disconnectOBS(context, connectionProvider);
    } else if (connectionType == 'Lights') {
      await LightConnections.disconnectLights(context, connectionProvider);
    } else if (connectionType == 'Twitch') {
      await TwitchConnections.disconnectTwitch(connectionProvider);
    } else if (connectionType == 'Spotify') {
      await SpotifyConnections.disconnectSpotify(connectionProvider);
    } else if (connectionType == 'StreamElements') {
      await StreamElementsConnections.disconnectStreamElements(
        context,
        connectionProvider,
      );
    }
  }

  static Future<void> selectDeleteConnection(
    String connectionType,
    ConnectionProvider connectionProvider,
    Connection connectionObject,
  ) async {
    if (connectionType == 'Apple Music') {
      await AppleMusicConnections.deleteAppleMusicConnection(
        connectionProvider,
        connectionObject,
      );
    } else if (connectionType == 'OBS') {
      await OBSConnections.deleteOBSConnection(
        connectionProvider,
        connectionObject,
      );
    } else if (connectionType == 'Lights') {
      await LightConnections.deleteLightsConnection(
        connectionProvider,
        connectionObject,
      );
    } else if (connectionType == 'Twitch') {
      await TwitchConnections.deleteTwitchConnection(
        connectionProvider,
        connectionObject,
      );
    } else if (connectionType == 'Spotify') {
      await SpotifyConnections.deleteSpotifyConnection(
        connectionProvider,
        connectionObject,
      );
    } else if (connectionType == 'StreamElements') {
      await StreamElementsConnections.deleteStreamElementsConnection(
        connectionProvider,
        connectionObject,
      );
    }
  }
}
