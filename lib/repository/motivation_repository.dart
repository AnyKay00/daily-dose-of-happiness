import 'dart:convert';

import 'package:daily_dose_of_happiness/model/motivation_model.dart';
import 'package:http/http.dart';

import '../code/local_storage_manager.dart';

class MotivationRepository {
  final String _rootUrl = 'https://zenquotes.io/api/today';  
  APICacheManager _cacheManager = APICacheManager("motivation");
  //load daily zenquote motivation
  Future<MotivationModel?>? loadDailyMotivation() async {
    try {
      Map<String, dynamic>? cache = await _cacheManager.readFromFile();
      if (cache == null) {
        Response response = await get(Uri.parse(_rootUrl), headers: {'Accept': 'application/json'});
        if (response.statusCode == 200) {
          Iterable body = jsonDecode(utf8.decode(response.bodyBytes));
          MotivationModel motivation = MotivationModel.fromJson(body.first);
          _cacheManager.updateOrWriteToFile(body.first);
          return motivation;
        } else {
          //TODO Errorclass zurückgeben?
          throw Exception('Failed to get motivation from zenquote');
        }
      } else {
        MotivationModel motivation = MotivationModel.fromJson(cache);

        return motivation;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null; // better return Error class
  }
  }
}
