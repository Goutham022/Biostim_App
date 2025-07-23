import 'package:flutter/material.dart';

class FESCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FESCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF6F1F9), // Light purple background
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: 80,
          child: Row(
            children: [
              // Avatar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFDDD2F1), // Darker purple
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

              // Title
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // Trailing Icons
              Container(
                width: 60,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFE9E2F0), // Light gray section
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.keyboard_arrow_up, size: 20, color: Colors.grey),
                    Icon(Icons.settings, size: 20, color: Colors.grey),
                    Icon(Icons.crop_square, size: 20, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 