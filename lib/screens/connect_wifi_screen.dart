import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ConnectWifiScreen extends StatefulWidget {
  const ConnectWifiScreen({super.key});

  @override
  State<ConnectWifiScreen> createState() => _ConnectWifiScreenState();
}

class _ConnectWifiScreenState extends State<ConnectWifiScreen> {
  ConnectionStatus _connectionStatus = ConnectionStatus.initial;
  String _statusMessage = 'Ready to connect';
  bool _isConnecting = false;
  String? _lastResponse;

  static const String ssid = 'Biostep+';
  static const String password = 'biostim@123';
  static const String esp32Url = 'http://192.168.4.1/data';

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndConnect();
  }

  Future<void> _checkPermissionsAndConnect() async {
    setState(() {
      _connectionStatus = ConnectionStatus.checkingPermissions;
      _statusMessage = 'Checking permissions...';
    });

    // Request location permission (required for WiFi scanning on Android)
    PermissionStatus locationStatus = await Permission.location.request();
    
    if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
      setState(() {
        _connectionStatus = ConnectionStatus.permissionDenied;
        _statusMessage = 'Location permission is required to connect to WiFi';
      });
      return;
    }

    // Check if WiFi is enabled
    bool? isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
    if (isWifiEnabled != true) {
      setState(() {
        _connectionStatus = ConnectionStatus.wifiDisabled;
        _statusMessage = 'Please enable WiFi to continue';
      });
      return;
    }

    // Start connection process
    await _connectToWifi();
  }

  Future<void> _connectToWifi() async {
    setState(() {
      _isConnecting = true;
      _connectionStatus = ConnectionStatus.connecting;
      _statusMessage = 'Connecting to Biostep+...';
    });

    try {
      // Check if already connected to the target network
      String? currentSSID = await WiFiForIoTPlugin.getSSID();
      if (currentSSID == ssid) {
        setState(() {
          _connectionStatus = ConnectionStatus.connected;
          _statusMessage = 'Already connected to Biostep+';
        });
        await _testESP32Connection();
        return;
      }

      // Connect to the WiFi network
      bool connected = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: NetworkSecurity.WPA,
        joinOnce: true,
      );

      if (connected) {
        setState(() {
          _connectionStatus = ConnectionStatus.connected;
          _statusMessage = 'Successfully connected to Biostep+';
        });

        // Test ESP32 connection
        await _testESP32Connection();
      } else {
        setState(() {
          _connectionStatus = ConnectionStatus.failed;
          _statusMessage = 'Failed to connect. Please check credentials.';
        });
      }
    } catch (e) {
      setState(() {
        _connectionStatus = ConnectionStatus.failed;
        _statusMessage = 'Connection error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  Future<void> _testESP32Connection() async {
    setState(() {
      _statusMessage = 'Testing ESP32 connection...';
    });

    try {
      final response = await http.get(Uri.parse(esp32Url)).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        setState(() {
          _lastResponse = response.body;
          _statusMessage = 'ESP32 connection successful!\nResponse: ${response.body}';
        });
        print('ESP32 Response: ${response.body}');
      } else {
        setState(() {
          _statusMessage = 'ESP32 responded with status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'ESP32 connection failed: ${e.toString()}';
      });
      print('ESP32 Connection Error: $e');
    }
  }

  Future<void> _retryConnection() async {
    await _connectToWifi();
  }

  Future<void> _openSettings() async {
    await openAppSettings();
  }

  Color _getStatusColor() {
    switch (_connectionStatus) {
      case ConnectionStatus.initial:
      case ConnectionStatus.checkingPermissions:
        return Colors.blue;
      case ConnectionStatus.connecting:
        return Colors.orange;
      case ConnectionStatus.connected:
        return Colors.green;
      case ConnectionStatus.failed:
      case ConnectionStatus.permissionDenied:
      case ConnectionStatus.wifiDisabled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (_connectionStatus) {
      case ConnectionStatus.initial:
      case ConnectionStatus.checkingPermissions:
        return Icons.info;
      case ConnectionStatus.connecting:
        return Icons.wifi_find;
      case ConnectionStatus.connected:
        return Icons.wifi;
      case ConnectionStatus.failed:
        return Icons.error;
      case ConnectionStatus.permissionDenied:
        return Icons.block;
      case ConnectionStatus.wifiDisabled:
        return Icons.wifi_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Connect to Device',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getStatusIcon(),
                size: 60,
                color: _getStatusColor(),
              ),
            ),

            const SizedBox(height: 32),

            // Status Message
            Text(
              _statusMessage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: _getStatusColor(),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Connection Details
            if (_connectionStatus == ConnectionStatus.connected)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Connection Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'SSID: $ssid',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'IP: 192.168.4.1',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 32),

            // Action Buttons
            if (_connectionStatus == ConnectionStatus.failed ||
                _connectionStatus == ConnectionStatus.wifiDisabled)
              ElevatedButton(
                onPressed: _isConnecting ? null : _retryConnection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isConnecting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Retry Connection',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),

            if (_connectionStatus == ConnectionStatus.permissionDenied)
              ElevatedButton(
                onPressed: _openSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Open Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

            const SizedBox(height: 16),

            // Manual Connect Button
            if (_connectionStatus != ConnectionStatus.connected)
              TextButton(
                onPressed: _isConnecting ? null : _retryConnection,
                child: const Text(
                  'Manual Connect',
                  style: TextStyle(fontSize: 16),
                ),
              ),

            // Success Message
            if (_connectionStatus == ConnectionStatus.connected)
              Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Device ready for use!',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum ConnectionStatus {
  initial,
  checkingPermissions,
  connecting,
  connected,
  failed,
  permissionDenied,
  wifiDisabled,
} 