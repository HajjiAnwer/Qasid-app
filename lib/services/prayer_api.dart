import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hijri/hijri_calendar.dart';
import '../models/prayer_time.dart';

class PrayerApi {
  final http.Client client;

  final Box _cacheBox = Hive.box('prayer_cache');
  final Box _metaBox = Hive.box('prayer_cache_meta');

  static const Duration _cacheTtl = Duration(hours: 24);

  PrayerApi({http.Client? client}) : client = client ?? http.Client();

  // 🔑 Cache key per mosque only
  String _cacheKey({required String mosque}) => mosque.toLowerCase();

  Uri _buildUri({
    required String mosque,
    required int hijriYear,
    required int hijriMonth,
    required int hijriDay,
    int skip = 0,
    int take = 20,
  }) {
    return Uri.parse('https://haramainflagsapi.prh.gov.sa/prayers').replace(
      queryParameters: {
        'hijriYear': '$hijriYear',
        'hijriMonth': '$hijriMonth',
        'hijriDay': '$hijriDay',
        'mosque': mosque,
        'orderField': 'prayer',
        'orderValue': 'asc',
        'skip': '$skip',
        'take': '$take',
      },
    );
  }

  // 🔁 Retry helper
  Future<T> _withRetry<T>(
      Future<T> Function() task, {
        int maxAttempts = 2,
        Duration delay = const Duration(seconds: 1),
      }) async {
    int attempt = 0;
    while (true) {
      attempt++;
      try {
        return await task();
      } catch (_) {
        if (attempt >= maxAttempts) rethrow;
        await Future.delayed(delay);
      }
    }
  }

  // 🧹 Auto cleanup old cache
  void _cleanupOldCache() {
    final now = DateTime.now();

    for (final key in _metaBox.keys) {
      final cachedAt =
      DateTime.fromMillisecondsSinceEpoch(_metaBox.get(key) as int);

      if (now.difference(cachedAt) > _cacheTtl) {
        _cacheBox.delete(key);
        _metaBox.delete(key);
      }
    }
  }

  // ===============================
  // 🔥 FETCH PRAYERS (HIVE CACHE)
  // ===============================
  Future<List<PrayerTime>> fetchPrayers({
    required String mosque,
    required DateTime date,
  }) async {
    _cleanupOldCache();

    final key = _cacheKey(mosque: mosque);

    // 1️⃣ Try cache
    final cached = _cacheBox.get(key);
    final cachedAtMillis = _metaBox.get(key);

    if (cached != null && cachedAtMillis != null) {
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMillis as int);
      if (DateTime.now().difference(cachedAt) < _cacheTtl) {
        return (cached as List)
            .map((e) => PrayerTime.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }

    // 2️⃣ Fetch from API
    final hijri = HijriCalendar.fromDate(date);
    final resp = await _withRetry(
          () => client.get(
        _buildUri(
          mosque: mosque,
          hijriYear: hijri.hYear,
          hijriMonth: hijri.hMonth,
          hijriDay: hijri.hDay,
        ),
        headers: {
          'accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Android)',
        },
      ),
    );

    if (resp.statusCode != 200) {
      print("STATUS: ${resp.statusCode}");
      print("BODY: ${resp.body}");
      throw Exception('Failed to load prayers');
    }

    final body = json.decode(resp.body);
    final List<dynamic> listJson = body is List ? body : (body['data'] ?? []);
    final prayers = listJson
        .map((e) => PrayerTime.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // 3️⃣ Save to cache per mosque only
    _cacheBox.put(key, prayers.map((e) => e.toJson()).toList());
    _metaBox.put(key, DateTime.now().millisecondsSinceEpoch);

    return prayers;
  }

  // Public API
  Future<List<PrayerTime>> getPrayerTimes({
    required String mosque,
    required DateTime date,
  }) {
    return fetchPrayers(mosque: mosque, date: date);
  }

  void dispose() => client.close();
}
