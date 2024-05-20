import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_mobile_deck/providers/connection_provider.dart';
import 'package:my_mobile_deck/services/connections/light_connection.dart';
import 'package:my_mobile_deck/themes/colors.dart';

const changeLightMethod = 'Change light';

class SliderValueNotifier {
  static final ValueNotifier<double> sliderValue = ValueNotifier<double>(0.0);
}

class ColorValueNotifier {
  static final ValueNotifier<Color> colorValue =
      ValueNotifier<Color>(Colors.white);
}

class LightsMethodMetadata {
  final List<String> parameterNames;

  LightsMethodMetadata(this.parameterNames);
}

class LightsActions {
  static Future<void> changeColor(BuildContext context) async {
    BluetoothDevice? lightClient = connectionProvider(context).lightClient;
    BluetoothCharacteristic? sendCharacteristic =
        connectionProvider(context).sendCharacteristic;
    final screenHeight = MediaQuery.of(context).size.height;

    if (await LightConnections.checkIfConnectedToLights(context, lightClient)) {
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
                        "Change color",
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
                      showLabel: false,
                      displayThumbColor: false,
                      onColorChanged: (color) async {
                        ColorValueNotifier.colorValue.value = color;

                        await sendCharacteristic?.write(
                          updateColor(
                            color.red,
                            color.green,
                            color.blue,
                          ),
                        );
                      },
                      paletteType: PaletteType.hueWheel,
                      pickerAreaHeightPercent: 0.8,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    ElevatedButton(
                      onPressed: () {
                        // Update overlayName in the body
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save light color'),
                    ),
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

  static final Map<String, LightsMethodMetadata> lightsMethodMetadata = {
    changeLightMethod: LightsMethodMetadata([]),
  };
}

typedef LightsMethod = Function(BuildContext);

final Map<String, LightsMethod> lightsMethods = {
  changeLightMethod: LightsActions.changeColor,
};

List<int> updateColor(int r, int g, int b) {
  // Command prefix [0xae, 0xa1] followed by RGB values and a checksum [0x56]
  List<int> data = [0xae, 0xa1, r, g, b, 0x56];
  return data;
}
