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
  List<dynamic> _scenesList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load previously saved connection settings from SharedPreferences
    _loadConnectionSettings();
    _fetchScenesList();
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

  Future<void> _fetchScenesList() async {
    try {
      ObsWebSocket? obsWebSocket =
          Provider.of<ConnectionProvider>(context, listen: false).obsWebSocket;
      SceneListResponse? response = await Connections.getScenes(obsWebSocket);

      if (response != null) {
        setState(() {
          _scenesList =
              response.scenes.map((scene) => scene.sceneName).toList();
        });
      }
    } catch (e) {
      // Handle any errors that occur while fetching the scenes list
      print('Error fetching scenes: $e');
      // Show an error message or take appropriate action
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen for changes in ConnectionProvider
    return Consumer<ConnectionProvider>(
        builder: (context, connectionProvider, _) {
      ObsWebSocket? obsWebSocket = connectionProvider.obsWebSocket;
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
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, // Number of columns in the grid
                      ),
                      itemCount: _scenesList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: GestureDetector(
                            onTap: () {
                              Connections.changeScenes(
                                  obsWebSocket, _scenesList[index]);
                            },
                            child: Center(
                              child: Text(_scenesList[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Button to change scenes
                  // ElevatedButton(
                  //   onPressed: () => Connections.getScenes(obsWebSocket),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue,
                  //   ),
                  //   child: const Text(
                  //     'Change Scene',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
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
