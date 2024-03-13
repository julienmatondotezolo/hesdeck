import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BLEPage extends StatefulWidget {
  const BLEPage({super.key});

  @override
  _BLEPageState createState() => _BLEPageState();
}

class _BLEPageState extends State<BLEPage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? device;
  BluetoothCharacteristic? receiveCharacteristic;
  BluetoothCharacteristic? sendCharacteristic;
  String primaryServiceUuid = 'f000aa60-0451-4000-b000-000000000000';
  String receiveCharUuid = 'f000aa63-0451-4000-b000-000000000000';
  String sendCharUuid = 'f000aa61-0451-4000-b000-000000000000';

  @override
  void initState() {
    super.initState();
    connectToDevice();
  }

  void connectToLight() async {
    // Scanning for devices
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    // Listening to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.name == 'Your Device Name') {
          // Adjust this to match your device
          device = result.device;
          stopScan();
          connectToDevice();
          break;
        }
      }
    });

    // Stop scanning after a certain period
    Future.delayed(const Duration(seconds: 4)).then((_) {
      subscription.cancel();
      stopScan();
    });
  }

  void stopScan() {
    flutterBlue.stopScan();
  }

  void connectToDevice() async {
    if (device == null) return;

    await device!.connect();
    discoverServices();
  }

  void discoverServices() async {
    if (device == null) return;

    List<BluetoothService> services = await device!.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == primaryServiceUuid) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == receiveCharUuid) {
            receiveCharacteristic = characteristic;
          } else if (characteristic.uuid.toString() == sendCharUuid) {
            sendCharacteristic = characteristic;
          }
        }
      }
    }

    if (receiveCharacteristic != null) {
      listenToCharacteristic();
    }
  }

  void listenToCharacteristic() {
    if (receiveCharacteristic == null) return;

    receiveCharacteristic!.setNotifyValue(true);
    receiveCharacteristic!.value.listen((value) {
      // Process the received value
      print('Received value: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Connection'),
      ),
      body: const Center(
        child: Text('BLE Connection Example'),
      ),
    );
  }
}
