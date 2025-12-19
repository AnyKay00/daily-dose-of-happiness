import 'dart:convert';
import 'package:daily_dose_of_happiness/model/dailys/action_model.dart';
import 'package:daily_dose_of_happiness/service/bloc_handler.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';

import 'package:http/http.dart';
import '../service/local_storage_manager.dart';

class ActionRepository {
  late APICacheManager _cacheManager;

  ActionRepository(cachemanager) {
    _cacheManager = cachemanager;
  }

  //load daily zenquote motivation
  Future<ActionModel?>? loadDailyAction() async {
    try {
      String cache = await _cacheManager.read(actionK);
      if (cache.isEmpty) {
        Response response =
            await get(Uri.parse(baseUrl), headers: buildHttpsHeader());
        if (response.statusCode == 200) {
          Iterable body = jsonDecode(utf8.decode(response.bodyBytes));
          ActionModel motivation = ActionModel.fromJson(body.first);
          _cacheManager.write(actionK, body.first.toString());
          return motivation;
        } else {
          throw Exception('Failed to get Action from zenquote');
        }
      } else {
        ActionModel motivation = ActionModel.fromJson(jsonDecode(cache));

        return motivation;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  void saveActionToMemoryBook(String actionId) async {
    String _baseUrl = baseUrl + '/action/save/$actionId/';
    try {
      Response response =
          await put(Uri.parse(_baseUrl), headers: buildHttpsHeader());
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  void likeActionToMemoryBook(String actionId) async {
    String _baseUrl = baseUrl + '/action/like/$actionId/';
    try {
      Response response =
          await put(Uri.parse(_baseUrl), headers: buildHttpsHeader());
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }
}
