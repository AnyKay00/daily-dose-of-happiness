import 'dart:convert';
import 'package:daily_dose_of_happiness/model/dailys/motivation_model.dart';
import 'package:daily_dose_of_happiness/service/bloc_handler.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:http/http.dart';
import '../service/local_storage_manager.dart';

class MotivationRepository {
  late APICacheManager _cacheManager;

  MotivationRepository(cachemanager) {
    _cacheManager = cachemanager;
  }

  //load daily zenquote motivation
  Future<MotivationModel?>? loadDailyMotivation() async {
    String _baseUrl = baseUrl + '/rest/v1/motivation/';
    try {
      String cache = await _cacheManager.read(motivationK);
      if (cache.isEmpty) {
        Response response =
            await get(Uri.parse(_baseUrl), headers: buildHttpsHeader());
        if (response.statusCode == 200) {
          Iterable body = jsonDecode(utf8.decode(response.bodyBytes));
          MotivationModel motivation = MotivationModel.fromJson(body.first);
          _cacheManager.write(motivationK, body.first);
          return motivation;
        } else {
          throw Exception('Failed to get motivation from api');
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

  void saveMotivationToMemoryBook(String id) async {
    String _baseUrl = '$baseUrl/motivation/save/$id/';
    try {
      await put(Uri.parse(_baseUrl), headers: buildHttpsHeader());
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  void likeMotivationToMemoryBook(String id) async {
    String _baseUrl = baseUrl + '/motivation/like/$id/';
    try {
      Response response =
          await put(Uri.parse(_baseUrl), headers: buildHttpsHeader());
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }
}
