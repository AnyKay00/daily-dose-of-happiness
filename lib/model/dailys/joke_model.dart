class JokeModel {
  String id;
  String shortId;
  String jokeText;

  bool liked = false;
  bool saved = false;

  JokeModel({required this.id, required this.jokeText, required this.shortId});

  factory JokeModel.fromJson(Map<String, dynamic> json) {
    return JokeModel(
        id: json['id']?.toString() ?? '',
        shortId: json['short_id']?.toString() ?? '',
        jokeText: json['text']?.toString() ?? '');
  }
}
