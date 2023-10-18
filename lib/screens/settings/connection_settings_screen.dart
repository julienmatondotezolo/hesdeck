import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.connectionName} Settings'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(25.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var field in widget.fields) TextFormField(),
                  const SizedBox(height: 16),
                ],
              )),
        ),
      ),
    );
  }
}
