import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/connection_provider.dart';
import '../widgets/feature_card.dart';
import 'onboarding_overlay.dart';
import 'fes_screen.dart';
import 'biofeedback_screen.dart';
import 'connect_wifi_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color avatarBg = Color(0xFFDDD2F1);
  static const Color trailingBg = Color(0xFFE9E2F0);

  @override
  Widget build(BuildContext context) {
    final connection = Provider.of<ConnectionProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Device Status Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Device Status : ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            connection.connectionStatus,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: connection.connectionStatusColor,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 100,
                            child: Image.asset('assets/image.png', fit: BoxFit.contain),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 2),
                      
                      // Device Information or Connect Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: connection.isConnected
                            ? _buildDeviceInfoText(connection)
                            : _buildConnectButton(connection),
                      ),
                      
                      // WiFi Connection Button (always visible)
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConnectWifiScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.wifi, color: Colors.white),
                          label: const Text(
                            'Connect to WiFi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Feature Cards
                      FeatureCard(
                        title: 'Functional Electrical\nStimulation (FES)',
                        subtitle: 'Subhead',
                        avatarBg: avatarBg,
                        trailingBg: trailingBg,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FESScreen(),
                            ),
                          );
                        },
                      ),
                                                   const SizedBox(height: 16),
                             FeatureCard(
                               title: 'Biofeedback (for training)',
                               subtitle: 'Subhead',
                               avatarBg: avatarBg,
                               trailingBg: trailingBg,
                               onTap: () {
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                     builder: (context) => const BiofeedbackScreen(),
                                   ),
                                 );
                               },
                             ),
                      const SizedBox(height: 16),
                      const FeatureCard(
                        title: 'FES + Biofeedback',
                        subtitle: 'Subhead',
                        avatarBg: avatarBg,
                        trailingBg: trailingBg,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (connection.showOnboarding)
            const OnboardingOverlay(),
        ],
      ),
    );
  }

  Widget _buildConnectButton(ConnectionProvider connection) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () {
        connection.showOnboardingOverlay();
      },
      child: const Text('Connect Device'),
    );
  }

  Widget _buildDeviceInfoText(ConnectionProvider connection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (connection.isFetchingDeviceInfo)
          const Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              Text('Fetching device info...'),
            ],
          )
        else if (connection.deviceInfo != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Model No: ${connection.deviceInfo!.model}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Serial No: ${connection.deviceInfo!.serial}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Battery: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${connection.deviceInfo!.battery}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: connection.deviceInfo!.battery < 20 ? Colors.red : Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          )
        else
          const Text(
            'Connected (No device info)',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
} 