import 'package:flutter/material.dart';
import '../features/home/home_page.dart';
import '../features/settings/settings_page.dart';
import '../features/web_page/web_page.dart';
import '../l10n/app_localizations.dart';
import '../features/Tools/customAppBar.dart';
import '../features/Tools/customDrawer.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  String _mosque = 'mecca';

  Color get primaryColor {
    return _mosque == 'mecca'
        ? const Color(0xFFD4AF37) // Gold
        : const Color(0xFF0C6B43); // Green
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final pages = [
      HomePage(
        mosque: _mosque,
        primaryColor: primaryColor,
        onMosqueChanged: (value) => setState(() => _mosque = value),
      ),
      WebPage(
        title: l10n.services,
        url: 'https://maqraa.prh.gov.sa/${Localizations.localeOf(context).languageCode}',
        primaryColor: primaryColor,
      ),
      WebPage(
        title: l10n.liveStream,
        url: 'https://risala.prh.gov.sa/${Localizations.localeOf(context).languageCode}',
        primaryColor: primaryColor,
      ),
      SettingsPage(
        mosque: _mosque,
        primaryColor: primaryColor,
        onMosqueChanged: (value) => setState(() => _mosque = value),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryColor,
      drawer: CustomDrawer(primaryColor: primaryColor),
      appBar: CustomAppBar(
        title: l10n.titleApp,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        backgroundColor: primaryColor,
      ),
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
                label: l10n.home,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _buildBottomNavItem(
                index: 1,
                icon: Icons.library_music_outlined,
                selectedIcon: Icons.library_music,
                label: l10n.services,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _buildBottomNavItem(
                index: 2,
                icon: Icons.mail_outline,
                selectedIcon: Icons.mail,
                label: l10n.liveStream,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              _buildBottomNavItem(
                index: 3,
                icon: Icons.settings_outlined,
                selectedIcon: Icons.settings,
                label: l10n.settings,
                onTap: () => setState(() => _selectedIndex = 3),
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
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedIndex == index;
    final brownColor = const Color(0xFF8B6F47);

    final baseTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w500,
      fontFamily: 'DINNextLTArabic',
    );

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: isSelected
                ? Border(top: BorderSide(color: brownColor, width: 4))
                : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? brownColor : Colors.white,
                size: 26,
              ),
              //const SizedBox(height: 2),
              Text(
                label,
                style: baseTextStyle.copyWith(
                  color: isSelected ? brownColor : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
