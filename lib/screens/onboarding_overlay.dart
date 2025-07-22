import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/connection_provider.dart';
import '../widgets/onboarding_card.dart';
import 'package:app_settings/app_settings.dart';

class OnboardingOverlay extends StatefulWidget {
  const OnboardingOverlay({super.key});

  @override
  State<OnboardingOverlay> createState() => _OnboardingOverlayState();
}

class _OnboardingOverlayState extends State<OnboardingOverlay> {
  int currentCardIndex = 0;

  final List<Map<String, dynamic>> cards = [
    {
      'image': 'assets/image.png',
      'text': 'HOLD UP BUTTON FOR 2 SECONDS',
      'showSkip': true,
      'showBack': false,
      'showNext': true,
      'showConnect': false,
    },
    {
      'image': 'assets/image.png',
      'text': 'GREEN LIGHT WILL BLINK',
      'showSkip': false,
      'showBack': true,
      'showNext': true,
      'showConnect': false,
    },
    {
      'image': 'assets/image.png',
      'text': 'TURN ON WIFI TO CONNECT DEVICE',
      'showSkip': false,
      'showBack': true,
      'showNext': false,
      'showConnect': true,
    },
  ];

  void nextCard() {
    if (currentCardIndex < cards.length - 1) {
      setState(() {
        currentCardIndex++;
      });
    }
  }

  void previousCard() {
    if (currentCardIndex > 0) {
      setState(() {
        currentCardIndex--;
      });
    }
  }

  void skipToEnd() {
    setState(() {
      currentCardIndex = cards.length - 1;
    });
  }

  void connectDevice(BuildContext context) {
    // Open WiFi settings
    AppSettings.openAppSettings(type: AppSettingsType.wifi);
    // Close the onboarding overlay after opening settings
    Provider.of<ConnectionProvider>(context, listen: false).hideOnboardingOverlay();
  }

  void closeOnboarding(BuildContext context) {
    Provider.of<ConnectionProvider>(context, listen: false).hideOnboardingOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => closeOnboarding(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const Spacer(),
              OnboardingCardWidget(
                image: cards[currentCardIndex]['image'],
                text: cards[currentCardIndex]['text'],
                showSkip: cards[currentCardIndex]['showSkip'],
                showBack: cards[currentCardIndex]['showBack'],
                showNext: cards[currentCardIndex]['showNext'],
                showConnect: cards[currentCardIndex]['showConnect'],
                onNext: nextCard,
                onBack: previousCard,
                onSkip: skipToEnd,
                onConnect: () => connectDevice(context),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  cards.length,
                  (index) => Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentCardIndex
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
} 