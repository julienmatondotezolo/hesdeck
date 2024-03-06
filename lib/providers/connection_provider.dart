import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hessdeck/models/connection.dart';
import 'package:hessdeck/utils/helpers.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_elements_package/stream_elements.dart';

class ConnectionProvider extends ChangeNotifier {
  final List<Connection> _connections = [];

  late AppleMusicConnection _appleMusicConnectionObject = AppleMusicConnection(
    clientId: '**********',
    clientSecret: '************',
  );
  Map<String, dynamic>? _appleMusicClient;

  late OBSConnection _obsConnectionObject = OBSConnection(
    ipAddress: 'xxx.xxx.xxx.x',
    port: '4455',
    password: '*********',
  );
  ObsWebSocket? _obsWebSocket;

  late LightsConnection _lightsConnectionObject = LightsConnection(
    primaryServiceUuid: 'f000aa60-0451-4000-b000-000000000000',
    receiveCharUuid: 'f000aa63-0451-4000-b000-000000000000',
    sendCharUuid: 'f000aa61-0451-4000-b000-000000000000',
  );
  BluetoothDevice? _lightClient;
  BluetoothCharacteristic? _sendCharacteristic;

  late TwitchConnection _twitchConnectionObject = TwitchConnection(
    clientId: 'xxx.xxx.xxx.x',
    username: 'YOUR USERNAME',
    password: '*********',
  );
  Map<String, dynamic>? _twitchClient;

  late SpotifyConnection _spotifyConnectionObject = SpotifyConnection(
    clientId: '**********',
    clientSecret: '************',
  );
  Map<String, dynamic>? _spotifyClient;

  late StreamElementsConnection _streamElementsConnectionObject =
      StreamElementsConnection(
    jwtToken: '**********',
    accounId: '************',
  );
  StreamElements? _streamElementsClient;

  List<Connection> get connections => _connections;

  AppleMusicConnection get appleMusicConnectionObject =>
      _appleMusicConnectionObject;
  Map<String, dynamic>? get appleMusicClient => _appleMusicClient;

  OBSConnection get obsConnectionObject => _obsConnectionObject;
  ObsWebSocket? get obsWebSocket => _obsWebSocket;

  LightsConnection get lightsConnectionObject => _lightsConnectionObject;
  BluetoothDevice? get lightClient => _lightClient;
  BluetoothCharacteristic? get sendCharacteristic => _sendCharacteristic;

  TwitchConnection get twitchConnectionObject => _twitchConnectionObject;
  Map<String, dynamic>? get twitchClient => _twitchClient;

  SpotifyConnection get spotifyConnectionObject => _spotifyConnectionObject;
  Map<String, dynamic>? get spotifyClient => _spotifyClient;

  StreamElementsConnection get streamElementsConnectionObject =>
      _streamElementsConnectionObject;
  StreamElements? get streamElementsClient => _streamElementsClient;

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

  // Define the method to get initial field value
  String getFieldValue(String fieldName, String connectionType) {
    for (var connection in _connections) {
      // Check if the connection type matches the current connectionName
      if (connection.type == connectionType) {
        final Map<String, dynamic> connectionMap = connection.toJson();

        if (connectionMap.containsKey(fieldName)) {
          return connectionMap[fieldName];
        }
      }
    }
    return '';
  }

  // Get current connection Object using connectionType
  Connection? getCurrentConnection(String type) {
    final existingConnectionIndex = _connections.indexWhere(
      (existingConn) => existingConn.type == type,
    );

    if (existingConnectionIndex != -1) {
      return _connections[existingConnectionIndex];
    } else {
      debugPrint('[CONNECTION PROVIDER]: No connection found for type: $type');
      return null;
    }
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
      // print('Updating current ${connection.type} connection in list');
    } else {
      // Add the new connection to the list
      _connections.add(connection);
      // print('Adding new ${connection.type} connection to list');
    }

