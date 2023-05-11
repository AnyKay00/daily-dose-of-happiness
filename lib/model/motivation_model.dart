class MotivationModel {
  String text;
  bool authorName;

  MotivationModel({required this.authorName, required this.text});

  factory MotivationModel.fromJson(Map<String, dynamic> json) {
    return MotivationModel(
        text: json['id'].toString(), authorName: json['is_correct'] as bool);
  }
}
