import 'package:flutter/material.dart';
import 'package:my_mobile_deck/providers/connection_provider.dart';
import 'package:my_mobile_deck/services/connections/spotify_connections.dart';
import 'package:my_mobile_deck/themes/colors.dart';
import 'package:my_mobile_deck/utils/helpers.dart';
import 'package:spotify_api/spotify_api.dart';

const getPlayBackStateMethod = 'Playback state';
const selectDevicesMethod = 'Select device';
const startPlaybackMethod = 'Start song';
const pausePlaybackMethod = 'Pause song';
const previousPlaybackMethod = 'Previous song';
const nextPlaybackMethod = 'Next song';

class SpotifyMethodMetadata {
  final List<String> parameterNames;

  SpotifyMethodMetadata(this.parameterNames);
}

class SpotifyActions {
  static Future<void> getPlaybackState(
    BuildContext context,
  ) async {
    SpotifyApi? spotifyApi = connectionProvider(context).spotifyApi;
    if (await SpotifyConnections.checkIfConnectedToSpotify(
        context, spotifyApi)) {
      try {
        await spotifyApi!.getCurrentPlaybackState();
      } catch (e) {
        // Handle any errors that occur while changing the scene
        throw Exception('Error starting playback: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  static Future<String?> selectDevices(BuildContext context) async {
    SpotifyApi? spotifyApi = connectionProvider(context).spotifyApi;

    if (await SpotifyConnections.checkIfConnectedToSpotify(
        context, spotifyApi)) {
      try {
        if (!context.mounted) return '';

        final screenHeight = MediaQuery.of(context).size.height;
        List? devices = await spotifyApi?.getAllDevices();

        if (devices != null) {
          if (!context.mounted) return '';
          return showModalBottomSheet<String>(
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
                        height: screenHeight * 0.03, // 3% of the screen height
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Select device",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      for (final device in devices)
                        GestureDetector(
                          onTap: () {
                            Helpers.vibration();
                            String sceneName = device['id'];
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
                                  device['name'],
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
            },
          );
        }
      } catch (e) {
        throw Exception('Error getting devices: $e');
      }
    }
    return null;
  }

  static Future<void> startPlayback(
    BuildContext context,
    String deviceId,
  ) async {
    SpotifyApi? spotifyApi = connectionProvider(context).spotifyApi;
    if (await SpotifyConnections.checkIfConnectedToSpotify(
        context, spotifyApi)) {
      try {
        await spotifyApi!.startPlayback(deviceId);
      } catch (e) {
        // Handle any errors that occur while changing the scene
        throw Exception('Error starting playback: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  static Future<void> pausePlayback(
    BuildContext context,
    String deviceId,
  ) async {
    SpotifyApi? spotifyApi = connectionProvider(context).spotifyApi;
    if (await SpotifyConnections.checkIfConnectedToSpotify(
        context, spotifyApi)) {
      try {
        await spotifyApi!.pausePlayback(deviceId);
      } catch (e) {
        // Handle any errors that occur while changing the scene
        throw Exception('Error pausing playback: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  static Future<void> previousPlayback(
    BuildContext context,
    String deviceId,
  ) async {
    SpotifyApi? spotifyApi = connectionProvider(context).spotifyApi;
    if (await SpotifyConnections.checkIfConnectedToSpotify(
        context, spotifyApi)) {
      try {
        await spotifyApi!.previousPlayback(deviceId);
      } catch (e) {
        // Handle any errors that occur while changing the scene
        throw Exception('Error previousing playback: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  static Future<void> nextPlayback(
    BuildContext context,
    String deviceId,
  ) async {
    SpotifyApi? spotifyApi = connectionProvider(context).spotifyApi;
    if (await SpotifyConnections.checkIfConnectedToSpotify(
        context, spotifyApi)) {
      try {
        await spotifyApi!.nextPlayback(deviceId);
      } catch (e) {
        // Handle any errors that occur while changing the scene
        throw Exception('Error nexting playback: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  static final Map<String, SpotifyMethodMetadata> spotifyMethodMetadata = {
    getPlayBackStateMethod: SpotifyMethodMetadata([]),
    startPlaybackMethod: SpotifyMethodMetadata([selectDevicesMethod]),
    pausePlaybackMethod: SpotifyMethodMetadata([selectDevicesMethod]),
    previousPlaybackMethod: SpotifyMethodMetadata([selectDevicesMethod]),
    nextPlaybackMethod: SpotifyMethodMetadata([selectDevicesMethod]),
  };

  getMethodParameters(String methodName) {
    return spotifyMethodMetadata[methodName]?.parameterNames ?? [];
  }
}

typedef SpotifyMethod = Function(BuildContext, String);

final Map<String, SpotifyMethod> spotifyMethods = {
  getPlayBackStateMethod: (
    BuildContext context,
    String sceneName,
  ) async {
    return await SpotifyActions.getPlaybackState(context);
  },
  startPlaybackMethod: SpotifyActions.startPlayback,
  pausePlaybackMethod: SpotifyActions.pausePlayback,
  previousPlaybackMethod: SpotifyActions.previousPlayback,
  nextPlaybackMethod: SpotifyActions.nextPlayback
};

final Map<String, SpotifyMethod> spotifyMethodParameters = {
  selectDevicesMethod: (
    BuildContext context,
    String device,
  ) async {
    return await SpotifyActions.selectDevices(context);
  },
};
