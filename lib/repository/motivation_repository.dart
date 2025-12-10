import 'dart:convert';
import 'package:daily_dose_of_happiness/model/dailys/motivation_model.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:http/http.dart';
import '../service/local_storage_manager.dart';

class MotivationRepository {
  final String _rootUrl = 'https://zenquotes.io/api/today';
  late APICacheManager _cacheManager;

  MotivationRepository(cachemanager) {
    _cacheManager = cachemanager;
  }

  //load daily zenquote motivation
  Future<MotivationModel?>? loadDailyMotivation() async {
    try {
      String cache = await _cacheManager.read(motivationK);
      if (cache == null) {
        Response response = await get(Uri.parse(_rootUrl),
            headers: {'Accept': 'application/json'});
        if (response.statusCode == 200) {
          Iterable body = jsonDecode(utf8.decode(response.bodyBytes));
          MotivationModel motivation = MotivationModel.fromJson(body.first);
          _cacheManager.write(motivationK, body.first);
          return motivation;
        } else {
          //TODO Errorclass zurückgeben?
          throw Exception('Failed to get motivation from zenquote');
        }
      } else {
        MotivationModel motivation =
            MotivationModel.fromJson(jsonDecode(cache));

        return motivation;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null; // better return Error class
    }
  }
}
