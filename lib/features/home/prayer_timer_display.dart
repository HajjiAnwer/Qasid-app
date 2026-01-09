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

    return LayoutBuilder(
      builder: (context, constraints) {
        // 👇 dynamic size based on screen
        final double size = (constraints.maxWidth * 0.6)
            .clamp(160.0, 260.0); // min & max

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: lineWidth,
                  color: activeColor.withOpacity(0.1),
                ),
              ),

              // Progress arc
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: lineWidth,
                  color: activeColor,
                  strokeCap: StrokeCap.round,
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(size * 0.12),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.nextPrayer,
                        style: TextStyle(
                          fontSize: size * 0.10,
                          fontFamily: 'DINNextLTArabic',
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: size * 0.02),
                      Text(
                        prayerName,
                        style: TextStyle(
                          fontSize: size * 0.16,
                          fontFamily: 'DINNextLTArabic',
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: size * 0.02),
                      Text(
                        timerText,
                        style: TextStyle(
                          fontSize: size * 0.18,
                          fontFamily: 'DINNextLTArabic',
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
