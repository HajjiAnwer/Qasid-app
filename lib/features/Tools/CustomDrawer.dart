import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2F6F64),
                Color(0xFF4E8B7A),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildMenu(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Column(
      children: [
        // App logo
        Center(
          child: Container(
            height: 80,
            width: 80, // optional
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
        Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // AVATAR (auto RTL/LTR)
              Container(
                width: 64, // 56 + 2*5 for outer border
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(color: Colors.amber, width: 4), // 🔹 outer border (main color)
                ),
                child: Center(
                  child: Container(
                    width: 54, // inner circle
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2), // 🔹 inner white border
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                ),
              ),
              // Spacer
              const SizedBox(width: 10),
              // RIGHT-ALIGNED CONTENT
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
                      mainAxisSize: MainAxisSize.min, // wrap buttons tightly
                      children: [
                        _actionButton(
                          text: 'تسجيل الدخول',
                          filled: false,
                        ),
                        const SizedBox(width: 5),
                        _actionButton(
                          text: 'إنشاء حساب',
                          filled: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )

      ],
    );
  }

  Widget _actionButton({required String text, required bool filled}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? Colors.amber : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: filled ? null : Border.all(color: Colors.amber),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: filled ? Colors.white : Colors.amber,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'DINNextLTArabic',
        ),
      ),
    );
  }

  // ================= MENU =================
  Widget _buildMenu() {
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
            _menuItem(Icons.group, 'حلقات'),
            _menuItem(Icons.menu_book, 'المصحف'),
            _menuItem(Icons.admin_panel_settings, 'دخول الإدارة'),
            const Divider(),
            _menuItem(Icons.star, 'الإنجازات ونقاط الولاء'),
            _menuItem(Icons.settings, 'إدارة الخطط'),
            _menuItem(Icons.person, 'خططي الشخصية'),
            _menuItem(Icons.app_registration, 'تسجيلاتي'),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF5F3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF2F6F64)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontFamily: 'DINNextLTArabic',
          color: Color(0xFF2F6F64),
        ),
      ),
      onTap: () {},
    );
  }
}
