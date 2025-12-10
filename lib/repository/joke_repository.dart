import 'dart:convert';

import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/service/multi_url_api_manager.dart';
import 'package:daily_dose_of_happiness/model/dailys/joke_model.dart';
import 'package:http/http.dart';

class JokeRepository {
  late APICacheManager jokeCacheManager;
  final String _rootUrl = 'https:/...';

  MultiUrlApiManager multiUrlManager = MultiUrlApiManager();

  JokeRepository(cachemanager) {
    multiUrlManager.addRoute('baseJokes',
        'https://v2.jokeapi.dev/joke/Any?blacklistFlags=nsfw,racist,sexist,explicit');
    multiUrlManager.addRoute('dadJokes', 'https://icanhazdadjoke.com/');
    jokeCacheManager = cachemanager;
  }

  Future<JokeModel?>? loadDailyJoke() async {
    //selected flags for blacklist: racist, nsfw, sexist,plicit
    final String? rootUrl = multiUrlManager.getRandomRoute();
    try {
      String cache = await jokeCacheManager.read(jokeK);
      if (cache == null) {
        Response response = await get(Uri.parse(rootUrl!),
            headers: {'Accept': 'application/json'});
        if (response.statusCode == 200) {
          dynamic body = jsonDecode(utf8.decode(response.bodyBytes));
          JokeModel motivation = JokeModel.fromJson(body);
          jokeCacheManager.write(jokeK, body.toString());

          return motivation;
        } else {
          //TODO Errorclass zurückgeben?
          throw Exception('Failed to get joke from jokeapi');
        }
      } else {
        JokeModel motivation = JokeModel.fromJson(jsonDecode(cache));

        return motivation;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null; // better return Error class
    }
  }

  void saveJokeToMemoryBook(String id) async {
    String _baseUrl = _rootUrl + '/joke/save/$id/';
    try {
      Response response = await put(Uri.parse(_baseUrl),
          headers: {'Accept': 'application/json'});
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  void likeJokeToMemoryBook(String id) async {
    String _baseUrl = _rootUrl + '/joke/like/$id/';
    try {
      Response response = await put(Uri.parse(_baseUrl),
          headers: {'Accept': 'application/json'});
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }
}
