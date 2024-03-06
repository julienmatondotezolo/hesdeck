import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/services/connections/light_connection.dart';

const changeLightMethod = 'Change light';

class SliderValueNotifier {
  static final ValueNotifier<double> sliderValue = ValueNotifier<double>(0.0);
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

    if (await LightConnections.checkIfConnectedToLights(context, lightClient)) {
      var rng = Random();

      List<int> randomColor =
          updateColor(rng.nextInt(256), rng.nextInt(256), rng.nextInt(256));

      try {
        await sendCharacteristic?.write(
          randomColor,
        );
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
