import 'package:daily_dose_of_happiness/model/feeling_model.dart';

class DailyEntryMB {
  final DateTime day; // Date (00:00)
  final FeelingModel? feeling;
  final DateTime? createdAt;

  DailyEntryMB({
    required this.day,
    required this.feeling,
    required this.createdAt,
  });

  factory DailyEntryMB.fromJson(Map<String, dynamic> json) {
    final dayStr = json['day'] as String?;
    final createdAtStr = json['created_at'] as String?;

    return DailyEntryMB(
      day: dayStr != null ? DateTime.parse(dayStr) : DateTime.now(),
      feeling: json['feeling'] != null
          ? FeelingModel.fromJson(
              Map<String, dynamic>.from(json['feeling'] as Map))
          : null,
      createdAt: createdAtStr != null ? DateTime.parse(createdAtStr) : null,
    );
  }
}
