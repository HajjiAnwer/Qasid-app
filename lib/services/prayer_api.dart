import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hijri/hijri_calendar.dart';
import '../models/prayer_time.dart';

class PrayerApi {
  final http.Client client;

  // Caching
  final Map<String, List<PrayerTime>> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheTtl = Duration(minutes: 5);

  PrayerApi({http.Client? client}) : client = client ?? http.Client();

  String _cacheKey({
    required String mosque,
    required int hijriYear,
    required int hijriMonth,
    required int hijriDay,
  }) =>
      '$mosque-$hijriYear-$hijriMonth-$hijriDay';

  Uri _buildUri({
    required String mosque,
    required int hijriYear,
    required int hijriMonth,
    required int hijriDay,
    int skip = 0,
    int take = 10,
  }) {
    final base = 'https://haramainflagsapi.prh.gov.sa/prayers';
    final params = {
      'hijriYear': '$hijriYear',
      'hijriMonth': '$hijriMonth',
      'hijriDay': '$hijriDay',
      'mosque': mosque,
      'orderField': 'prayer',
      'orderValue': 'asc',
      'skip': '$skip',
      'take': '$take',
    };
    final uri = Uri.parse(base).replace(queryParameters: params);
    return uri;
  }

  // Retry
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
      } catch (e) {
        if (attempt >= maxAttempts) rethrow;
        await Future.delayed(delay);
      }
    }
  }


  Future<List<PrayerTime>> fetchPrayers({
    required String mosque,
    required int hijriYear,
    required int hijriMonth,
    required int hijriDay,
    int take = 20,
  }) async {
    final key = _cacheKey(
      mosque: mosque,
      hijriYear: hijriYear,
      hijriMonth: hijriMonth,
      hijriDay: hijriDay,
    );

    // retreive from cache
    final cached = _cache[key];
    final cachedAt = _cacheTimestamps[key];
    if (cached != null &&
        cachedAt != null &&
        DateTime.now().difference(cachedAt) < _cacheTtl) {
      return cached;
    }

    final uri = _buildUri(
      mosque: mosque,
      hijriYear: hijriYear,
      hijriMonth: hijriMonth,
      hijriDay: hijriDay,
      take: take,
    );

    final resp = await _withRetry(
          () => client.get(uri, headers: {'accept': '*/*'}),
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed to load prayers: ${resp.statusCode}');
    }

    final body = json.decode(resp.body);

    List<dynamic> listJson;
    if (body is List) {
      listJson = body;
    } else if (body is Map && body['data'] is List) {
      listJson = body['data'] as List;
    } else {
      listJson = const [];
    }

    final list = listJson
        .map((e) => PrayerTime.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Save in cache
    _cache[key] = list;
    _cacheTimestamps[key] = DateTime.now();

    return list;
  }

  /// fetchPrayers
  // Future<List<PrayerTime>> getPrayerTimes(String mosque) async {
  //   final hijri = HijriCalendar.now();
  //   return fetchPrayers(
  //     mosque: mosque,
  //     hijriYear: hijri.hYear,
  //     hijriMonth: hijri.hMonth,
  //     hijriDay: hijri.hDay,
  //     take: 20,
  //   );
  // }

  Future<List<PrayerTime>> getPrayerTimes({
    required String mosque,
    required DateTime date,
  }) {
    final hijri = HijriCalendar.fromDate(date);

    // print('📅 Gregorian: $date');
    // print('🌙 Hijri: ${hijri.hYear}-${hijri.hMonth}-${hijri.hDay}');
    // print('🕌 Mosque: $mosque');

    return fetchPrayers(
      mosque: mosque,
      hijriYear: hijri.hYear,
      hijriMonth: hijri.hMonth,
      hijriDay: hijri.hDay,
    );
  }

  void dispose() => client.close();
}
