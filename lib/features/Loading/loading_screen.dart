import 'package:flutter/material.dart';
import '../controllers/prayer_preload_controller.dart';
import 'home_page.dart'; // Make sure to import your HomePage

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _preload();
  }

  Future<void> _preload() async {
    try {
      // Preload and update Hive cache for all mosques
      await PrayerPreloadController.preload(
        mosques: const [
          'Makkah',
          'Madinah',
        ],
      );
      print('Preload finished, Hive cache updated.');
    } catch (e) {
      print('Preload failed: $e');
      // App continues even if preload fails
    }

    if (!mounted) return;

    // Navigate to HomePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          mosque: 'mecca', // default mosque
          primaryColor: const Color(0xFF0C6B43),
          onMosqueChanged: (mosque) {
            // Handle mosque change if needed
            print('Mosque changed to $mosque');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),

          // Foreground content
          SafeArea(
            child: Column(
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 350,
                    height: 350,
                  ),
                ),

                // Progress bar + loading text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Column(
                    children: [
                      // Indeterminate progress (during preload)
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: const LinearProgressIndicator(
                            backgroundColor: Color(0xFF0C6B43),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Loading',
                        style: TextStyle(
                          color: Color(0xFF0C6B43),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
