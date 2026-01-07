import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../models/prayer_time.dart';
import '../Tools/top-nav-bar.dart';
import 'home_services_section.dart';
import 'prayer_timer_display.dart';

class HomePage extends StatefulWidget {
  final String mosque; // mecca | madinah
  final Color primaryColor;
  final ValueChanged<String> onMosqueChanged;

  const HomePage({
    super.key,
    required this.mosque,
    required this.primaryColor,
    required this.onMosqueChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PrayerTime> _prayers = [];
  late Timer _timer;
  DateTime _now = DateTime.now();

  late Box _prayerBox;

  @override
  void initState() {
    super.initState();
    _openHiveBox().then((_) {
      _loadCachedPrayers();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  Future<void> _openHiveBox() async {
    _prayerBox = await Hive.openBox('prayers_${widget.mosque.toLowerCase()}');
  }

  void _loadCachedPrayers() {
    final now = DateTime.now();

    // Try today first
    final todayHijri = HijriCalendar.fromDate(now);
    final todayKey = '${todayHijri.hYear}-${todayHijri.hMonth}-${todayHijri.hDay}';
    List<PrayerTime>? list = (_prayerBox.get(todayKey) as List?)?.cast<PrayerTime>();

    // If no upcoming prayers today, try tomorrow
    if (list == null || !_hasUpcomingPrayer(list)) {
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowHijri = HijriCalendar.fromDate(tomorrow);
      final tomorrowKey = '${tomorrowHijri.hYear}-${tomorrowHijri.hMonth}-${tomorrowHijri.hDay}';
      list = (_prayerBox.get(tomorrowKey) as List?)?.cast<PrayerTime>() ?? [];
    }

    setState(() {
      _prayers = list ?? [];
    });
  }

  bool _hasUpcomingPrayer(List<PrayerTime> list) {
    for (final p in list.where((e) => !e.isExtra)) {
      final start = p.localDateTime;
      final end = start.add(const Duration(minutes: 30));
      if (_now.isBefore(end)) return true;
    }
    return false;
  }

  PrayerTime? _getActivePrayer() {
    for (final p in _prayers.where((e) => !e.isExtra)) {
      final start = p.localDateTime;
      final end = start.add(const Duration(minutes: 30));
      if (_now.isBefore(end)) return p;
    }
    return null;
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  double _getProgress(PrayerTime? active) {
    if (active == null) return 0.0;

    final start = active.localDateTime;
    int index = _prayers.indexOf(active);
    DateTime prevTime;

    if (index > 0) {
      prevTime = _prayers[index - 1].localDateTime;
    } else {
      prevTime = start.subtract(const Duration(hours: 4));
    }

    final totalDuration = start.difference(prevTime).inSeconds;
    final remainingDuration = start.difference(_now).inSeconds;

    if (totalDuration <= 0) return 0.0;

    return (remainingDuration / totalDuration).clamp(0.0, 1.0);
  }

  String _getPrayerName(String prayerKey) {
    final l10n = context.l10n;
    switch (prayerKey.toLowerCase()) {
      case 'fajr':
        return l10n.fajr;
      case 'prefajr':
        return l10n.preFajr;
      case 'dhuhr':
        return l10n.dhuhr;
      case 'asr':
        return l10n.asr;
      case 'maghrib':
        return l10n.maghrib;
      case 'isha':
        return l10n.isha;
      default:
        return prayerKey;
    }
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mosque != widget.mosque) {
      _openHiveBox().then((_) => _loadCachedPrayers());
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = _getActivePrayer();
    final start = active?.localDateTime;
    final diff = start == null
        ? Duration.zero
        : _now.isBefore(start)
        ? start.difference(_now)
        : _now.difference(start);

    final imamName = active?.imam == null
        ? null
        : (Localizations.localeOf(context).languageCode.startsWith('ar')
        ? '${active!.imam!.lastName} ${active!.imam!.firstName}'
        : '${active!.imam!.firstName} ${active!.imam!.lastName}');

    final muezzinName = active?.muezzin == null
        ? null
        : (Localizations.localeOf(context).languageCode.startsWith('ar')
        ? '${active!.muezzin!.lastName} ${active!.muezzin!.firstName}'
        : '${active!.muezzin!.firstName} ${active!.muezzin!.lastName}');

    final progress = _getProgress(active);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TopNavBar(primaryColor: widget.primaryColor),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      _buildMosqueSelector(),
                      const SizedBox(height: 24),
                      if (active != null)
                        _buildPrayerSection(
                          prayerName: _getPrayerName(active.prayer),
                          timerText: _format(diff),
                          imam: imamName,
                          muezzin: muezzinName,
                          progress: progress,
                        ),
                      const SizedBox(height: 32),
                      HomeServicesSection(
                        mosque: widget.mosque,
                        primaryColor: widget.primaryColor,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================
  // Mosque Selector
  // ===============================
  Widget _buildMosqueSelector() {
    final l10n = context.l10n;
    final bool isMecca = widget.mosque.toLowerCase() == 'mecca';

    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: widget.primaryColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildSegment(
                selected: isMecca,
                text: l10n.alHaram,
                onTap: () => widget.onMosqueChanged('mecca'),
              ),
            ),
            Expanded(
              child: _buildSegment(
                selected: !isMecca,
                text: l10n.anNabawi,
                onTap: () => widget.onMosqueChanged('madinah'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment({
    required bool selected,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? widget.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  // ===============================
  // Prayer Section
  // ===============================
  Widget _buildPrayerSection({
    required String prayerName,
    required String timerText,
    String? imam,
    String? muezzin,
    required double progress,
  }) {
    final l10n = context.l10n;
    return Column(
      children: [
        PrayerTimerDisplay(
          prayerName: prayerName,
          timerText: timerText,
          primaryColor: widget.primaryColor,
          progress: progress,
        ),
        const SizedBox(height: 24),
        if ((imam?.isNotEmpty ?? false) || (muezzin?.isNotEmpty ?? false))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.primaryColor,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                if (imam != null && imam.isNotEmpty)
                  _buildDetailRow(
                    icon: Icons.person,
                    label: l10n.imam,
                    value: imam,
                  ),
                if (imam != null && imam.isNotEmpty && muezzin != null && muezzin.isNotEmpty)
                  const SizedBox(height: 8),
                if (muezzin != null && muezzin.isNotEmpty)
                  _buildDetailRow(
                    icon: Icons.mic,
                    label: l10n.muezzin,
                    value: muezzin,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: widget.primaryColor, size: 20),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
