import 'dart:convert';
import 'package:daily_dose_of_happiness/service/bloc_handler.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/model/dailys/joke_model.dart';
import 'package:http/http.dart';

class JokeRepository {
  late APICacheManager jokeCacheManager;

  JokeRepository(cachemanager) {
    jokeCacheManager = cachemanager;
  }

  Future<JokeModel?>? loadDailyJoke() async {
    //selected flags for blacklist: racist, nsfw, sexist,plicit
    final String? rootUrl = baseUrl + '/rest/v1/joke';
    try {
      String cache = await jokeCacheManager.read(jokeK);
      if (cache.isEmpty) {
        Response response =
            await get(Uri.parse(rootUrl!), headers: buildHttpsHeader());
        if (response.statusCode == 200) {
          dynamic body = jsonDecode(utf8.decode(response.bodyBytes));
          JokeModel motivation = JokeModel.fromJson(body);
          jokeCacheManager.write(jokeK, jsonEncode(body));

          return motivation;
        } else {
          throw Exception('Failed to get joke from api');
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
    String _baseUrl = baseUrl + '/joke/save/$id/';
    try {
      Response response =
          await put(Uri.parse(_baseUrl), headers: buildHttpsHeader());
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  void likeJokeToMemoryBook(String id) async {
    String _baseUrl = baseUrl + '/joke/like/$id/';
    try {
      Response response =
          await put(Uri.parse(_baseUrl), headers: buildHttpsHeader());
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }
}
