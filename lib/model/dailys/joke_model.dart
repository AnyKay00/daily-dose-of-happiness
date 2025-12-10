class JokeModel {
  String id;
  String joke;

  bool liked = false;
  bool saved = false;

  JokeModel({required this.id, required this.joke});

  factory JokeModel.fromJson(Map<String, dynamic> json) {
    return JokeModel(
        id: json['id']?.toString() ?? '', joke: json['joke']?.toString() ?? '');
  }
}
