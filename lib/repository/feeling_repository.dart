import 'dart:convert';
import 'package:daily_dose_of_happiness/model/dailys/happiness_package_model.dart';
import 'package:daily_dose_of_happiness/model/feeling_model.dart';
import 'package:daily_dose_of_happiness/service/bloc_handler.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeelingRepository {
  late APICacheManager _cacheManager;
  FeelingRepository(cachemanager) {
    _cacheManager = cachemanager;
  }
  Future<List<FeelingModel>?>? loadFeelings() async {
    try {
      Response response =
          await get(Uri.parse(baseUrl), headers: buildHttpsHeader());
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

  Future<HappinessPackModel?> loadHappinessPackage(
    String feelingId,
  ) async {
    try {
      String cacheString = await _cacheManager.read(actionK);
      if (cacheString.isEmpty ) {
        final response = await Supabase.instance.client.rpc(
          'build_happiness_package',
          params: {'p_feeling_id': feelingId},
        );

        if (response == null) {
          throw Exception('Empty happiness package response');
        }

        final Map<String, dynamic> body =
            Map<String, dynamic>.from(response as Map);

        //write it all to cache
        _cacheManager.write(happinessPackK, jsonEncode(body));

        return HappinessPackModel.fromJson(body);
      } else {
        HappinessPackModel pack =
            HappinessPackModel.fromJson(jsonDecode(cacheString));

        return pack;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  Future sendDailyFeeling(String feelingId) async {
    /*  String _baseUrl = '${baseUrl}feelings/set-daily/$feelingId/';

    try {
      Response response = await put(Uri.parse(_baseUrl),
          headers: buildHttpsHeader());
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
