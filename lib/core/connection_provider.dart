import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/device_info.dart';
import '../services/esp32_service.dart';

class ConnectionProvider extends ChangeNotifier {
  bool isConnected = false;
  bool isInitialized = false;
  bool showOnboarding = false;
  bool isFetchingDeviceInfo = false;
  Timer? _pingTimer;
  static const String esp32IP = '192.168.4.1';
  
  // Device information
  DeviceInfo? deviceInfo;
  
  // For debugging and monitoring
  String lastPingResult = 'Not started';
  DateTime? lastPingTime;

  ConnectionProvider() {
    _startPingTimer();
  }

  void _startPingTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!_disposed) {
        isInitialized = true;
        notifyListeners();
        _pingESP32();
        _pingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
          if (!_disposed) {
            _pingESP32();
          }
        });
      }
    });
  }

  // Manual ping method for testing
  Future<void> manualPing() async {
    await _pingESP32();
  }

  void showOnboardingOverlay() {
    showOnboarding = true;
    notifyListeners();
  }

  void hideOnboardingOverlay() {
    showOnboarding = false;
    notifyListeners();
  }

  // Fetch device information when connected
  Future<void> _fetchDeviceInfo() async {
    if (isFetchingDeviceInfo) return;
    
    isFetchingDeviceInfo = true;
    notifyListeners();
    
    try {
      final info = await ESP32Service.fetchDeviceInfo();
      if (info != null) {
        deviceInfo = info;
        print('Device info stored: $deviceInfo');
      }
    } catch (e) {
      print('Error fetching device info: $e');
    } finally {
      isFetchingDeviceInfo = false;
      notifyListeners();
    }
  }

  Future<void> _pingESP32() async {
    if (_disposed) return;
    
    bool connected = false;
    String result = 'Failed';
    
    try {
      // Try TCP connection to port 80 (HTTP)
      final socket = await Socket.connect(esp32IP, 80, timeout: const Duration(seconds: 1));
      socket.destroy();
      connected = true;
      result = 'Success - TCP connection established';
    } catch (e) {
      // If TCP fails, try alternative method
      try {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 1);
        final request = await client.getUrl(Uri.parse('http://$esp32IP'));
        final response = await request.close().timeout(const Duration(seconds: 1));
        
        if (response.statusCode == 200) {
          connected = true;
          result = 'Success - HTTP response ${response.statusCode}';
        } else {
          result = 'Failed - HTTP status ${response.statusCode}';
        }
        
        client.close();
      } catch (httpError) {
        result = 'Failed - HTTP error: ${httpError.toString()}';
      }
    }
    
    if (!_disposed) {
      bool wasConnected = isConnected;
      isConnected = connected;
      lastPingResult = result;
      lastPingTime = DateTime.now();
      
      // If just connected and don't have device info yet, fetch it
      if (connected && !wasConnected && deviceInfo == null) {
        print('Device connected! Fetching device info...');
        _fetchDeviceInfo();
      }
      
      // If disconnected, clear device info
      if (!connected && wasConnected) {
        deviceInfo = null;
        print('Device disconnected! Cleared device info.');
      }
      
      notifyListeners();
      
      // Debug print (remove in production)
      print('ESP32 Ping: $result at ${lastPingTime}');
    }
  }

  // Get connection status as string
  String get connectionStatus {
    if (!isInitialized) return 'Checking...';
    return isConnected ? 'Connected' : 'Not Connected';
  }

  // Get connection status color
  Color get connectionStatusColor {
    if (!isInitialized) return Colors.orange;
    return isConnected ? Colors.green : Colors.red;
  }

  // Get device info display text
  String get deviceInfoText {
    if (!isConnected) return '';
    if (isFetchingDeviceInfo) return 'Fetching device info...';
    if (deviceInfo == null) return 'Connected (No device info)';
    return 'Model: ${deviceInfo!.model}\nSerial: ${deviceInfo!.serial}';
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    _pingTimer?.cancel();
    super.dispose();
  }
} 