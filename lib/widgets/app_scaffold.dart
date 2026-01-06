import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/home/home_page.dart';
import '../features/settings/settings_page.dart';
import '../features/web_page/fatiha_web_page.dart';
import '../features/web_page/web_page.dart';
import '../routes.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;
  String _mosque = 'mecca';

  Color get primaryColor {
    return _mosque == 'mecca'
        ? const Color(0xFFD4AF37) // ذهبي المسجد الحرام
        : const Color(0xFF0C6B43); // أخضر المسجد النبوي
  }

  @override
  Widget build(BuildContext context) {
    final isAr =
    Localizations.localeOf(context).languageCode.startsWith('ar');

    final pages = [
      /// الرئيسية
      HomePage(
        // key: ValueKey(_mosque),
        mosque: _mosque,
        primaryColor: primaryColor,
        onMosqueChanged: (value) {
          setState(() => _mosque = value);
        },
      ),

      /// الفاتحة
      // WebPage(
      //   title: isAr ? 'الفاتحة' : 'Al-Fatiha',
      //   url: 'https://fatiha.prh.gov.sa/home',
      //   primaryColor: primaryColor,
      // ),

      FatihaWebPage(
        primaryColor: primaryColor,
      ),

      /// مقرأة الحرمين
      WebPage(
        title: isAr ? 'مقرأة الحرمين' : 'Haram Recitations',
        url: 'https://maqraa.prh.gov.sa/${isAr ? 'ar' : 'en'}',
        primaryColor: primaryColor,
      ),

      /// رسالة الحرمين
      WebPage(
        title: isAr ? 'رسالة الحرمين' : 'Haram Message',
        url: 'https://risala.prh.gov.sa/${isAr ? 'ar' : 'en'}',
        primaryColor: primaryColor,
      ),

      /// الإعدادات
      SettingsPage(
        mosque: _mosque,
        primaryColor: primaryColor,
        onMosqueChanged: (value) {
          setState(() => _mosque = value);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: primaryColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.3), width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                index: 0,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: isAr ? 'الرئيسية' : 'Home',
                isAr: isAr,
                onTap: () async {
                  setState(() => _selectedIndex = 0);
                },
              ),
              _buildBottomNavItem(
                index: 1,
                icon: Icons.menu_book_outlined,
                selectedIcon: Icons.menu_book,
                label: isAr ? 'الفاتحة' : 'Alfatiha',
                isAr: isAr,
                onTap: () async {
                  if (Platform.isIOS) {
                    final uri = Uri.parse('https://fatiha.prh.gov.sa/home');
                    await launchUrl(
                      uri,
                      mode: LaunchMode.inAppBrowserView,
                    );
                    return;
                  }
                  setState(() => _selectedIndex = 1);
                },
              ),
              _buildBottomNavItem(
                index: 2,
                icon: Icons.library_music_outlined,
                selectedIcon: Icons.library_music,
                label: isAr ? 'مقرأة الحرمين' : 'Recitations',
                isAr: isAr,
                onTap: () async {
                  setState(() => _selectedIndex = 2);
                },
              ),
              _buildBottomNavItem(
                index: 3,
                icon: Icons.mail_outline,
                selectedIcon: Icons.mail,
                label: isAr ? 'رسالة الحرمين' : 'Message',
                isAr: isAr,
                onTap: () async {
                  setState(() => _selectedIndex = 3);
                },
              ),
              _buildBottomNavItem(
                index: 4,
                icon: Icons.settings_outlined,
                selectedIcon: Icons.settings,
                label: isAr ? 'الإعدادات' : 'Settings',
                isAr: isAr,
                onTap: () async {
                  setState(() => _selectedIndex = 4);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isAr,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedIndex == index;
    final brownColor = const Color(0xFF8B6F47);
    
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: isSelected
                ? Border(
                    top: BorderSide(color: brownColor, width: 4),
                  )
                : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? brownColor : Colors.white,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? brownColor : Colors.white,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
