import 'dart:convert';

import 'package:daily_dose_of_happiness/model/joke_model.dart';
import 'package:http/http.dart';

class JokeRepository {
  Future<JokeModel?>? loadDailyJoke() async {
    //selected flags for blacklist: racist, nsfw, sexist,plicit
    const String _rootUrl =
        'https://v2.jokeapi.dev/joke/Any?blacklistFlags=nsfw,racist,sexist,explicit';
    try {
      Response response = await get(Uri.parse(_rootUrl));
      if (response.statusCode == 200) {
        dynamic body = jsonDecode(utf8.decode(response.bodyBytes));
        JokeModel motivation = JokeModel.fromJson(body);

        return motivation;
      } else {
        //TODO Errorclass zurückgeben?
        throw Exception('Failed to get joke from jokeapi');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null; // better return Error class
    }
  }
}
