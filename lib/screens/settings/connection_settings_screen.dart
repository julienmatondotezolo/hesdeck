import 'package:flutter/material.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/services/connections/manageConnections.dart';
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

  @override
  void initState() {
    super.initState();

    // Initialize controllers with values from the provider
    controllers = List.generate(widget.fields.length, (index) {
      return TextEditingController();
    });

    // controllers = List.generate(widget.fields.length, (index) {
    //   String initialValue = // Fetch initial values from the provider using ConnectionProvider
    //       Provider.of<ConnectionProvider>(context, listen: false)
    //           .getInitialValueForField(widget.fields[index]);
    //   return TextEditingController(text: initialValue);
    // });
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
    return Consumer<ConnectionProvider>(
        builder: (context, connectionProvider, _) {
      Connection currentConnection =
          connectionProvider.getCurrentCoonnection(widget.connectionName);

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
                    !currentConnection.connected
                        ? ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
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
                    ElevatedButton(
                      onPressed: () async {
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
