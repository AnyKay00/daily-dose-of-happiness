class JokeModel {
  String joke;

  JokeModel({required this.joke});

  factory JokeModel.fromJson(Map<String, dynamic> json) {
    bool isSingle = true;
    if (json.containsKey('type') && json['type'] == 'single') {
      isSingle = false;
    }

    return JokeModel(
        joke: isSingle
            ? json['joke'].toString()
            : '${json['setup']}\n\n${json['delivery']}');
  }
}
