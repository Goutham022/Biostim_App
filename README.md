# Biostep Companion App

A Flutter application for connecting and managing Biostep medical devices via ESP32 WiFi communication.

## Features

- **ESP32 WiFi Integration**: Connect to ESP32 SoftAP and communicate via HTTP
- **Real-time Connection Monitoring**: Automatic ping every 2 seconds to check device connectivity
- **Device Information Display**: Shows model number, serial number, and battery percentage
- **Onboarding Flow**: Step-by-step guide for device connection
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
│   └── onboarding_overlay.dart  # Onboarding popup
└── widgets/
    ├── feature_card.dart     # Feature card widget
    └── onboarding_card.dart  # Onboarding card widget
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

## ESP32 Setup

### Required ESP32 Code

Your ESP32 should be configured as a SoftAP with the following:

- **IP Address**: `192.168.4.1`
- **HTTP Server**: Running on port 80
- **Info Endpoint**: `GET /info` returning JSON

### Example ESP32 Info Handler

```c
esp_err_t info_get_handler(httpd_req_t *req) {
    char response[128];
    snprintf(response, sizeof(response),
             "{\"model\":\"%s\",\"serial\":\"%s\",\"battery\":%d}",
             model_number, serial_number, battery_percentage);
    httpd_resp_set_type(req, "application/json");
    httpd_resp_send(req, response, strlen(response));
    return ESP_OK;
}
```

## Usage

1. **Launch the app** - Shows device status and feature cards
2. **Press "Connect Device"** - Opens onboarding flow
3. **Follow the steps** - Hold button, wait for green light, enable WiFi
4. **Connect to ESP32 WiFi** - App automatically detects connection
5. **View device info** - Model, serial, and battery information displayed

## Dependencies

- `flutter`: ^3.8.1
- `provider`: ^6.0.0 - State management
- `app_settings`: ^5.0.9 - Open device settings

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@biostep.com or create an issue in this repository.
