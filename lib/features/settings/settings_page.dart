import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../app_state.dart';
import '../../l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  final String mosque; // mecca | madinah
  final Color primaryColor;
  final ValueChanged<String> onMosqueChanged;

  const SettingsPage({
    super.key,
    required this.mosque,
    required this.primaryColor,
    required this.onMosqueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// ================= Language =================
          _SettingCard(
            title: l10n.language,
            icon: Icons.language,
            child: Column(
              children: [
                RadioListTile<bool>(
                  title: Text(
                    l10n.arabic,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'DINNextLTArabic',
                    ),
                  ),
                  value: true,
                  groupValue: Localizations.localeOf(context).languageCode.startsWith('ar'),
                    onChanged: (v) =>
                        context.read<AppState>().setLocale(const Locale('ar')),
                  activeColor: primaryColor,
                ),
                RadioListTile<bool>(
                  title: Text(
                    l10n.english,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'DINNextLTArabic',
                    ),
                  ),
                  value: false,
                  groupValue: Localizations.localeOf(context).languageCode.startsWith('ar'),
                    onChanged: (v) =>
                        context.read<AppState>().setLocale(const Locale('en')),
                  activeColor: primaryColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// ================= Choose Masjid =================
          _SettingCard(
            title: l10n.selectMosque,
            icon: Icons.mosque,
            iconColor: primaryColor,
            child: Row(
              children: [

                /// المسجد الحرام
                Expanded(
                  child: _MosqueButton(
                    title: l10n.alHaram,
                    selected: mosque == 'mecca',
                    color: const Color(0xFFD4AF37),
                    onTap: () => onMosqueChanged('mecca'),
                  ),
                ),

                const SizedBox(width: 12),

                /// المسجد النبوي
                Expanded(
                  child: _MosqueButton(
                    title: l10n.anNabawi,
                    selected: mosque == 'madinah',
                    color: const Color(0xFF0C6B43),
                    onTap: () => onMosqueChanged('madinah'),
                  ),
                ),


              ],
            ),
          ),

          const SizedBox(height: 16),

          // /// ================= Prayer Notifications =================
          // _SettingCard(
          //   title: isAr ? 'تنبيهات الصلاة' : 'Prayer Notifications',
          //   icon: Icons.notifications_active,
          //   child: Column(
          //     children: [
          //       _SettingRow(
          //         title: isAr
          //             ? 'إشعار عند دخول وقت الصلاة'
          //             : 'Notify at prayer time',
          //         trailing: Switch(
          //           value: true,
          //           activeColor: primaryColor,
          //           onChanged: (_) {},
          //         ),
          //       ),
          //       const Divider(height: 24),
          //       _SettingRow(
          //         title: isAr
          //             ? 'تنبيه قبل الأذان'
          //             : 'Pre-prayer reminder',
          //         value: isAr ? 'قبل 10 دقائق' : '10 minutes before',
          //         showArrow: true,
          //         onTap: () {},
          //       ),
          //     ],
          //   ),
          // ),
          //
          // const SizedBox(height: 16),

          /// ================= About =================
          _SettingCard(
            title: l10n.about,
            icon: Icons.info_outline,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.appName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'DINNextLTArabic',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.version,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'DINNextLTArabic',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// ================= Share the App =================
          _SettingCard(
            title: l10n.shareApp,
            icon: Icons.share,
            child: _SettingRow(
              title: l10n.shareAppDescription,// e.g., "Share this app with your friends"
              showArrow: true,
              onTap: () {
                Share.share(
                  'Check out this amazing app: https://example.com', // replace with your app link
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          /// ================= Font Scale =================
          _SettingCard(
            title: l10n.fontScale,
            icon: Icons.text_fields,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider(
                  value: context.watch<AppState>().fontScale,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7, // steps: 0.8, 0.9, 1.0 ... 1.5
                  label: '${(context.watch<AppState>().fontScale * 100).round()}%',
                  activeColor: primaryColor, // ✅ primary color tint
                  onChanged: (value) {
                    context.read<AppState>().setFontScale(value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    '${(context.watch<AppState>().fontScale * 100).round()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
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

/// =================== Components ===================

class _SettingCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget child;

  const _SettingCard({
    required this.title,
    required this.icon,
    this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor ?? Colors.black87),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'DINNextLTArabic',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? trailing;
  final bool showArrow;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.title,
    this.value,
    this.trailing,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'DINNextLTArabic',
                    )),
                if (value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      value!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'DINNextLTArabic',
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
          if (showArrow)
            const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}

class _MosqueButton extends StatelessWidget {
  final String title;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _MosqueButton({
    required this.title,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            )
          ]
              : [],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: 'DINNextLTArabic',
            ),
          ),
        ),
      ),
    );
  }
}
