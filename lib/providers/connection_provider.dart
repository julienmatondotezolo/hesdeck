import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionProvider extends ChangeNotifier {
  final List<Connection> _connections = [];
  late OBSConnection _obsConnectionObject = OBSConnection(
    ipAddress: 'xxx.xxx.xxx.x',
    port: '4455',
    password: '*********',
  );
  // ObsWebSocket? _obsWebSocket;
  Map<String, dynamic>? _obsWebSocket;
  StreamController<dynamic>? _obsEventStreamController;

  late TwitchConnection _twitchConnectionObject = TwitchConnection(
    clientId: 'xxx.xxx.xxx.x',
    port: '4455',
    password: '*********',
  );
  Map<String, dynamic>? _twitchClient;

  List<Connection> get connections => _connections;
  OBSConnection get obsConnectionObject => _obsConnectionObject;
  // ObsWebSocket? get obsWebSocket => _obsWebSocket;
  Map<String, dynamic>? get obsWebSocket => _obsWebSocket;
  Stream<dynamic>? get obsEventStream => _obsEventStreamController?.stream;

  TwitchConnection get twitchConnectionObject => _twitchConnectionObject;
  Map<String, dynamic>? get twitchClient => _twitchClient;

  ConnectionProvider() {
    // _removeAllConnectionFromSP();
    _loadConnectionSettings();
  }

  bool checkIfConnectionExists(Connection connection) {
    // Check if a connection of the same type already exists
    final existingConnectionIndex = _connections.indexWhere(
      (existingConn) => existingConn.type == connection.type,
    );

    if (existingConnectionIndex != -1) {
      return true;
    }

    return false;
  }

  // Add a connection to LIST
  void addConnection(Connection connection) {
    // Check if a connection of the same type already exists
    final existingConnectionIndex = _connections.indexWhere(
      (existingConn) => existingConn.type == connection.type,
    );

    if (existingConnectionIndex != -1) {
      // Replace the existing connection with the new connection
      _connections[existingConnectionIndex] = connection;
      print('Updating current connection to list');
    } else {
      // Add the new connection to the list
      _connections.add(connection);
      print('Adding new ${connection.type} connection to list');
    }

    notifyListeners();
  }

  // Remove a connection from a SharedPreferences
  Future<void> removeConnectionFromSP(Connection connection) async {
    if (checkIfConnectionExists(connection)) {
      final existingConnectionIndex = _connections.indexWhere(
        (existingConn) => existingConn.type == connection.type,
      );

      print('Connection: $_connections');
      print(
          'Connection[$existingConnectionIndex]: ${_connections[existingConnectionIndex]}');
    } else {
      print('Impossible to delete ${connection.type} connection.');
      throw Exception('Impossible to delete ${connection.type} connection.');
    }
  }

  // Call the _removeAllConnections() method to remove all connections from SharedPreferences
  Future<void> _removeAllConnectionFromSP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('connections');
    notifyListeners();
    print('Remove connection from SharedPreferences.');
  }

  // Load previously saved connection settings from SharedPreferences
  Future<void> _loadConnectionSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? connectionStrings = prefs.getStringList('connections');
    print('SHARED PREFERENCES: $connectionStrings');

    if (connectionStrings != null) {
      _connections.clear();
      for (final connString in connectionStrings) {
        // Convert JSON string to Connection object
        final Map<String, dynamic> connJson = jsonDecode(connString);

        if (connJson["type"] == 'OBS') {
          final obsConnectionObject = OBSConnection.fromJson(connJson);
          connectToOBS(obsConnectionObject);
          // addConnection(obsConnectionObject);
          _obsConnectionObject = obsConnectionObject;
        } else if (connJson["type"] == 'Twitch') {
          final twitchConnectionObject = TwitchConnection.fromJson(connJson);
          addConnection(twitchConnectionObject);
          _twitchConnectionObject = twitchConnectionObject;
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

  /* ===================================================
           ===== OBS CONNECTION SETTINGS ======
  *** ================================================= */

  // Connect to OBS WebSocket server
  Future<void> connectToOBS(OBSConnection obsConnectionObject) async {
    // _obsWebSocket = await ObsWebSocket.connect(
    //   'ws://${obsConnectionObject.ipAddress}:${obsConnectionObject.port}',
    //   password: obsConnectionObject.password,
    //   fallbackEventHandler: (Event event) =>
    //       print('type: ${event.eventType} data: ${event.eventData}'),
    // );

    _obsWebSocket = {"Connected": true};

    try {
      if (_obsWebSocket != null) {
        print('Connected to OBS WebSocket server.');
        // StatsResponse stats = await _obsWebSocket!.general.getStats();
        obsConnectionObject = obsConnectionObject.copyWith(connected: true);

        addConnection(obsConnectionObject);
        _saveConnectionSettings();
      }
    } catch (e) {
      print('Error connecting to OBS WebSocket server: $e');
      throw Exception('Error connecting to OBS WebSocket server.');
    }
    notifyListeners();
  }

  // Disconnect from OBS WebSocket server
  Future<void> disconnectFromOBS() async {
    if (_obsWebSocket != null) {
      // await _obsWebSocket!.close();

      // Update the connected property of the existing connection object
      final existingConnectionIndex = _connections.indexWhere(
          (existingConn) => existingConn.type == _obsConnectionObject.type);

      if (existingConnectionIndex != -1) {
        _connections[existingConnectionIndex] =
            _obsConnectionObject.copyWith(connected: false);
        print('Disconnected from OBS WebSocket server.');
      } else {
        print('Connection not found in the list.');
      }

      _obsWebSocket = null;
      notifyListeners();
    } else {
      throw Exception('You are not connected to OBS.');
    }
  }

  // LISTEN TO OBS WEBSOCKET
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

  // Send a request to OBS WebSocket server
  Future<dynamic> sendRequest(
      String command, Map<String, dynamic> request) async {
    if (_obsWebSocket == null) {
      throw Exception('Not connected to OBS WebSocket server.');
    }

    try {
      // return await _obsWebSocket!.send(command, request);
    } catch (e) {
      print('Error sending request to OBS WebSocket server: $e');
      throw Exception('Error sending request to OBS WebSocket server.');
    }
  }

  /* ===================================================
          ===== TWITCH CONNECTION SETTINGS ======
  *** ================================================= */

  // Connect to Twitch
  Future<void> connectToTwitch(TwitchConnection twitchConnectionObject) async {
    _twitchClient = {"Connected": true};

    try {
      print('Connected to Twitch client.');
      twitchConnectionObject = twitchConnectionObject.copyWith(connected: true);

      addConnection(twitchConnectionObject);
      _saveConnectionSettings();
    } catch (e) {
      print('Error connecting to Twitch client: $e');
      throw Exception('Error connecting to Twitch client.');
    }
  }

  // Disconnect from OBS WebSocket server
  Future<void> disconnectFromTwitch() async {
    if (_twitchClient != null) {
      _twitchClient = null;
      _twitchConnectionObject =
          _twitchConnectionObject.copyWith(connected: false);
      print('Disconnected from Twitch client.');
    }
    notifyListeners();
  }
}
