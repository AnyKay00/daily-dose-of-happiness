import 'dart:convert';
import 'package:daily_dose_of_happiness/model/feeling_model.dart';
import 'package:http/http.dart';

class FeelingRepository {
  final String _rootUrl = '...';

  Future<List<FeelingModel>?>? loadFeelings() async {
    try {
      Response response = await get(Uri.parse(_rootUrl),
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        Iterable body = jsonDecode(utf8.decode(response.bodyBytes));
        List<FeelingModel> feelings =
            body.map((obj) => FeelingModel.fromJson(obj)).toList();
        return feelings;
      } else {
        throw Exception('Failed to get feelings from server');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  Future sendDailyFeeling(String feelingId) async {
    /*  String baseUrl = '${_rootUrl}feelings/set-daily/$feelingId/';

    try {
      Response response = await put(Uri.parse(_rootUrl),
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        Iterable body = jsonDecode(utf8.decode(response.bodyBytes));
        List<FeelingModel> feelings =
            body.map((obj) => FeelingModel.fromJson(obj)).toList();
        return feelings;
      } else {
        throw Exception('Failed to get feelings from server');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    } */
  }
}
