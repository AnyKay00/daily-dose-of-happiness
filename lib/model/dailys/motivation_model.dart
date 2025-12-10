class MotivationModel {
  String id;
  String text;
  String authorName;

  bool liked = false;
  bool saved = false;

  MotivationModel(
      {required this.id, required this.authorName, required this.text});

  factory MotivationModel.fromJson(Map<String, dynamic> json) {
    return MotivationModel(
        id: json['id']?.toString() ?? '',
        text: json['text']?.toString() ?? '',
        authorName: json['a'].toString());
  }
}
