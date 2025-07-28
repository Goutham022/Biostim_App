import 'package:flutter/material.dart';
import '../widgets/graph_widget.dart';
import '../services/esp32_service.dart';

class BiofeedbackScreen extends StatefulWidget {
  const BiofeedbackScreen({super.key});

  @override
  State<BiofeedbackScreen> createState() => _BiofeedbackScreenState();
}

class _BiofeedbackScreenState extends State<BiofeedbackScreen> {
  final TextEditingController triggerAngleController = TextEditingController();
  final TextEditingController setCountController = TextEditingController();
  int countFromESP32 = 0; // This will be updated from ESP32
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Start fetching count data from ESP32
    _startFetchingCount();
  }

  @override
  void dispose() {
    triggerAngleController.dispose();
    setCountController.dispose();
    super.dispose();
  }

  void _startFetchingCount() {
    // Fetch count data every 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _fetchCountFromESP32();
        _startFetchingCount(); // Continue fetching
      }
    });
  }

  Future<void> _fetchCountFromESP32() async {
    try {
      // TODO: Implement ESP32 service method to fetch count
      // For now, simulate data from ESP32
      final newCount = await ESP32Service.getCountFromESP32();
      if (mounted) {
        setState(() {
          countFromESP32 = newCount;
        });
      }
    } catch (e) {
      print('Error fetching count from ESP32: $e');
    }
  }

  void _resetCount() {
    setState(() {
      countFromESP32 = 0;
      triggerAngleController.text = '0';
      setCountController.text = '0';
      isLoading = true;
    });

    // Send reset command to ESP32
    ESP32Service.resetCount().then((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All values reset successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error resetting values: $error'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
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
          'Bio-FeedBack',
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
            
            // Input Fields Section
            // Trigger Angle
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
            
            // Set Count
            Row(
              children: [
                const Text(
                  'Set Count:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: setCountController,
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
            
            // Count (from ESP32)
            Row(
              children: [
                const Text(
                  'Count:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                         decoration: BoxDecoration(
                       color: Colors.pink[50],
                       border: Border.all(color: Colors.black),
                       borderRadius: BorderRadius.circular(8),
                     ),
                    child: Text(
                      '$countFromESP32',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Reset Button
            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : _resetCount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Reset',
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