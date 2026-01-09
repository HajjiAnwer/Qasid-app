import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../web_page/web_page.dart';

class HomeServicesSection extends StatelessWidget {
  final String mosque; // mecca | madinah
  final Color primaryColor;

  const HomeServicesSection({
    super.key,
    required this.mosque,
    required this.primaryColor,
  });

  bool get isMakkah => mosque == 'mecca';

  String _buildUrl(_ServiceItem item) {
    final Locale locale = WidgetsBinding.instance.window.locale;
    final lang = locale.languageCode;
    final mode = isMakkah ? 'makkah' : 'madina';
    return 'https://services.prh.gov.sa/$lang/${item.path}?mode=$mode';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    final items = [
      _ServiceItem(
        icon: Icons.book,
        titleKey: 'islamicTerms',
        descKey: 'islamicTermsDesc',
        path: "mostalahat.php",
      ),
      _ServiceItem(
        icon: Icons.record_voice_over,
        titleKey: isMakkah ? 'haramRecitations' : 'tawafRecitations',
        descKey: isMakkah ? 'haramRecitationsDesc' : 'tawafRecitationsDesc',
        path: isMakkah ? "tilawa_makka.php" : "tilawa.php",
      ),
      _ServiceItem(
        icon: Icons.menu_book_outlined,
        titleKey: 'selectedSupplications',
        descKey: 'selectedSupplicationsDesc',
        path: "adiya.php",
      ),
      _ServiceItem(
        icon: Icons.wash,
        titleKey: 'howToPerformWudu',
        descKey: 'howToPerformWuduDesc',
        path: "oudhoue.php",
      ),
      _ServiceItem(
        icon: Icons.self_improvement,
        titleKey: 'howToPray',
        descKey: 'howToPrayDesc',
        path: "salat.php",
      ),
      _ServiceItem(
        icon: Icons.location_city,
        titleKey: 'holyPlaces',
        descKey: 'holyPlacesDesc',
        path: "amakin_mokadasa.php",
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (_, i) {
        final item = items[i];
        return _buildServiceCard(context, item, l10n);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, _ServiceItem item, AppLocalizations l10n) {
    final url = _buildUrl(item);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebPage(
              title: getTitle(item.titleKey, l10n),
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
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: Colors.white, size: 36),
            const SizedBox(height: 6),
            Text(
              getTitle(item.titleKey, l10n),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'DINNextLTArabic',
                fontSize: 13,
                fontWeight: FontWeight.w700
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTitle(String key, AppLocalizations l10n) {
    switch (key) {
      case 'islamicTerms': return l10n.islamicTerms;
      case 'haramRecitations': return l10n.haramRecitations;
      case 'tawafRecitations': return l10n.tawafRecitations;
      case 'selectedSupplications': return l10n.selectedSupplications;
      case 'howToPerformWudu': return l10n.howToPerformWudu;
      case 'howToPray': return l10n.howToPray;
      case 'holyPlaces': return l10n.holyPlaces;
      case 'alfatiha': return l10n.alfatiha;
      default: return '';
    }
  }
}

class _ServiceItem {
  final IconData icon;
  final String titleKey;
  final String descKey;
  final String path;

  _ServiceItem({
    required this.icon,
    required this.titleKey,
    required this.descKey,
    required this.path,
  });
}
