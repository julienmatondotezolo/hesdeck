// import 'package:flutter/material.dart';
// import 'package:hessdeck/models/connection.dart';
// import 'package:hessdeck/providers/connection_provider.dart';
// import 'package:hessdeck/themes/colors.dart';
// import 'package:hessdeck/services/connections/obs_connections.dart';
// import 'package:obs_websocket/obs_websocket.dart';
// import 'package:provider/provider.dart';

// class OBSSettingsScreen extends StatefulWidget {
//   const OBSSettingsScreen({Key? key}) : super(key: key);

//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<OBSSettingsScreen> {
//   final TextEditingController _ipAddressController = TextEditingController();
//   final TextEditingController _portController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   static String _connectionType = "";
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Load previously saved connection settings from SharedPreferences
//     _loadConnectionSettings();
//   }

//   // Load previously saved connection settings from ConnectionProvider
//   void _loadConnectionSettings() {
//     ConnectionProvider connectionProvider =
//         Provider.of<ConnectionProvider>(context);

//     setState(() {
//       _ipAddressController.text =
//           connectionProvider.obsConnectionObject.ipAddress;
//       _portController.text = connectionProvider.obsConnectionObject.port;
//       _passwordController.text =
//           connectionProvider.obsConnectionObject.password;
//       _connectionType = connectionProvider.obsConnectionObject.type;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Use Consumer to listen for changes in ConnectionProvider.obsConnectionObject
//     return Consumer<ConnectionProvider>(
//         builder: (context, connectionProvider, _) {
//       ObsWebSocket? obsWebSocket = connectionProvider.obsWebSocket;
//       Stream<dynamic>? obsEventStream = connectionProvider.obsEventStream;
//       OBSConnection obsConnectionObject =
//           connectionProvider.obsConnectionObject;

//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('OBS Settings'),
//         ),
//         body: SafeArea(
//           child: Container(
//             padding: const EdgeInsets.all(25.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextFormField(
//                     controller: _ipAddressController,
//                     keyboardType: TextInputType.text,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                       labelText: 'IP Address',
//                       labelStyle: TextStyle(color: Colors.white),
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: AppColors.darkGrey,
//                           width: 10.0,
//                         ),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the IP Address';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _portController,
//                     keyboardType: TextInputType.number,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                       labelText: 'Port',
//                       labelStyle: TextStyle(color: Colors.white),
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the Port';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                       labelText: 'Password',
//                       labelStyle: TextStyle(color: Colors.white),
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the Password';
//                       }
//                       return null;
//                     },
//                   ),
//                   const Spacer(),
//                   /*StreamBuilder<dynamic>(
//                     stream: obsEventStream,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         return FutureBuilder(
//                             future: (snapshot.data as ObsWebSocket)
//                                 .general
//                                 .getStats(),
//                             builder: (context, futureSnapshot) {
//                               if (futureSnapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return const Text(
//                                   'Fetching data...',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 );
//                               } else if (futureSnapshot.hasError) {
//                                 return const Text(
//                                   'CPU: Error fetching data',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 );
//                               } else {
//                                 // Process and display the data from the futureSnapshot
//                                 StatsResponse? stats = futureSnapshot.data;
//                                 return Text(
//                                   'CPU: ${stats!.cpuUsage}',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 );
//                               }
//                             });
//                       } else {
//                         return const Text(
//                           'Waiting for events...',
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         );
//                       }
//                     },
//                   ),*/
//                   const Spacer(),
//                   obsWebSocket != null
//                       ? ElevatedButton(
//                           onPressed: () async {
//                             await OBSConnections.disconnectOBS(
//                                 connectionProvider);
//                             // Navigator.pop(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red),
//                           child: const Text(
//                             'Disconnect',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         )
//                       : ElevatedButton(
//                           onPressed: () async {
//                             // await OBSConnections.connectToOBS(
//                             //   context,
//                             //   _formKey,
//                             //   _ipAddressController,
//                             //   _portController,
//                             //   _passwordController,
//                             // );
//                             // Navigator.pop(context);
//                           },
//                           child: const Text(
//                             'Connect',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                   const SizedBox(height: 16.0),
//                   _connectionType == "OBS"
//                       ? ElevatedButton(
//                           onPressed: () async {
//                             await OBSConnections.deleteOBSConnection(
//                               connectionProvider,
//                               obsConnectionObject,
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.red,
//                             backgroundColor:
//                                 Colors.transparent, // Set the text color to red
//                             side: const BorderSide(
//                               color: Colors.red,
//                               width: 3.0,
//                             ), // Set red border
//                           ),
//                           child: const Text(
//                             'Delete connection',
//                             style: TextStyle(
//                               color: Colors.red,
//                             ), // Set text color to red
//                           ),
//                         )
//                       : const Spacer(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
