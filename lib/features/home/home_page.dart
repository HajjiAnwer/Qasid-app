import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../l10n/app_localizations.dart';
import '../../models/prayer_time.dart';
import '../../services/prayer_api.dart';
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
  final PrayerApi _api = PrayerApi();

  List<PrayerTime> _prayers = [];
  bool _loading = true;
  String? _error;

  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadPrayers();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mosque != widget.mosque) {
      _loadPrayers();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _api.dispose();
    super.dispose();
  }

  // ===============================
  // تحميل الصلوات (اليوم أو بكرة)
  // ===============================
  Future<void> _loadPrayers({bool isTomorrow = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final now = DateTime.now();
      final targetDate =
      isTomorrow ? now.add(const Duration(days: 1)) : now;

      final hijri = HijriCalendar.fromDate(targetDate);

      final list = await _api.fetchPrayers(
        mosque: widget.mosque,
        hijriYear: hijri.hYear,
        hijriMonth: hijri.hMonth,
        hijriDay: hijri.hDay,
      );

      if (!mounted) return;

      // إذا ما فيه صلاة قادمة اليوم → نجيب صلوات بكرة
      if (!isTomorrow && !_hasUpcomingPrayer(list)) {
        await _loadPrayers(isTomorrow: true);
        return;
      }

      setState(() {
        _prayers = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
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
    // Find previous prayer time to calculate total duration
    int index = _prayers.indexOf(active);
    DateTime? prevTime;
    
    if (index > 0) {
      prevTime = _prayers[index - 1].localDateTime;
    } else {
      // If first prayer of day, assume 6 hours ago or use a default interval
      prevTime = start.subtract(const Duration(hours: 4));
    }

    final totalDuration = start.difference(prevTime).inSeconds;
    final remainingDuration = start.difference(_now).inSeconds;

    if (totalDuration <= 0) return 0.0;
    
    double progress = remainingDuration / totalDuration;
    return progress.clamp(0.0, 1.0);
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
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final active = _getActivePrayer();
    final bool isTomorrowPrayer = active != null &&
        active.localDateTime.day != _now.day;
    final start = active?.localDateTime;

    final diff = start == null
        ? Duration.zero
        : _now.isBefore(start)
        ? start.difference(_now)
        : _now.difference(start);

    final imamName = active?.imam?.displayName(Localizations.localeOf(context).languageCode.startsWith('ar'));
    final muezzinName = active?.muezzin?.displayName(Localizations.localeOf(context).languageCode.startsWith('ar'));
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

                      if (_loading)
                        const Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        )
                      else if (active != null)
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
    final bool isMecca = widget.mosque == 'mecca';

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
  // Prayer Section (Separated Timer & Details)
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
