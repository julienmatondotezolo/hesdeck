import 'package:flutter/material.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:hessdeck/utils/connections.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _ipAddressController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load previously saved connection settings from SharedPreferences
    _loadConnectionSettings();
  }

// Load previously saved connection settings from ConnectionProvider
  void _loadConnectionSettings() {
    ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context);

    setState(() {
      _ipAddressController.text = connectionProvider.ipAddress ?? '';
      _portController.text = connectionProvider.port ?? '4455';
      _passwordController.text = connectionProvider.password ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen for changes in ConnectionProvider
    return Consumer<ConnectionProvider>(
        builder: (context, connectionProvider, _) {
      ObsWebSocket? obsWebSocket = connectionProvider.obsWebSocket;
      print('[STATUS]: $obsWebSocket');
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _ipAddressController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'IP Address',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.darkGrey,
                          width: 10.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the IP Address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _portController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Port',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Port';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Password';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  obsWebSocket != null
                      ? ElevatedButton(
                          onPressed: () => Connections.disconnectOBS(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text(
                            'Disconnect',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () => Connections.connectToOBS(
                              context,
                              _formKey,
                              _ipAddressController,
                              _portController,
                              _passwordController),
                          child: const Text(
                            'Connect',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
