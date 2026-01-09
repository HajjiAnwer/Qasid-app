import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Color primaryColor;
  const CustomDrawer({
    Key? key,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withOpacity(0.8),
                primaryColor.withOpacity(0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildMenu(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // App logo
        Center(
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              'assets/images/log_white_bg.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Welcome card
        _buildWelcomeCard(context)
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: isRtl
            ? _rtlWelcomeContent() // Arabic
            : _ltrWelcomeContent(), // English or other LTR
      ),
    );
  }

// Arabic layout: Avatar right, text/buttons left
  List<Widget> _rtlWelcomeContent() {
    return [
      // Expanded text/buttons on the left
      _avatar(),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مرحبا بك',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'DINNextLTArabic',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _actionButton(text: 'إنشاء حساب', filled: true),
                const SizedBox(width: 5),
                _actionButton(text: 'تسجيل الدخول', filled: false),
              ],
            ),
          ],
        ),
      ),
    ];
  }

// LTR layout: Avatar left, text/buttons right
  List<Widget> _ltrWelcomeContent() {
    return [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'DINNextLTArabic',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _actionButton(text: 'Login', filled: false),
                const SizedBox(width: 5),
                _actionButton(text: 'Sign Up', filled: true),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(width: 10),
      _avatar(),
    ];
  }

// Avatar widget
  Widget _avatar() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: primaryColor, width: 4),
      ),
      child: Center(
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  Widget _actionButton({required String text, required bool filled}) {
    return Container(
      width: 90, // fixed width for all buttons
      height: 35, // fixed height for all buttons
      decoration: BoxDecoration(
        color: filled ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: filled ? Colors.white : primaryColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'DINNextLTArabic',
          ),
        ),
      ),
    );
  }


  // ================= MENU =================
  Widget _buildMenu(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: ListView(
          children: [
            _menuItem(context, Icons.group, 'حلقات'),
            _menuItem(context, Icons.menu_book, 'المصحف'),
            _menuItem(context, Icons.admin_panel_settings, 'دخول الإدارة'),
            const Divider(),
            _menuItem(context, Icons.star, 'الإنجازات ونقاط الولاء'),
            _menuItem(context, Icons.settings, 'إدارة الخطط'),
            _menuItem(context, Icons.person, 'خططي الشخصية'),
            _menuItem(context, Icons.app_registration, 'تسجيلاتي'),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return ListTile(
      leading: isRtl ? _iconContainer(icon) : null  ,
      trailing: isRtl ? null : _iconContainer(icon) ,
      title: Align(
        alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontFamily: 'DINNextLTArabic',
            color: primaryColor,
          ),
        ),
      ),
      onTap: () {},
    );
  }

  Widget _iconContainer(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: primaryColor),
    );
  }
}
