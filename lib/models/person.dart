import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String firstNameEn;

  @HiveField(3)
  final String middleName;

  @HiveField(4)
  final String middleNameEn;

  @HiveField(5)
  final String lastName;

  @HiveField(6)
  final String lastNameEn;

  @HiveField(7)
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

  String displayName(bool isArabic) {
    return isArabic ? '$firstName $middleName $lastName' : '$firstNameEn $middleNameEn $lastNameEn';
  }

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

  // ✅ Add this method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'firstNameEn': firstNameEn,
      'middleName': middleName,
      'middleNameEn': middleNameEn,
      'lastName': lastName,
      'lastNameEn': lastNameEn,
      'image': imageUrl,
    };
  }

}
