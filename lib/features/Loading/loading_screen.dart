import 'package:flutter/material.dart';
import '../controllers/prayer_preload_controller.dart';
import '../../widgets/app_scaffold.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Animate progress from 0 to 1 over 3 seconds (adjust as needed)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
      setState(() {
        _progress = _controller.value;
      });
    });

    _controller.forward(); // start the animation
    _preloadAndNavigate();
  }

  Future<void> _preloadAndNavigate() async {
    try {
      // Preload Hive data (runs in background)
      await PrayerPreloadController.preload(
        mosques: const ['mecca', 'madinah'],
      );
    } catch (e) {
      print('Preload failed: $e');
    }

    // Wait until progress animation finishes
    await _controller.forward();

    if (!mounted) return;

    // Navigate to HomePage / AppScaffold
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AppScaffold()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 350,
                    height: 350,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Column(
                    children: [
                      // Determinate progress bar
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: _progress, // progress from 0 to 1
                            backgroundColor: const Color(0xFF0C6B43),
                            valueColor: const AlwaysStoppedAnimation<Color>(
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
