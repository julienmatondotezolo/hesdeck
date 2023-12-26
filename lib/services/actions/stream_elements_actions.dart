import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/services/connections/stream_elements_connections.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:stream_elements_package/stream_elements.dart';

const selectOverlayMethod = 'Select overlay';
const updateOverlayMethod = 'Update overlay';

class SliderValueNotifier {
  static final ValueNotifier<double> sliderValue = ValueNotifier<double>(0.0);
}

class StreamElementsMethodMetadata {
  final List<String> parameterNames;

  StreamElementsMethodMetadata(this.parameterNames);
}

class StreamElementsActions {
  static Future<String?> selectOverlay(BuildContext context) async {
    StreamElements? streamElements =
        connectionProvider(context).streamElementsClient;

    final screenHeight = MediaQuery.of(context).size.height;

    if (await StreamElementsConnections.checkIfConnectedToStreamElements(
        context, streamElements)) {
      try {
        Map<String, dynamic> response = await streamElements!.getAllOverlays();
        final overlayList = response['docs']
            .map<Map<String, dynamic>>((overlay) => {
                  '_id': overlay['_id'],
                  'type': overlay['type'],
                  'name': overlay['name'],
                })
            .toList();

        if (overlayList != null && overlayList.isNotEmpty) {
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
                        height: screenHeight * 0.03, // 3% of the screen height
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Select overlay",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      for (final overlay in overlayList)
                        GestureDetector(
                          onTap: () {
                            String id = overlay['_id'];
                            Navigator.pop(context, id);
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
                                  overlay['name'],
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
        throw Exception('Error getting overlays: $e');
      }
    }
    return null;
  }

  static Future<void> updateOverlay(
    BuildContext context,
    String overlayId,
  ) async {
    StreamElements? streamElements =
        connectionProvider(context).streamElementsClient;

    final screenHeight = MediaQuery.of(context).size.height;

    if (await StreamElementsConnections.checkIfConnectedToStreamElements(
      context,
      streamElements,
    )) {
      try {
        final body = await streamElements?.getOverlayByID(overlayId);

        String overlayName = body?["name"];
        final listeners = body?["widgets"][0]["listeners"];
        final variables = body?["widgets"][0]["variables"];

        List<Map<String, dynamic>>? allAlerts = [];

        listeners.forEach((key, value) {
          if (value == true) {
            final alertName = key.substring(0, key.length - 7);
            final alertObject = variables[alertName]["audio"];

            Map<String, dynamic>? alertMap = {
              alertName: alertObject,
            };

            allAlerts.add(alertMap);
          }
        });

        // Initialize SliderValueNotifier.sliderValue after populating allAlerts
        final initialVolume = allAlerts.isNotEmpty
            ? allAlerts[0][allAlerts[0].keys.first]['volume'] * 100
            : 0.0;

        SliderValueNotifier.sliderValue.value = initialVolume;

        // Play sound
        final audioPlayer = AudioPlayer();

        // print('allAlerts: $allAlerts');

        if (overlayName.isNotEmpty) {
          // ignore: use_build_context_synchronously
          showModalBottomSheet<String>(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                decoration: const BoxDecoration(
                  gradient: AppColors.blueToGreyGradient,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(
                        color: AppColors.darkGrey,
                        thickness: 5,
                        indent: 140,
                        endIndent: 140,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Update overlay",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      TextFormField(
                        initialValue: overlayName,
                        onChanged: (newValue) {
                          overlayName = newValue;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Overlay name',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Column(
                        children: [
                          for (final alert in allAlerts)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 10.0),
                              padding: const EdgeInsets.fromLTRB(
                                25.0,
                                25.0,
                                25.0,
                                5.0,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blueGrey,
                                borderRadius: BorderRadius.circular(10.0),
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await audioPlayer.play(
                                            UrlSource(
                                              alert[alert.keys.first]['src'],
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 36,
                                        ),
                                      ),
                                      SizedBox(width: screenHeight * 0.025),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            alert[alert.keys.first]['name'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            alert.keys.first.toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Replace the Slider widget in your code with the following:
                                  ValueListenableBuilder<double>(
                                    valueListenable:
                                        SliderValueNotifier.sliderValue,
                                    builder: (context, value, child) {
                                      return Slider.adaptive(
                                        min: 0.0,
                                        max: 100.0,
                                        value: SliderValueNotifier
                                                    .sliderValue.value ==
                                                0.0
                                            ? (alert[alert.keys.first]
                                                    ['volume'] *
                                                100)
                                            : SliderValueNotifier
                                                .sliderValue.value,
                                        activeColor: AppColors.lightGrey,
                                        inactiveColor: AppColors.darkGrey,
                                        onChanged: (newValue) {
                                          SliderValueNotifier
                                              .sliderValue.value = newValue;
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      ElevatedButton(
                        onPressed: () {
                          // Update overlayName in the body
                          body?["name"] = overlayName;

                          // Update audio volume in variables
                          for (int i = 0; i < allAlerts.length; i++) {
                            final alert = allAlerts[i];
                            final alertName = alert.keys.first;
                            final newVolume =
                                SliderValueNotifier.sliderValue.value / 100;

                            body?["widgets"][0]["variables"][alertName]["audio"]
                                ["volume"] = newVolume;
                          }

                          streamElements?.updateOverlayByID(overlayId, body);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Text(
                          'Update overlay',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        // final response =
        //     await streamElements!.updateOverlayByID(overlayId, body);
      } catch (e) {
        throw Exception('Error updating overlays: $e');
      }
    }
  }

  static Future<void> getAllOverlays(BuildContext context) async {
    StreamElements? streamElements =
        connectionProvider(context).streamElementsClient;
    if (await StreamElementsConnections.checkIfConnectedToStreamElements(
        context, streamElements)) {
      try {
        Map<String, dynamic> response = await streamElements!.getAllOverlays();
        final data = response['docs']
            .map<Map<String, dynamic>>((overlay) => {
                  '_id': overlay['_id'],
                  'type': overlay['type'],
                  'name': overlay['name'],
                })
            .toList();

        print('data: $data');
      } catch (e) {
        throw Exception('Error getting overlays: $e');
      }
    }
  }

  static final Map<String, StreamElementsMethodMetadata>
      streamElementsMethodMetadata = {
    selectOverlayMethod: StreamElementsMethodMetadata([]),
    updateOverlayMethod: StreamElementsMethodMetadata([selectOverlayMethod]),
  };
}

typedef StreamElementsMethod = Function(BuildContext, String);

final Map<String, StreamElementsMethod> streamElementsMethods = {
  updateOverlayMethod: (
    BuildContext context,
    String overlayId,
  ) async {
    return await StreamElementsActions.updateOverlay(context, overlayId);
  },
};

final Map<String, StreamElementsMethod> streamElementsMethodParameters = {
  selectOverlayMethod: (
    BuildContext context,
    String overlayId,
  ) async {
    return await StreamElementsActions.selectOverlay(context);
  }
};
