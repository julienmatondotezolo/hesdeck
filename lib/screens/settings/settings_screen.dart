import 'package:flutter/material.dart';
import 'package:hessdeck/screens/settings/obs_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen for changes in ConnectionProvider
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OBSSettingsScreen(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text("OBS Settings"),
                    ),
                  ),
                ),
                Card(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Center(
                      child: Text("Twitch Settings"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
