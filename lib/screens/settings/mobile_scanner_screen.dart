import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/utils/helpers.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerScreen extends StatelessWidget {
  final String connectionType;
  final MobileScannerController scannerController;

  const MobileScannerScreen({
    super.key,
    required this.connectionType,
    required this.scannerController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: scannerController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              OBSConnection? scanResults =
                  Helpers.getScanResults(barcode.rawValue);

              List<String?> fields = [
                scanResults?.ipAddress,
                scanResults?.port,
                scanResults?.password
              ];

              Navigator.pop(context, fields);
            }
          }
        },
      ),
    );
  }
}
