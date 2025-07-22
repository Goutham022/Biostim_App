import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color avatarBg;
  final Color trailingBg;

  const FeatureCard({
    super.key,
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