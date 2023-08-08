import 'dart:async';

import 'package:flutter/material.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionProvider extends ChangeNotifier {
  String? _ipAddress;
  String? _port;
  String? _password;
  ObsWebSocket? _obsWebSocket;
  StreamController<dynamic>? _obsEventStreamController;

  String? get ipAddress => _ipAddress;
  String? get port => _port;
  String? get password => _password;
  ObsWebSocket? get obsWebSocket => _obsWebSocket;
  Stream<dynamic>? get obsEventStream => _obsEventStreamController?.stream;

  ConnectionProvider() {
    _loadSettings();
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

  // Load previously saved connection settings from SharedPreferences
  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _ipAddress = prefs.getString('obs_ip');
    _port = prefs.getString('obs_port');
    _password = prefs.getString('obs_password');
    notifyListeners();
  }

  // Save connection settings to SharedPreferences
  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('obs_ip', _ipAddress ?? '');
    prefs.setString('obs_port', _port ?? '');
    prefs.setString('obs_password', _password ?? '');
  }

  // Update connection settings
  Future<void> updateConnectionSettings(
      String ipAddress, String port, String password) async {
    _ipAddress = ipAddress;
    _port = port;
    _password = password;
    await _saveSettings();
    notifyListeners();
  }

  // Connect to OBS WebSocket server
  Future<void> connectToOBS() async {
    if (_ipAddress == null || _port == null || _password == null) {
      throw Exception(
          'IP address & password and port must be set before connecting.');
    }

    _obsWebSocket = await ObsWebSocket.connect(
      'ws://$_ipAddress:$_port',
      password: _password,
      fallbackEventHandler: (Event event) =>
          print('type: ${event.eventType} data: ${event.eventData}'),
    );

    try {
      StatsResponse stats = await _obsWebSocket!.general.getStats();
      print('Connected to OBS WebSocket server.');
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
