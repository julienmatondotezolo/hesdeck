import 'package:flutter/material.dart';
import 'package:my_mobile_deck/models/connection.dart';
import 'package:my_mobile_deck/providers/connection_provider.dart';
import 'package:my_mobile_deck/screens/settings/connection_settings_screen.dart';
import 'package:my_mobile_deck/services/api_services.dart';
import 'package:my_mobile_deck/themes/colors.dart';
import 'package:my_mobile_deck/utils/helpers.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late List<Connection> _connections;
  List<dynamic> allConnectionsData = []; // Initialize data as an empty list

  @override
  void initState() {
    super.initState();
    fetchConnections();
  }

  // Function to fetch data from the API
  Future<void> fetchConnections() async {
    try {
      List<dynamic> data =
          await ApiServices.fetchConnections('connections.json');
      setState(() {
        allConnectionsData = data; // Update the data list with the fetched data
      });
    } catch (error) {
      // Handle any errors that occur during the data fetching process
      throw Exception('Error fetching data: $error');
    }
  }

  void _showConnectionsModal(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
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
                  for (var connectionData in allConnectionsData)
                    GestureDetector(
                      onTap: () {
                        Helpers.vibration();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectionSettingsScreen(
                              connectionName: connectionData['name'],
                              fields: connectionData['fields'],
                            ),
                          ),
                        ).then((_) {
                          Navigator.pop(context);
                        });
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
                              connectionData['image'],
                              width: 24,
                            ),
                            const SizedBox(width: 16.0),
                            Text(
                              connectionData['name'],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
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
    return Consumer<ConnectionProvider>(
        builder: (context, connectionProvider, _) {
      final ConnectionProvider connectionProvider =
          Provider.of<ConnectionProvider>(context);

      _connections = connectionProvider.connections;

      // Get the screen height using MediaQuery
      final screenHeight = MediaQuery.of(context).size.height;

      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConnectionSettingsScreen(
                                connectionName: connection.type,
                                fields: Helpers.getConnectionField(
                                  allConnectionsData,
                                  connection.type,
                                ),
                              ),
                            ),
                          );
                        });
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
                              connection.image,
                              width: 24,
                            ),
                            const SizedBox(width: 16.0),
                            Text(
                              connection.type,
                              style: const TextStyle(
                                color: Colors.white,
                              ), // White text color
                            ),
                            const Spacer(),
                            connection.connected
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.green,
                                        width: 1.5,
                                      ), // Green border
                                      borderRadius: BorderRadius.circular(
                                          12.0), // Rounded corners
                                    ),
                                    child: const Text(
                                      'Connected',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.lightGrey,
                                        width: 1.5,
                                      ), // Green border
                                      borderRadius: BorderRadius.circular(
                                          12.0), // Rounded corners
                                    ),
                                    child: const Text(
                                      'Not connected',
                                      style: TextStyle(
                                        color: AppColors
                                            .lightGrey, // Green text color
                                        fontSize:
                                            12.0, // Adjust the font size as needed
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                        Text(
                          'Add Connection',
                          style: TextStyle(color: Colors.white),
                        ), // Text
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
                      style: TextStyle(color: Colors.white),
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
