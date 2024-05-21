import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_mobile_deck/providers/connection_provider.dart';
import 'package:my_mobile_deck/services/connections/deck_lights_connections.dart';
import 'package:my_mobile_deck/themes/colors.dart';
import 'package:wled_api/wled_api.dart';

const toggleDeckLightsMethod = 'Deck light Toggle';
const updateDeckLighstMethod = 'Deck light Change color';

class SliderValueNotifier {
  static final ValueNotifier<double> sliderValue = ValueNotifier<double>(0.0);
}

class ColorValueNotifier {
  static final ValueNotifier<Color> colorValue = ValueNotifier<Color>(
    const Color.fromARGB(255, 255, 180, 0),
  );
}

class DeckLightsMethodMetadata {
  final List<String> parameterNames;

  DeckLightsMethodMetadata(this.parameterNames);
}

class DeckLightsActions {
  static Future<void> toggleDeckLights(BuildContext context) async {
    WLED? deckLightsClient = connectionProvider(context).deckLightsClient;

    if (await DeckLightsConnections.checkIfConnectedToDeckLights(
      context,
      deckLightsClient,
    )) {
      try {
        WLED wled = WLED(deckLightsClient!.ipAddress);
        await WLED.toggle(wled);
      } catch (e) {
        // Handle any errors that occur while changing the scene
        throw Exception('Error toggle Deck lights: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  static Future<void> updateDeckLightsColor(BuildContext context) async {
    WLED? deckLightsClient = connectionProvider(context).deckLightsClient;
    final screenHeight = MediaQuery.of(context).size.height;

    if (await DeckLightsConnections.checkIfConnectedToDeckLights(
      context,
      deckLightsClient,
    )) {
      try {
        if (!context.mounted) return;

        showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
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
                        "Change Deck light colors",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    ColorPicker(
                      pickerColor: ColorValueNotifier.colorValue.value,
                      hexInputBar: true,
                      enableAlpha: false,
                      labelTypes: const [],
                      displayThumbColor: false,
                      onColorChanged: (color) async {
                        ColorValueNotifier.colorValue.value = color;
                        WLED wled = WLED(deckLightsClient!.ipAddress);

                        await WLED.updateColor(
                          wled,
                          red: color.red.toString(),
                          green: color.green.toString(),
                          blue: color.blue.toString(),
                          bri: 255.toString(),
                        );
                      },
                      paletteType: PaletteType.hueWheel,
                      pickerAreaHeightPercent: 0.8,
                    ),
                    // SizedBox(height: screenHeight * 0.025),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Update overlayName in the body
                    //     Navigator.pop(context);
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue,
                    //     foregroundColor: Colors.white,
                    //   ),
                    //   child: const Text('Save light color'),
                    // ),
                  ],
                ),
              ),
            );
          },
        );
        //
      } catch (e) {
        // Handle any errors that occur while changing the scene
        throw Exception('Error updating lights: $e');
        // Show an error message or take appropriate action
      }
    }
  }

  static final Map<String, DeckLightsMethodMetadata> lightsMethodMetadata = {
    updateDeckLighstMethod: DeckLightsMethodMetadata([]),
  };
}

typedef DeckLightsMethod = Function(BuildContext);

final Map<String, DeckLightsMethod> deckLightsMethods = {
  toggleDeckLightsMethod: DeckLightsActions.toggleDeckLights,
  updateDeckLighstMethod: DeckLightsActions.updateDeckLightsColor,
};

List<int> updateColor(int r, int g, int b) {
  // Command prefix [0xae, 0xa1] followed by RGB values and a checksum [0x56]
  List<int> data = [0xae, 0xa1, r, g, b, 0x56];
  return data;
}
