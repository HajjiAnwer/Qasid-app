import '../../services/prayer_api.dart';


class PrayerPreloadController {
  static Future<void> preload({
    required List<String> mosques,
  }) async {
    final api = PrayerApi();
    final today = DateTime.now();

    // Cleanup happens automatically inside fetch
    for (final mosque in mosques) {
      await api.getPrayerTimes(
        mosque: mosque,
        date: today,
      );
    }

    api.dispose();
  }
}
