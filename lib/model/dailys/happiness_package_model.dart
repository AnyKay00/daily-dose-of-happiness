import 'package:daily_dose_of_happiness/model/dailys/action_model.dart';
import 'package:daily_dose_of_happiness/model/dailys/joke_model.dart';
import 'package:daily_dose_of_happiness/model/dailys/motivation_model.dart';

class HappinessPackModel {
  final String feelingId;
  final DateTime generatedAt;
  final JokeModel? joke;
  final MotivationModel? motivation;
  final ActionModel? action;

  HappinessPackModel({
    required this.feelingId,
    required this.generatedAt,
    required this.joke,
    required this.motivation,
    required this.action,
  });

  factory HappinessPackModel.fromJson(Map<String, dynamic> json) {
    return HappinessPackModel(
      feelingId: json['feeling_id']?.toString() ?? '',
      generatedAt: DateTime.parse(json['generated_at'] ?? ''),
      joke: json['joke'] != null ? JokeModel.fromJson(json['joke']) : null,
      motivation: json['motivation'] != null
          ? MotivationModel.fromJson(json['motivation'])
          : null,
      action:
          json['action'] != null ? ActionModel.fromJson(json['action']) : null,
    );
  }
}
