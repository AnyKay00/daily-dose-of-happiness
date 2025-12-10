import 'dart:convert';
import 'package:daily_dose_of_happiness/model/dailys/action_model.dart';
import 'package:http/http.dart';
import '../service/local_storage_manager.dart';

class ActionRepository {
  final String _rootUrl = 'https://zenquotes.io/api/today';
  final APICacheManager _cacheManager = APICacheManager("action");
  //load daily zenquote motivation
  Future<ActionModel?>? loadDailyAction() async {
    try {
      Map<String, dynamic>? cache = await _cacheManager.readFromFile();
      if (cache == null) {
        Response response = await get(Uri.parse(_rootUrl),
            headers: {'Accept': 'application/json'});
        if (response.statusCode == 200) {
          Iterable body = jsonDecode(utf8.decode(response.bodyBytes));
          ActionModel motivation = ActionModel.fromJson(body.first);
          _cacheManager.updateOrWriteToFile(body.first);
          return motivation;
        } else {
          //TODO Errorclass zurückgeben?
          throw Exception('Failed to get Action from zenquote');
        }
      } else {
        ActionModel motivation = ActionModel.fromJson(cache);

        return motivation;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null; // better return Error class
    }
  }
}
