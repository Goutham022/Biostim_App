import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biostep Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color avatarBg = Color(0xFFDDD2F1);
  static const Color trailingBg = Color(0xFFE9E2F0);
  static const Color cardBg = Color(0xFFF6F1F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // === Device Status & Image ===
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
                      const Text(
                        'Not Connected',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 100,
                        child: Image.asset('assets/image.png', fit: BoxFit.contain),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // === Connect Button ===
                  ElevatedButton(
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
                      AppSettings.openAppSettings(type: AppSettingsType.wifi);
                    },
                    child: const Text('Connect Device'),
                  ),

                  const SizedBox(height: 40),

                  // === Feature Cards ===
                  _FeatureCard(
                    title: 'Functional Electrical\nStimulation (FES)',
                    subtitle: 'Subhead',
                    avatarBg: avatarBg,
                    trailingBg: trailingBg,
                  ),
                  const SizedBox(height: 16),
                  _FeatureCard(
                    title: 'Biofeedback (for training)',
                    subtitle: 'Subhead',
                    avatarBg: avatarBg,
                    trailingBg: trailingBg,
                  ),
                  const SizedBox(height: 16),
                  _FeatureCard(
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
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Widget: Feature Card
// ──────────────────────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color avatarBg;
  final Color trailingBg;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.avatarBg,
    required this.trailingBg,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF6F1F9),
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 360,
        height: 104,
        child: Row(
          children: [
            // Avatar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: avatarBg,
                child: const Text(
                  'A',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            // Title & subtitle
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),

            // Trailing Icons
            Container(
              width: 82,
              height: double.infinity,
              decoration: BoxDecoration(
                color: trailingBg,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.change_history, size: 26),
                  Icon(Icons.settings, size: 26),
                  Icon(Icons.crop_square, size: 26),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
