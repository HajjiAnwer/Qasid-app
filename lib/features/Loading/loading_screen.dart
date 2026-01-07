import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

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
                      // Custom linear progress
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: 0.6, // change or remove for indeterminate
                            backgroundColor: Color(0xFF0C6B43),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Loading text
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
