import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/screens/settings/mobile_scanner_screen.dart';
import 'package:hessdeck/services/connections/manage_connections.dart';
import 'package:hessdeck/utils/helpers.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class ConnectionSettingsScreen extends StatefulWidget {
  final String connectionName;
  final List<dynamic> fields;

  const ConnectionSettingsScreen({
    Key? key,
    required this.connectionName,
    required this.fields,
  }) : super(key: key);

  @override
  ConnectionSettingsScreenState createState() =>
      ConnectionSettingsScreenState();
}

class ConnectionSettingsScreenState extends State<ConnectionSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late List<TextEditingController> controllers;

  MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  void initState() {
    super.initState();

    // Initialize controllers with values from the provider
    controllers = List.generate(widget.fields.length, (index) {
      String fieldValue =
          Provider.of<ConnectionProvider>(context, listen: false)
              .getFieldValue(widget.fields[index], widget.connectionName);

      return TextEditingController(text: fieldValue);
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
      scannerController.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionProvider>(
        builder: (context, connectionProvider, _) {
      bool isConnected = false;

      Connection? currentConnection =
          connectionProvider.getCurrentConnection(widget.connectionName);

      if (currentConnection != null) {
        isConnected = currentConnection.connected;
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.connectionName} settings'),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < widget.fields.length; i++)
                      Column(
                        children: [
                          TextFormField(
                            controller: controllers[i],
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: widget.fields[i],
                              labelStyle: const TextStyle(color: Colors.white),
                              border: const OutlineInputBorder(),
                            ),
                            enableInteractiveSelection: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                HapticFeedback.vibrate();
                                return 'Please enter the ${widget.fields[i]}';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    widget.connectionName == 'OBS' && !isConnected
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MobileScannerScreen(
                                    scannerController: scannerController,
                                    connectionType: widget.connectionName,
                                  ),
                                ),
                              ).then((barcodeRawValue) {
                                controllers[0].value =
                                    TextEditingValue(text: barcodeRawValue[0]);

                                controllers[1].value =
                                    TextEditingValue(text: barcodeRawValue[1]);

                                controllers[2].value =
                                    TextEditingValue(text: barcodeRawValue[2]);

                                Helpers.vibration();
                                ManageConnections.selectConnection(
                                  context,
                                  widget.connectionName,
                                  controllers,
                                );
                              });
                            },
                            child: const Text(
                              'Scan to Connect',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const Spacer(),
                    !isConnected
                        ? ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Helpers.vibration();
                                ManageConnections.selectConnection(
                                  context,
                                  widget.connectionName,
                                  controllers,
                                );

                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Connect',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              Helpers.vibration();
                              ManageConnections.selectDisconnection(
                                context,
                                widget.connectionName,
                                connectionProvider,
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              'Disconnect',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                    const SizedBox(height: 16.0),
                    if (currentConnection != null)
                      ElevatedButton(
                        onPressed: () async {
                          HapticFeedback.vibrate();
                          ManageConnections.selectDeleteConnection(
                            widget.connectionName,
                            connectionProvider,
                            currentConnection,
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor:
                              Colors.transparent, // Set the text color to red
                          side: const BorderSide(
                            color: Colors.red,
                            width: 3.0,
                          ), // Set red border
                        ),
                        child: Text(
                          'Delete ${widget.connectionName} connection',
                          style: const TextStyle(
                            color: Colors.red,
                          ), // Set text color to red
                        ),
                      )
                  ],
                )),
          ),
        ),
      );
    });
  }
}