    notifyListeners();
  }

  // Remove a connection from a SharedPreferences
  Future<void> removeConnectionFromSP(Connection connection) async {
    if (checkIfConnectionExists(connection)) {
      final existingConnectionIndex = _connections.indexWhere(
        (existingConn) => existingConn.type == connection.type,
      );
      debugPrint(
          '${_connections[existingConnectionIndex].type} connection is deleted.');
      _connections.removeAt(existingConnectionIndex);
      await _saveConnectionSettings();
    } else {
      throw Exception('Impossible to delete ${connection.type} connection.');
    }
  }

  // Call the _removeAllConnections() method to remove all connections from SharedPreferences
  Future<void> _removeAllConnectionFromSP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('connections');
    await _saveConnectionSettings();
    notifyListeners();
    // print('Remove connection from SharedPreferences.');
  }

  // Load previously saved connection settings from SharedPreferences
  Future<void> _loadConnectionSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? connectionStrings = prefs.getStringList('connections');
    // print('SHARED PREFERENCES: $connectionStrings');

    if (connectionStrings != null && connectionStrings.isNotEmpty) {
      _connections.clear();
      for (final connString in connectionStrings) {
        // Convert JSON string to Connection object
        final Map<String, dynamic> connJson = jsonDecode(connString);

        if (connJson["type"] == 'Apple Music') {
          AppleMusicConnection appleMusicConnectionObject =
              AppleMusicConnection.fromJson(connJson);
          // If Apple Music is null put connected to false
          _appleMusicClient == null
              ? appleMusicConnectionObject =
                  appleMusicConnectionObject.copyWith(connected: false)
              : appleMusicConnectionObject;
          addConnection(spotifyConnectionObject);
          _appleMusicConnectionObject = appleMusicConnectionObject;
        } else if (connJson["type"] == 'OBS') {
          OBSConnection obsConnectionObject = OBSConnection.fromJson(connJson);
          // If OBS WebSocket is null put connected to false
          _obsWebSocket == null
              ? obsConnectionObject =
                  obsConnectionObject.copyWith(connected: false)
              : obsConnectionObject;
          addConnection(obsConnectionObject);
          _obsConnectionObject = obsConnectionObject;
        } else if (connJson["type"] == 'Lights') {
          LightsConnection lightsConnectionObject =
              LightsConnection.fromJson(connJson);
          // If OBS WebSocket is null put connected to false
          _lightClient == null
              ? lightsConnectionObject =
                  lightsConnectionObject.copyWith(connected: false)
              : lightsConnectionObject;
          addConnection(lightsConnectionObject);
          _lightsConnectionObject = lightsConnectionObject;
        } else if (connJson["type"] == 'Twitch') {
          TwitchConnection twitchConnectionObject =
              TwitchConnection.fromJson(connJson);
          // If Twitch is null put connected to false
          _twitchClient == null
              ? twitchConnectionObject =
                  twitchConnectionObject.copyWith(connected: false)
              : twitchConnectionObject;
          addConnection(twitchConnectionObject);
          _twitchConnectionObject = twitchConnectionObject;
        } else if (connJson["type"] == 'Spotify') {
          SpotifyConnection spotifyConnectionObject =
              SpotifyConnection.fromJson(connJson);
          // If Spotify is null put connected to false
          _spotifyClient == null
              ? spotifyConnectionObject =
                  spotifyConnectionObject.copyWith(connected: false)
              : spotifyConnectionObject;
          addConnection(spotifyConnectionObject);
          _spotifyConnectionObject = spotifyConnectionObject;
        } else if (connJson["type"] == 'StreamElements') {
          StreamElementsConnection streamElementsConnectionObject =
              StreamElementsConnection.fromJson(connJson);
          // If StreamElements is null put connected to false
          _streamElementsClient == null
              ? streamElementsConnectionObject =
                  streamElementsConnectionObject.copyWith(connected: false)
              : streamElementsConnectionObject;
          addConnection(streamElementsConnectionObject);
          _streamElementsConnectionObject = streamElementsConnectionObject;
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

    // print('connectionStrings: $connectionStrings');

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
          =====  APPLE MUSIC CONNECTION SETTINGS ======
  *** ================================================= */

  // Connect to Apple Music
  Future<void> connectToAppleMusic(
      AppleMusicConnection appleMusicConnectionObject) async {
    _spotifyClient = {"Connected": true};

    try {
      debugPrint('Connected to Apple Music client.');
      appleMusicConnectionObject =
          appleMusicConnectionObject.copyWith(connected: true);

      addConnection(appleMusicConnectionObject);
      _saveConnectionSettings();
    } catch (e) {
      throw Exception('Error connecting to Apple Music client: $e');
    }
  }

  // Disconnect from Apple Music WebSocket server
  Future<void> disconnectFromAppleMusic() async {
    if (_spotifyClient != null) {
      // Update the connected property of the existing connection object
      final existingConnectionIndex = _connections.indexWhere((existingConn) =>
          existingConn.type == _appleMusicConnectionObject.type);

      if (existingConnectionIndex != -1) {
        _connections[existingConnectionIndex] =
            _appleMusicConnectionObject.copyWith(connected: false);
        debugPrint('Disconnected from Apple Music WebSocket server.');
      } else {
        debugPrint('Apple Music connection not found in the list.');
      }

      _spotifyClient = null;
      notifyListeners();
    } else {
      throw Exception('You are not connected to Apple Music.');
    }
  }

  /* ===================================================
           ===== OBS CONNECTION SETTINGS ======
  *** ================================================= */

  // Connect to OBS WebSocket server
  Future<void> connectToOBS(OBSConnection obsConnectionObject) async {
    String ipAddress = Helpers.checkIfIPv6(obsConnectionObject.ipAddress);

    try {
      _obsWebSocket = await ObsWebSocket.connect(
        'ws://$ipAddress:${obsConnectionObject.port}',
        password: obsConnectionObject.password,
        fallbackEventHandler: (Event event) => debugPrint(
          '[OBS LISTENER]: type: ${event.eventType} data: ${event.eventData}',
        ),
      );

      if (_obsWebSocket != null) {
        debugPrint('Connected to OBS WebSocket server.');

        // StatsResponse stats = await _obsWebSocket!.general.getStats();
        obsConnectionObject = obsConnectionObject.copyWith(connected: true);

        addConnection(obsConnectionObject);
        _saveConnectionSettings();

        await _obsWebSocket?.listen(EventSubscription.all.code);
      }
    } catch (e) {
      throw Exception('Error connecting to OBS WebSocket server: $e');
    }
    notifyListeners();
  }

  // Disconnect from OBS WebSocket server
  Future<void> disconnectFromOBS() async {
    if (_obsWebSocket != null) {
      await _obsWebSocket!.close();

      // Update the connected property of the existing connection object
      final existingConnectionIndex = _connections.indexWhere(
          (existingConn) => existingConn.type == _obsConnectionObject.type);

      if (existingConnectionIndex != -1) {
        _connections[existingConnectionIndex] =
            _obsConnectionObject.copyWith(connected: false);
        debugPrint('Disconnected from OBS WebSocket server.');
      } else {
        debugPrint('OBS connection not found in the list.');
      }

      _obsWebSocket = null;
      notifyListeners();
    } else {
      throw Exception('You are not connected to OBS.');
    }
  }

  /* ===================================================
           ===== LIGHTS CONNECTION SETTINGS ======
  *** ================================================= */

  // Connect to LIGHTS
  Future<void> connectToLights(LightsConnection lightsConnectionObject) async {
    FlutterBlue flutterBlue = FlutterBlue.instance;

    BluetoothCharacteristic? receiveCharacteristic;
    String primaryServiceUuid = lightsConnectionObject.primaryServiceUuid;
    String receiveCharUuid = lightsConnectionObject.receiveCharUuid;
    String sendCharUuid = lightsConnectionObject.sendCharUuid;

    Future<void> discoverServices(BluetoothDevice device) async {
      print('Discover services...');
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          // Check if the characteristic's UUID matches the sendCharUuid
          if (characteristic.uuid.toString() == sendCharUuid) {
            // Save the sendCharacteristic
            _sendCharacteristic = characteristic;
            // Optionally, break the loop if you've found the characteristic you're looking for
            break;
          }
        }
      }
    }

    List<int> updateColor(int r, int g, int b) {
      // Command prefix [0xae, 0xa1] followed by RGB values and a checksum [0x56]
      List<int> data = [0xae, 0xa1, r, g, b, 0x56];

      return data;
    }

    Future<void> flickerLed() async {
      print('Flickering...');

      // Blue color command
      List<int> blueColorCommand = updateColor(0, 0, 255);
      // White color command
      List<int> whiteColorCommand = updateColor(255, 255, 255);

      for (int i = 0; i < 6; i++) {
        // Send blue color command
        await sendCharacteristic?.write(
          blueColorCommand,
        );
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Adjust delay as needed

        // Send white color command
        await sendCharacteristic?.write(
          whiteColorCommand,
        );
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Adjust delay as needed
      }

      print('Flickering done');
    }

    void connectToDevice(BluetoothDevice device) async {
      await device.connect();
      print('Connected to YONGNUO LED');
      await discoverServices(device);
      await flickerLed();

      debugPrint('Connected to Lights.');
      lightsConnectionObject = lightsConnectionObject.copyWith(connected: true);
      addConnection(lightsConnectionObject);
      _saveConnectionSettings();
    }

    try {
      flutterBlue.startScan(timeout: const Duration(seconds: 4));

      // Listening to scan results
      var subscription = flutterBlue.scanResults.listen((results) {
        for (ScanResult result in results) {
          print('Scanning....');
          print(result.device.name);
          if (result.device.name == 'YONGNUO LED') {
            print('Connecting....');
            // Adjust this to match your device
            _lightClient = result.device;

            print('_lightClient: $_lightClient');

            if (_lightClient == null) return;
            flutterBlue.stopScan();
            connectToDevice(_lightClient!);
            break;
          }
        }
      });

      Future.delayed(const Duration(seconds: 4)).then((_) {
        subscription.cancel();
        flutterBlue.stopScan();
      });
    } catch (e) {
      throw Exception('Error connecting to LIGHTS: $e');
    }

    notifyListeners();
  }

  // Disconnect from LIGHTS
  Future<void> disconnectFromLights() async {
    if (_lightClient != null) {
      _lightClient = await _lightClient!.disconnect();

      // Update the connected property of the existing connection object
      final existingConnectionIndex = _connections.indexWhere((existingConn) =>
          existingConn.type == _streamElementsConnectionObject.type);

      if (existingConnectionIndex != -1) {
        _connections[existingConnectionIndex] =
            _streamElementsConnectionObject.copyWith(connected: false);
        debugPrint('Disconnected from Lights.');
      } else {
        debugPrint('Lights connection not found in the list.');
      }

      notifyListeners();
    } else {
      throw Exception('You are not connected to Lights.');
    }
  }

  /* ===================================================
      =====  STREAMELEMENTS CONNECTION SETTINGS ======
  *** ================================================= */

  // Connect to StreamElements
  Future<void> connectToStreamElements(
      StreamElementsConnection streamElementsConnectionObject) async {
    _streamElementsClient = await StreamElements.connect(
      streamElementsConnectionObject.jwtToken,
      streamElementsConnectionObject.accounId,
    );
    try {
      if (_streamElementsClient != null) {
        debugPrint('Connected to StreamElements server.');

        streamElementsConnectionObject =
            streamElementsConnectionObject.copyWith(connected: true);

        addConnection(streamElementsConnectionObject);
        _saveConnectionSettings();
      }
    } catch (e) {
      throw Exception('Error connecting to StreamElements client: $e');
    }
    notifyListeners();
  }

  // Disconnect from OBS StreamElements
  Future<void> disconnectFromStreamElements() async {
    if (_streamElementsClient != null) {
      _streamElementsClient = _streamElementsClient!.disconnect();

      // Update the connected property of the existing connection object
      final existingConnectionIndex = _connections.indexWhere((existingConn) =>
          existingConn.type == _streamElementsConnectionObject.type);

      if (existingConnectionIndex != -1) {
        _connections[existingConnectionIndex] =
            _streamElementsConnectionObject.copyWith(connected: false);
        debugPrint('Disconnected from StreamElements.');
      } else {
        debugPrint('StreamElements connection not found in the list.');
      }

      notifyListeners();
    } else {
      throw Exception('You are not connected to StreamElements.');
    }
  }

  /* ===================================================
          ===== TWITCH CONNECTION SETTINGS ======
  *** ================================================= */

  // Connect to Twitch
  Future<void> connectToTwitch(TwitchConnection twitchConnectionObject) async {
    _twitchClient = {"Connected": true};

    try {
      debugPrint('Connected to Twitch client.');
      twitchConnectionObject = twitchConnectionObject.copyWith(connected: true);

      addConnection(twitchConnectionObject);
      _saveConnectionSettings();
    } catch (e) {
      throw Exception('Error connecting to Twitch client: $e');
    }
  }

  // Disconnect from OBS WebSocket server
  Future<void> disconnectFromTwitch() async {
    if (_twitchClient != null) {
      // Update the connected property of the existing connection object
      final existingConnectionIndex = _connections.indexWhere(
          (existingConn) => existingConn.type == _twitchConnectionObject.type);

      if (existingConnectionIndex != -1) {
        _connections[existingConnectionIndex] =
            _twitchConnectionObject.copyWith(connected: false);
        debugPrint('Disconnected from Twitch WebSocket server.');
      } else {
        debugPrint('Twitch connection not found in the list.');
      }

      _twitchClient = null;
      notifyListeners();
    } else {
      throw Exception('You are not connected to Twitch.');
    }
  }

  /* ===================================================
          =====  SPOTIFY CONNECTION SETTINGS ======
  *** ================================================= */

  // Connect to Spotify
  Future<void> connectToSpotify(
      SpotifyConnection spotifyConnectionObject) async {
    _spotifyClient = {"Connected": true};

    try {
      debugPrint('Connected to Spotify client.');
      spotifyConnectionObject =
          spotifyConnectionObject.copyWith(connected: true);

      addConnection(spotifyConnectionObject);
      _saveConnectionSettings();
    } catch (e) {
      throw Exception('Error connecting to Spotify client: $e');
    }
  }

  // Disconnect from OBS WebSocket server
  Future<void> disconnectFromSpotify() async {
    if (_spotifyClient != null) {
      // Update the connected property of the existing connection object
      final existingConnectionIndex = _connections.indexWhere(
          (existingConn) => existingConn.type == _spotifyConnectionObject.type);

      if (existingConnectionIndex != -1) {
        _connections[existingConnectionIndex] =
            _spotifyConnectionObject.copyWith(connected: false);
        debugPrint('Disconnected from Spotify WebSocket server.');
      } else {
        debugPrint('Spotify connection not found in the list.');
      }

      _spotifyClient = null;
      notifyListeners();
    } else {
      throw Exception('You are not connected to Spotify.');
    }
  }
}

// Convenience method to access the connectionProvider instance
ConnectionProvider connectionProvider(BuildContext context) {
  return Provider.of<ConnectionProvider>(context, listen: false);
}
