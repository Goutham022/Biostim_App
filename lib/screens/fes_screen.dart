import 'package:flutter/material.dart';
import '../widgets/fes_card.dart';
import 'foot_drop_screen.dart';

class FESScreen extends StatelessWidget {
  const FESScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'FES',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Foot Drop Card
            FESCard(
              title: 'Foot Drop',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FootDropScreen(),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Wrist Drop Card
            FESCard(
              title: 'Wrist Drop',
              onTap: () {
                // TODO: Navigate to Wrist Drop screen when implemented
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Wrist Drop screen coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 