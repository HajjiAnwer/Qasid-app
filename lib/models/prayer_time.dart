import 'package:hive/hive.dart';
import 'person.dart';

part 'prayer_time.g.dart';

@HiveType(typeId: 2)
class PrayerTime {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String prayer;

  @HiveField(2)
  final DateTime dateTimeUtc;

  @HiveField(3)
  final bool isExtra;

  @HiveField(4)
  final bool isNotified;

  @HiveField(5)
  final String mosque;

  @HiveField(6)
  final Person? muezzin;

  @HiveField(7)
  final Person? imam;

  PrayerTime({
    required this.id,
    required this.prayer,
    required this.dateTimeUtc,
    required this.isExtra,
    required this.isNotified,
    required this.mosque,
    this.muezzin,
    this.imam,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    DateTime dt =
        DateTime.tryParse('${json['datetimestampz'] ?? ''}')?.toUtc() ??
            DateTime.fromMillisecondsSinceEpoch(0).toUtc();

    Person? parsePerson(dynamic p) {
      if (p == null || p is! Map) return null;
      return Person.fromJson(Map<String, dynamic>.from(p));
    }

    return PrayerTime(
      id: json['id']?.toString() ?? '',
      prayer: (json['prayer'] ?? '').toString(),
      dateTimeUtc: dt,
      isExtra: json['isExtra'] == true,
      isNotified: json['isNotified'] == true,
      mosque: (json['mosque'] ?? '').toString(),
      muezzin: parsePerson(json['muezzin']),
      imam: parsePerson(json['imam']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prayer': prayer,
      'datetimestampz': dateTimeUtc.toIso8601String(),
      'isExtra': isExtra,
      'isNotified': isNotified,
      'mosque': mosque,
      'muezzin': muezzin?.toJson(), // serialize nested
      'imam': imam?.toJson(),       // serialize nested
    };
  }


  DateTime get localDateTime => dateTimeUtc.toLocal();

  String get timeString {
    final lt = localDateTime;
    final two = (int n) => n.toString().padLeft(2, '0');
    return '${two(lt.hour)}:${two(lt.minute)}';
  }
}
