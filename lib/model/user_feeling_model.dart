import 'package:daily_dose_of_happiness/model/feeling_model.dart';

class UserFeelingModel {
  String id;
  DateTime date;
  FeelingModel feeling;
  UserFeelingModel({
    required this.id,
    required this.date,
    required this.feeling,
  });
}
