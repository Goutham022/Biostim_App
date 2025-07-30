import 'package:flutter/material.dart';
import '../widgets/intensity_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';

class FootDropScreen extends StatefulWidget {
  const FootDropScreen({super.key});

  @override
  State<FootDropScreen> createState() => _FootDropScreenState();
}

class _FootDropScreenState extends State<FootDropScreen> {
  int currentIntensity = 7;
  bool isPlaying = false;
  final TextEditingController triggerAngleController = TextEditingController(text: '15');
  
  // Dropdown values
  int selectedStimulationDuration = 5; // Default value
  int selectedPulseWidth = 30; // Default value
  
  // Dropdown options
  final List<int> stimulationDurationOptions = List.generate(10, (index) => index + 1); // 1 to 10
  final List<int> pulseWidthOptions = [10, 20, 30, 40, 50]; // Only tens

  // Angle simulation variables
  int currentAngle = 90;
  Timer? _angleTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startAngleSimulation();
  }

  @override
  void dispose() {
    triggerAngleController.dispose();
    _angleTimer?.cancel();
    super.dispose();
  }

  void _startAngleSimulation() {
    _angleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Simulate angle changes between 0 and 180 degrees
          currentAngle = _random.nextInt(181); // 0 to 180
        });
      }
    });
  }

  String _getImageForAngle(int angle) {
    if (angle <= 70) {
      return 'assets/images/img2.png';
    } else if (angle > 70 && angle <= 110) {
      return 'assets/images/img1.png';
    } else {
      return 'assets/images/img3.png';
    }
  }

  void _onIntensityChanged(int level) {
    setState(() {
      currentIntensity = level;
    });
    // TODO: Send intensity level to ESP32
    print('Intensity changed to: $level');
  }

  void _togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
    });
    // TODO: Send play/stop command to ESP32
    print('Play/Stop: ${isPlaying ? "Playing" : "Stopped"}');
  }

  void _setParameters() {
    // TODO: Send parameters to ESP32
    print('Setting parameters...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Parameters set successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _updateAdvancedSettings() async {
    final url = Uri.parse('http://192.168.4.1/updateAdvance');
    final payload = {
      'triggerAngle': int.tryParse(triggerAngleController.text) ?? 0,
      'stimulationDuration': selectedStimulationDuration,
      'pulseWidth': selectedPulseWidth,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print('Advanced settings sent successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Advanced settings updated!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Failed to send advanced settings. Status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update settings'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error sending advanced settings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection error'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

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
          'Foot Drop',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Angle Display Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  // Current Angle Text
                  Text(
                    'Angle: ${currentAngle}°',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Dynamic Image
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        _getImageForAngle(currentAngle),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback if image doesn't exist
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image not found',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Angle Range Info
                  Text(
                    _getAngleRangeText(currentAngle),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Intensity Slider
            IntensitySlider(
              currentLevel: currentIntensity,
              maxLevel: 20,
              onLevelChanged: _onIntensityChanged,
            ),
            
            const SizedBox(height: 30),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Play/Stop Button
                ElevatedButton(
                  onPressed: _togglePlay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Icon(
                    isPlaying ? Icons.stop : Icons.play_arrow,
                    size: 30,
                  ),
                ),
                
                // Set Button
                ElevatedButton(
                  onPressed: _setParameters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Set',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Advanced Settings Section
            const Text(
              'Advanced Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Trigger Angle Input
            Row(
              children: [
                const Text(
                  'Trigger Angle:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: triggerAngleController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.pink[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Stimulation Duration Dropdown
            Row(
              children: [
                const Text(
                  'Stimulation Duration:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedStimulationDuration,
                        isExpanded: true,
                        items: stimulationDurationOptions.map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedStimulationDuration = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Pulse Width Dropdown
            Row(
              children: [
                const Text(
                  'Pulse Width:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedPulseWidth,
                        isExpanded: true,
                        items: pulseWidthOptions.map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedPulseWidth = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Update Button
            Center(
              child: ElevatedButton(
                onPressed: _updateAdvancedSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAngleRangeText(int angle) {
    if (angle <= 70) {
      return 'Low Angle Range (≤ 70°)';
    } else if (angle > 70 && angle <= 110) {
      return 'Medium Angle Range (71° - 110°)';
    } else {
      return 'High Angle Range (> 110°)';
    }
  }
} 