import 'package:flutter/material.dart';
import '../widgets/graph_widget.dart';
import '../widgets/intensity_slider.dart';

class FootDropScreen extends StatefulWidget {
  const FootDropScreen({super.key});

  @override
  State<FootDropScreen> createState() => _FootDropScreenState();
}

class _FootDropScreenState extends State<FootDropScreen> {
  int currentIntensity = 7;
  bool isPlaying = false;
  final TextEditingController triggerAngleController = TextEditingController(text: '15');
  final TextEditingController stimulationDurationController = TextEditingController(text: '200');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    triggerAngleController.dispose();
    stimulationDurationController.dispose();
    super.dispose();
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

  void _updateAdvancedSettings() {
    // TODO: Send advanced settings to ESP32
    print('Trigger Angle: ${triggerAngleController.text}');
    print('Stimulation Duration: ${stimulationDurationController.text}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Advanced settings updated!'),
        duration: Duration(seconds: 2),
      ),
    );
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
            // Graph Section
            const GraphWidget(),
            
            const SizedBox(height: 30),
            
            // Intensity Slider
            IntensitySlider(
              currentLevel: currentIntensity,
              maxLevel: 12,
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
            
            // Stimulation Duration Input
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
                  child: TextField(
                    controller: stimulationDurationController,
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
} 