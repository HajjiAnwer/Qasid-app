import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class PrayerTimerDisplay extends StatelessWidget {
  final String prayerName;
  final String timerText;
  final Color primaryColor;
  final double lineWidth;
  final Color? strokeColor;
  final double progress;

  const PrayerTimerDisplay({
    super.key,
    required this.prayerName,
    required this.timerText,
    required this.primaryColor,
    this.lineWidth = 10.0,
    this.strokeColor,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final Color activeColor = strokeColor ?? primaryColor;
    
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: lineWidth,
              color: activeColor.withOpacity(0.1),
            ),
          ),
          // Progress Arc
          SizedBox(
            width: 180,
            height: 180,
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
                l10n.nextPrayer,
                style: const TextStyle(
                  color: Colors.black,
                    fontFamily: 'DINNextLTArabic',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                prayerName,
                style: TextStyle(
                  color: primaryColor,
                  fontFamily: 'DINNextLTArabic',
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                timerText,
                style: const TextStyle(
                  color: Colors.green,
                  fontFamily: 'DINNextLTArabic',
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
