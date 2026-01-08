import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class TopNavBar extends StatelessWidget {
  final Color primaryColor;

  const TopNavBar({
    super.key,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.menu, color: Colors.white, size: 28),
            SizedBox(
              height: 60,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const Icon(Icons.notifications, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }
}
