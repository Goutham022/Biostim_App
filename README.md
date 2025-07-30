# Biostep Companion App

A Flutter application for connecting and managing Biostep medical devices via ESP32 WiFi communication.

## Features

- **ESP32 WiFi Integration**: Connect to ESP32 SoftAP and communicate via HTTP
- **Real-time Connection Monitoring**: Automatic ping every 2 seconds to check device connectivity
- **Device Information Display**: Shows model number, serial number, and battery percentage
- **Onboarding Flow**: Step-by-step guide for device connection
- **WiFi Connection Screen**: Direct WiFi connection to Biostep+ network with automatic permission handling
- **State Management**: Uses Provider for robust state management
- **Cross-platform**: Works on Android and iOS

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # App configuration with providers
├── models/
│   └── device_info.dart      # Device information model
├── services/
│   └── esp32_service.dart    # ESP32 communication service
├── core/
│   └── connection_provider.dart  # Connection state management
├── screens/
│   ├── home_screen.dart      # Main home screen
│   ├── onboarding_overlay.dart  # Onboarding popup
│   ├── connect_wifi_screen.dart # WiFi connection screen
│   ├── fes_screen.dart       # FES features screen
│   ├── foot_drop_screen.dart # Foot drop FES screen
│   └── biofeedback_screen.dart # Biofeedback screen
└── widgets/
    ├── feature_card.dart     # Feature card widget
    ├── onboarding_card.dart  # Onboarding card widget
    ├── intensity_slider.dart # Intensity control widget
    └── live_chart_widget.dart # Real-time chart widget
```

## Setup

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- ESP32 development board

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/biostep-companion-app.git
   cd biostep-companion-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## WiFi Connection Screen

The app includes a dedicated WiFi connection screen (`ConnectWifiScreen`) that:

### Features
- **Automatic Permission Handling**: Requests location permission (required for WiFi scanning on Android)
- **Direct WiFi Connection**: Connects to SSID "Biostep+" with password "biostim@123"
- **Real-time Status**: Shows connection progress with visual indicators
- **ESP32 Testing**: Sends HTTP GET request to `http://192.168.4.1/data` after successful connection
- **Error Handling**: Handles permission denials, incorrect credentials, and network issues

### Connection Status States
- **Initial**: Ready to connect
- **Checking Permissions**: Requesting location permission
- **Connecting**: Attempting to connect to WiFi
- **Connected**: Successfully connected to Biostep+
- **Failed**: Connection failed (wrong credentials, network issues)
- **Permission Denied**: Location permission denied
- **WiFi Disabled**: WiFi is turned off

### Usage
1. Navigate to the home screen
2. Tap "Connect to WiFi" button
3. Grant location permission when prompted
4. The app will automatically attempt to connect to Biostep+
5. View connection status and ESP32 response

## ESP32 Setup

### Required ESP32 Code

Your ESP32 should be configured as a SoftAP with the following:

- **IP Address**: `192.168.4.1`
- **HTTP Server**: Running on port 80
- **WiFi SSID**: `Biostep+`
- **WiFi Password**: `biostim@123`

### Required Endpoints

The ESP32 should provide these HTTP endpoints:

1. **GET /info** - Returns device information
   ```json
   {
     "model": "Biostep-2024",
     "serial": "BS123456789",
     "battery": 85
   }
   ```

2. **POST /strength** - Receives intensity data
   ```json
   {
     "strength": 5
   }
   ```

3. **GET /count** - Returns current count
   ```json
   {
     "count": 42
   }
   ```

4. **POST /reset** - Resets count
   ```json
   {
     "reset": true
   }
   ```

5. **GET /data** - Returns general data (for WiFi connection test)
   ```json
   {
     "status": "connected",
     "data": "sample_data"
   }
   ```

## Building APK

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

### Split APKs (for smaller size)
```bash
flutter build apk --split-per-abi --release
```

The APK files will be located at:
- Debug: `build/app/outputs/flutter-apk/app-debug.apk`
- Release: `build/app/outputs/flutter-apk/app-release.apk`

## Android Permissions

The following permissions are required and are already configured in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

## Dependencies

The following key dependencies are used:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.6                    # HTTP requests
  provider: ^6.0.0                 # State management
  app_settings: ^5.0.9             # Open device settings
  fl_chart: ^0.68.0               # Charts and graphs
  wifi_iot: ^0.3.17               # WiFi operations
  permission_handler: ^11.0.0      # Runtime permissions
```

## Troubleshooting

### Common Issues

1. **Location Permission Denied**
   - The app requires location permission for WiFi scanning
   - Go to Settings > Apps > Biostep Companion > Permissions
   - Enable Location permission

2. **WiFi Connection Fails**
   - Ensure ESP32 is powered on and broadcasting "Biostep+" network
   - Check that the password is correct: "biostim@123"
   - Verify device is within range of ESP32

3. **ESP32 Not Responding**
   - Check ESP32 IP address is `192.168.4.1`
   - Verify HTTP server is running on port 80
   - Check ESP32 serial monitor for errors

4. **Build Errors**
   - Run `flutter clean` and `flutter pub get`
   - Ensure all dependencies are compatible
   - Check Android SDK and build tools versions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
