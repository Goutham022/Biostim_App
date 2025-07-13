import 'package:flutter/material.dart';

/// Screen that displays the three lavender feature cards.
class CardsPage extends StatelessWidget {
  const CardsPage({
    super.key,
    required this.avatarBg,
    required this.trailingBg,
  });

  final Color avatarBg;
  final Color trailingBg;

  // lighter background behind the text area
  static const Color cardBg = Color(0xFFF6F1F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Features')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HorizontalCard(
              avatarBg: avatarBg,
              trailingBg: trailingBg,
              background: cardBg,
              title: 'Functional Electrical\nStimulation (FES)',
              subtitle: 'Subhead',
            ),
            const SizedBox(height: 20),
            _HorizontalCard(
              avatarBg: avatarBg,
              trailingBg: trailingBg,
              background: cardBg,
              outlineColor: const Color(0xFF7B56FF), // purple focus ring
              title: 'Biofeedback (for training)',
              subtitle: 'Subhead',
            ),
            const SizedBox(height: 20),
            _HorizontalCard(
              avatarBg: avatarBg,
              trailingBg: trailingBg,
              background: cardBg,
              title: 'FES + Biofeedback',
              subtitle: 'Subhead',
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable widget for a single horizontal card.
class _HorizontalCard extends StatelessWidget {
  const _HorizontalCard({
    required this.avatarBg,
    required this.trailingBg,
    required this.background,
    this.outlineColor,
    required this.title,
    required this.subtitle,
  });

  final Color avatarBg;
  final Color trailingBg;
  final Color background;
  final Color? outlineColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      shape: outlineColor == null
          ? null
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: outlineColor!, width: 2),
            ),
      clipBehavior: Clip.antiAlias,
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

            // Icons panel
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
                  Icon(Icons.change_history, size: 28),
                  Icon(Icons.settings, size: 28),
                  Icon(Icons.crop_square, size: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
