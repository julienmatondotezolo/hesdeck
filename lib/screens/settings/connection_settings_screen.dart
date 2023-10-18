import 'package:flutter/material.dart';
import 'package:hessdeck/services/connections/obs_connections.dart';

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

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.fields.length, (index) {
      return TextEditingController();
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the ${widget.fields[i]}';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await OBSConnections.connectToOBS(
                          context,
                          controllers[0],
                          controllers[1],
                          controllers[2],
                        );
                      }
                    },
                    child: const Text(
                      'Connect',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  /*
                  ElevatedButton(
                          onPressed: () async {
                            await OBSConnections.disconnectOBS(
                                connectionProvider);
                            // Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text(
                            'Disconnect',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                  */
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // await OBSConnections.deleteOBSConnection(
                      //   connectionProvider,
                      //   obsConnectionObject,
                      // );
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
  }
}
