class JokeModel {
  String joke;

  JokeModel({required this.joke});

  factory JokeModel.fromJson(Map<String, dynamic> json) {
    bool _isSingle = true;
    if (json.containsKey('type') && json['type'] == 'single') {
      _isSingle = false;
    }

    return JokeModel(
        joke: _isSingle
            ? json['joke'].toString()
            : json['setup'].toString() + '\n\n' + json['delivery'].toString());
  }
}
