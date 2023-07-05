import 'dart:convert';

import 'package:daily_dose_of_happiness/code/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/code/multi_url_api_manager.dart';
import 'package:daily_dose_of_happiness/model/joke_model.dart';
import 'package:http/http.dart';

class JokeRepository {
  APICacheManager jokeCacheManager = APICacheManager("joke");
  MultiUrlApiManager multiUrlManager = MultiUrlApiManager();
  JokeRepository() {
    multiUrlManager.addRoute('baseJokes', 'https://v2.jokeapi.dev/joke/Any?blacklistFlags=nsfw,racist,sexist,explicit');
    multiUrlManager.addRoute('dadJokes', 'https://icanhazdadjoke.com/');
  }
  Future<JokeModel?>? loadDailyJoke() async {
    //selected flags for blacklist: racist, nsfw, sexist,plicit
    final String? rootUrl =
        multiUrlManager.getRandomRoute();
    try {
        Map<String, dynamic>? cache = await jokeCacheManager.readFromFile();
        if (cache == null) {
          Response response = await get(Uri.parse(rootUrl!), headers: {'Accept': 'application/json'});
          if (response.statusCode == 200) {
            dynamic body = jsonDecode(utf8.decode(response.bodyBytes));
            JokeModel motivation = JokeModel.fromJson(body);
            jokeCacheManager.updateOrWriteToFile(body);

            return motivation;
          } else {
            //TODO Errorclass zurückgeben?
            throw Exception('Failed to get joke from jokeapi');
          }
      } else {
        JokeModel motivation = JokeModel.fromJson(cache);

        return motivation;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null; // better return Error class
    }
  }
}
