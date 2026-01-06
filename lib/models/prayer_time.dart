class PrayerTime {
  final String id;
  final String prayer; // e.g. "fajr", "dhuhr", "preFajr"
  final DateTime dateTimeUtc; // original UTC from datetimestampz
  final bool isExtra;
  final bool isNotified;
  final String mosque;

  // muezzin / imam details (optional)
  final Person? muezzin;
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

  /// convenience: local time for device
  DateTime get localDateTime => dateTimeUtc.toLocal();

  /// formatted clock "HH:mm"
  String get timeString {
    final lt = localDateTime;
    final two = (int n) => n.toString().padLeft(2, '0');
    return '${two(lt.hour)}:${two(lt.minute)}';
  }

  /// Prayer name localized
  String prayerName(bool isAr) {
    const ar = {
      'fajr': 'الفجر',
      'preFajr': 'قبل الفجر',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
    };

    const en = {
      'fajr': 'Fajr',
      'preFajr': 'Pre-Fajr',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
    };

    return isAr
        ? (ar[prayer] ?? prayer)
        : (en[prayer] ?? prayer);
  }
}

class Person {
  final String id;
  final String firstName;
  final String firstNameEn;
  final String middleName;
  final String middleNameEn;
  final String lastName;
  final String lastNameEn;
  final String? imageUrl;

  Person({
    required this.id,
    required this.firstName,
    required this.firstNameEn,
    required this.middleName,
    required this.middleNameEn,
    required this.lastName,
    required this.lastNameEn,
    this.imageUrl,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id']?.toString() ?? '',
      firstName: (json['firstName'] ?? '').toString(),
      firstNameEn: (json['firstNameEn'] ?? '').toString(),
      middleName: (json['middleName'] ?? '').toString(),
      middleNameEn: (json['middleNameEn'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      lastNameEn: (json['lastNameEn'] ?? '').toString(),
      imageUrl: json['image']?.toString(),
    );
  }


  String displayName(bool isAr) {
    if (isAr) {
      return [firstName, middleName, lastName]
          .where((e) => e.trim().isNotEmpty)
          .join(' ');
    } else {
      return [firstNameEn, middleNameEn, lastNameEn]
          .where((e) => e.trim().isNotEmpty)
          .join(' ');
    }
  }
}

