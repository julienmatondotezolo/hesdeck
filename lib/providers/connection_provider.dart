import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionProvider extends ChangeNotifier {
  ObsWebSocket? _obsWebSocket;
  StreamController<dynamic>? _obsEventStreamController;
  final List<Connection> _connections = [];
  late OBSConnection _obsConnectionObject = OBSConnection(
    ipAddress: 'test',
    port: '4455',
    password: 'test',
  );

  ObsWebSocket? get obsWebSocket => _obsWebSocket;
  Stream<dynamic>? get obsEventStream => _obsEventStreamController?.stream;
  List<Connection> get connections => _connections;
  OBSConnection get obsConnectionObject => _obsConnectionObject;

  ConnectionProvider() {
    // _removeConnections();
    _loadConnectionSettings();
  }

  void startWebSocketListener() async {
    if (_obsWebSocket != null) {
      _obsEventStreamController ??= StreamController<dynamic>.broadcast();

      // Run a loop to periodically check for new events
      Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (_obsWebSocket != null) {
          final event = _obsWebSocket!;
          _obsEventStreamController?.add(event);
          print('STREAM: $obsEventStream');
        }
      });
    }
  }

  void addConnection(Connection connection) {
    // Check if a connection of the same type already exists
    final existingConnectionIndex = _connections.indexWhere(
      (existingConn) => existingConn.type == connection.type,
    );

    if (existingConnectionIndex != -1) {
      // Replace the existing connection with the new connection
      _connections[existingConnectionIndex] = connection;
      print("Updating current connection to list");
    } else {
      // Add the new connection to the list
      _connections.add(connection);
      print("Adding new connection to list");
    }

    notifyListeners();
  }

  // Call the clearDecks() method to remove all decks from SharedPreferences
  Future<void> _removeConnections() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('connections');
    notifyListeners();
    print('Remove connection from SharedPreferences.');
  }

  // Load previously saved connection settings from SharedPreferences
  Future<void> _loadConnectionSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? connectionStrings = prefs.getStringList('connections');

    if (connectionStrings != null) {
      _connections.clear();
      for (final connString in connectionStrings) {
        // Convert JSON string to Connection object
        final Map<String, dynamic> connJson = jsonDecode(connString);

        if (connJson["type"] == 'OBS') {
          final connectionOBS = OBSConnection.fromJson(connJson);
          addConnection(connectionOBS);
          _obsConnectionObject = connectionOBS;
        }
      }
    }

    notifyListeners();
  }

  // Save connection settings to SharedPreferences
  Future<void> _saveConnectionSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> connectionStrings = _connections.map((conn) {
      // Convert each Connection object to JSON string
      return jsonEncode(conn);
    }).toList();

    prefs.setStringList('connections', connectionStrings);
    notifyListeners();
  }

  // Update connection settings
  // Future<void> updateConnectionSettings(
  //     String ipAddress, String port, String password) async {
  //   _ipAddress = ipAddress;
  //   _port = port;
  //   _password = password;
  //   await _saveConnectionSettings();
  //   notifyListeners();
  // }

  // Connect to OBS WebSocket server
  Future<void> connectToOBS(OBSConnection obsConnectionObject) async {
    _obsWebSocket = await ObsWebSocket.connect(
      'ws://${obsConnectionObject.ipAddress}:${obsConnectionObject.port}',
      password: obsConnectionObject.password,
      fallbackEventHandler: (Event event) =>
          print('type: ${event.eventType} data: ${event.eventData}'),
    );

    try {
      StatsResponse stats = await _obsWebSocket!.general.getStats();
      print('Connected to OBS WebSocket server.');
      print(stats);
      addConnection(obsConnectionObject);
      _saveConnectionSettings();
    } catch (e) {
      print('Error connecting to OBS WebSocket server: $e');
      throw Exception('Error connecting to OBS WebSocket server.');
    }
    notifyListeners();
  }

  // Disconnect from OBS WebSocket server
  Future<void> disconnectFromOBS() async {
    if (_obsWebSocket != null) {
      await _obsWebSocket!.close();
      _obsWebSocket = null;
      print('Disconnected from OBS WebSocket server.');
    }
    notifyListeners();
  }

  // Send a request to OBS WebSocket server
  Future<dynamic> sendRequest(
      String command, Map<String, dynamic> request) async {
    if (_obsWebSocket == null) {
      throw Exception('Not connected to OBS WebSocket server.');
    }

    try {
      return await _obsWebSocket!.send(command, request);
    } catch (e) {
      print('Error sending request to OBS WebSocket server: $e');
      throw Exception('Error sending request to OBS WebSocket server.');
    }
  }
}
