import 'dart:convert';
import 'dart:io';
import '../models/device_info.dart';

class ESP32Service {
  static const String baseUrl = 'http://192.168.4.1';
  static const int timeoutSeconds = 3;

  /// Fetch device information from ESP32
  static Future<DeviceInfo?> fetchDeviceInfo() async {
    try {
      final client = HttpClient();
      client.connectionTimeout = Duration(seconds: timeoutSeconds);
      
      final request = await client.getUrl(Uri.parse('$baseUrl/info'));
      final response = await request.close().timeout(Duration(seconds: timeoutSeconds));
      
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final jsonData = json.decode(responseBody) as Map<String, dynamic>;
        
        final deviceInfo = DeviceInfo.fromJson(jsonData);
        print('Device Info fetched: $deviceInfo');
        return deviceInfo;
      } else {
        print('Failed to fetch device info. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching device info: $e');
      return null;
    }
  }

  /// Send intensity/strength data to ESP32
  static Future<bool> sendIntensity(int strength) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = Duration(seconds: timeoutSeconds);
      
      final request = await client.postUrl(Uri.parse('$baseUrl/strength'));
      request.headers.set('Content-Type', 'application/json');
      
      // Create JSON payload
      final jsonData = {'strength': strength};
      final jsonString = json.encode(jsonData);
      
      // Send the data
      request.write(jsonString);
      final response = await request.close().timeout(Duration(seconds: timeoutSeconds));
      
      if (response.statusCode == 200) {
        print('Intensity sent successfully: $strength');
        return true;
      } else {
        print('Failed to send intensity. Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending intensity: $e');
      return false;
    }
  }

  /// Test connection to ESP32
  static Future<bool> testConnection() async {
    try {
      final socket = await Socket.connect('192.168.4.1', 80, 
          timeout: Duration(seconds: 1));
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Send command to ESP32 (for future use)
  static Future<bool> sendCommand(String command) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = Duration(seconds: timeoutSeconds);
      
      final request = await client.getUrl(Uri.parse('$baseUrl/$command'));
      final response = await request.close().timeout(Duration(seconds: timeoutSeconds));
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error sending command: $e');
      return false;
    }
  }
} 