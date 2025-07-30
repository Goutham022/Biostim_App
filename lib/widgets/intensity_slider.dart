import 'package:flutter/material.dart';
import '../services/esp32_service.dart';

class IntensitySlider extends StatefulWidget {
  final int currentLevel;
  final int maxLevel;
  final Function(int) onLevelChanged;

  const IntensitySlider({
    super.key,
    required this.currentLevel,
    required this.maxLevel,
    required this.onLevelChanged,
  });

  @override
  State<IntensitySlider> createState() => _IntensitySliderState();
}

class _IntensitySliderState extends State<IntensitySlider> {
  late int currentLevel;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    currentLevel = widget.currentLevel;
  }

  void _decreaseLevel() async {
    if (currentLevel > 1 && !isSending) {
      setState(() {
        currentLevel--;
        isSending = true;
      });
      
      // Notify parent widget
      widget.onLevelChanged(currentLevel);
      
      // Send to ESP32
      await _sendIntensityToESP32(currentLevel);
      
      setState(() {
        isSending = false;
      });
    }
  }

  void _increaseLevel() async {
    if (currentLevel < widget.maxLevel && !isSending) {
      setState(() {
        currentLevel++;
        isSending = true;
      });
      
      // Notify parent widget
      widget.onLevelChanged(currentLevel);
      
      // Send to ESP32
      await _sendIntensityToESP32(currentLevel);
      
      setState(() {
        isSending = false;
      });
    }
  }

  Future<void> _sendIntensityToESP32(int intensity) async {
    try {
      final success = await ESP32Service.sendIntensity(intensity);
      if (success) {
        print('Intensity $intensity sent to ESP32 successfully');
      } else {
        print('Failed to send intensity $intensity to ESP32');
      }
    } catch (e) {
      print('Error sending intensity to ESP32: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress indicator
        Text(
          '$currentLevel/${widget.maxLevel}',
          style: const TextStyle(
            color: Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Intensity bars with controls
        Row(
          children: [
            // Decrease button
            GestureDetector(
              onTap: isSending ? null : _decreaseLevel,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSending ? Colors.grey : Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Intensity bars
            Expanded(
              child: Row(
                children: List.generate(widget.maxLevel, (index) {
                  final isActive = index < currentLevel;
                  return Expanded(
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.green[200],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Increase button
            GestureDetector(
              onTap: isSending ? null : _increaseLevel,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSending ? Colors.grey : Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        
        // Loading indicator (optional)
        if (isSending)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }
} 