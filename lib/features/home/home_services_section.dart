import 'package:flutter/material.dart';
import '../web_page/web_page.dart';

class HomeServicesSection extends StatelessWidget {
  final bool isAr;
  final String mosque; // mecca | madinah
  final Color primaryColor;

  const HomeServicesSection({
    super.key,
    required this.isAr,
    required this.mosque,
    required this.primaryColor,
  });

  bool get isMakkah => mosque == 'mecca';

  String _buildUrl(_ServiceItem item) {
    final lang = isAr ? 'ar' : 'en';
    final mode = isMakkah ? 'makkah' : 'madina';
    return 'https://services.prh.gov.sa/$lang/${item.path}?mode=$mode';
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _ServiceItem(
        icon: Icons.book,
        titleAr: "المصطلحات الشرعية",
        titleEn: "Islamic Terms",
        descAr: "خدمة تشرح المصطلحات الشرعية بطريقة مبسطة وواضحة",
        descEn:
        "A service explaining Islamic legal terms in a simplified and clear manner",
        path: "mostalahat.php",
      ),
      _ServiceItem(
        icon: Icons.record_voice_over,
        titleAr: isMakkah ? "تلاوات المسجد الحرام" : "تلاوات المسجد النبوي",
        titleEn: "Haram Recitations",
        descAr: isMakkah
            ? "خدمة صوتية لتلاوات الأئمة من المسجد الحرام"
            : "خدمة صوتية لتلاوات الأئمة من المسجد النبوي",
        descEn:
        "Audio service for the recitations of the Imams of the Sacred Mosque",
        path: isMakkah ? "tilawa_makka.php" : "tilawa.php",
      ),
      _ServiceItem(
        icon: Icons.menu_book_outlined,
        titleAr: "مختارات من الأدعية",
        titleEn: "Selected Supplications",
        descAr: "خدمة تقدم مختارات من الأدعية المأثورة بصيغتها الصحيحة",
        descEn:
        "A service offering selected reported supplications in their authentic form",
        path: "adiya.php",
      ),
      _ServiceItem(
        icon: Icons.wash,
        titleAr: "صفة الوضوء",
        titleEn: "How to Perform Wudu",
        descAr: "شرح صفة الوضوء باختصار ويسر",
        descEn:
        "A service for the concise and simple explanation of the Prophet's ablution",
        path: "oudhoue.php",
      ),
      _ServiceItem(
        icon: Icons.self_improvement,
        titleAr: "صفة الصلاة",
        titleEn: "How to Pray",
        descAr: "خدمة توضح صفة صلاة النبي خطوة بخطوة بوضوح",
        descEn:
        "A service illustrating the Prophet's manner of prayer step by step with clarity",
        path: "salat.php",
      ),
      _ServiceItem(
        icon: Icons.location_city,
        titleAr: "الأماكن المقدسة",
        titleEn: "Holy Places",
        descAr: "خدمة تعريفية بالأماكن المقدسة في الإسلام ومكانتها العظيمة",
        descEn:
        "An introductory service on the sacred places in Islam and their great status",
        path: "amakin_mokadasa.php",
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (_, i) {
        final item = items[i];
        return _buildServiceCard(context, item);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, _ServiceItem item) {
    // const gold = Color(0xFFC9AA63);
    final url = _buildUrl(item);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebPage(
              title: isAr ? item.titleAr : item.titleEn,
              url: url,
              primaryColor: primaryColor,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              isAr ? item.titleAr : item.titleEn,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String titleAr;
  final String titleEn;
  final String descAr;
  final String descEn;
  final String path;

  _ServiceItem({
    required this.icon,
    required this.titleAr,
    required this.titleEn,
    required this.descAr,
    required this.descEn,
    required this.path,
  });
}
