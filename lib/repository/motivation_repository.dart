import 'dart:convert';

import 'package:daily_dose_of_happiness/model/motivation_model.dart';
import 'package:http/http.dart';

class MotivationRepository {
  final String _rootUrl = 'https://zenquotes.io/api/today';

  //load daily zenquote motivation
  Future<MotivationModel?>? loadDailyMotivation() async {
    try {
      Response response = await get(Uri.parse(_rootUrl));
      if (response.statusCode == 200) {
        Iterable body = jsonDecode(utf8.decode(response.bodyBytes));
        MotivationModel motivation = MotivationModel.fromJson(body.first);

        return motivation;
      } else {
        //TODO Errorclass zurückgeben?
        throw Exception('Failed to get motivation from zenquote');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null; // better return Error class
    }
  }
}
