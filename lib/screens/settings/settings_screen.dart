import 'package:flutter/material.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/screens/settings/obs_settings_screen.dart';
import 'package:hessdeck/themes/colors.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List<Connection> _connections;

  void _showConnectionsModal(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      backgroundColor: const Color(0xFF262626),
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              decoration: const BoxDecoration(
                gradient: AppColors.blueToGreyGradient,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    color: AppColors.darkGrey,
                    thickness: 5,
                    indent: 140,
                    endIndent: 140,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03, // 3% of the screen height
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Add a new connection",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OBSSettingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.darkGrey, // Grey background color
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white10,
                            width: 1.0,
                          ), // Thin white border bottom
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            'https://obsproject.com/assets/images/new_icon_small-r.png', // Replace with the actual URL
                            width: 24,
                          ),
                          const SizedBox(width: 16.0),
                          const Text(
                            'OBS',
                            style: TextStyle(
                                color: Colors.white), // White text color
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // _addConnection('Twitch');
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.darkGrey, // Grey background color
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white10,
                            width: 1.0,
                          ), // Thin white border bottom
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            'https://cdn-icons-png.flaticon.com/512/2111/2111668.png', // Replace with the actual URL
                            width: 24,
                          ),
                          const SizedBox(width: 16.0),
                          const Text(
                            'Twitch',
                            style: TextStyle(
                                color: Colors.white), // White text color
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ConnectionProvider connectionProvider =
        Provider.of<ConnectionProvider>(context);

    _connections = connectionProvider.connections;

    // Get the screen height using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(25.0),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white, // Set the text color to white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Connections",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                if (_connections.isEmpty)
                  const Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "No connections",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                for (var connection in _connections)
                  GestureDetector(
                    onTap: () {
                      Future.microtask(() {
                        if (connection.type == 'OBS') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OBSSettingsScreen(),
                            ),
                          );
                        }
                      });
                      // Navigator.pop(context);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white10,
                            width: 1.0,
                          ), // Thin white border bottom
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            'https://cdn-icons-png.flaticon.com/512/2111/2111668.png', // Replace with the actual URL
                            width: 24,
                          ),
                          const SizedBox(width: 16.0),
                          Text(
                            connection.type,
                            style: const TextStyle(
                              color: Colors.white,
                            ), // White text color
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: screenHeight * 0.025),
                ElevatedButton(
                  onPressed: () => _showConnectionsModal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGrey, // Dark grey color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Rounded corners
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white), // + icon
                      SizedBox(width: 8), // Spacing
                      Text('Add Connection'), // Text
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Logout',
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
