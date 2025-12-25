class MotivationModel {
  String id;
  String shortId;
  String text;
  String authorName;

  bool liked = false;
  bool saved = false;

  MotivationModel(
      {required this.id,
      required this.authorName,
      required this.text,
      required this.shortId});

  factory MotivationModel.fromJson(Map<String, dynamic> json) {
    return MotivationModel(
        id: json['id']?.toString() ?? '',
        shortId: json['short_id']?.toString() ?? '',
        text: json['text']?.toString() ?? '',
        authorName: json['author']?.toString() ?? 'null');
  }
}
