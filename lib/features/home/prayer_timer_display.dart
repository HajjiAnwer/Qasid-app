import 'package:flutter/material.dart';

class PrayerTimerDisplay extends StatelessWidget {
  final bool isAr;
  final String prayerName;
  final String timerText;
  final Color primaryColor;
  final double lineWidth;
  final Color? strokeColor;
  final double progress;

  const PrayerTimerDisplay({
    super.key,
    required this.isAr,
    required this.prayerName,
    required this.timerText,
    required this.primaryColor,
    this.lineWidth = 10.0,
    this.strokeColor,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = strokeColor ?? primaryColor;
    
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          SizedBox(
            width: 220,
            height: 220,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: lineWidth,
              color: activeColor.withOpacity(0.1),
            ),
          ),
          // Progress Arc
          SizedBox(
            width: 220,
            height: 220,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: lineWidth,
              color: activeColor,
              strokeCap: StrokeCap.round,
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isAr ? 'الأذان التالي' : 'Next Prayer',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                prayerName,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                timerText,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
