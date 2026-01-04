import 'dart:convert';
import 'package:daily_dose_of_happiness/model/dailys/happiness_package_model.dart';
import 'package:daily_dose_of_happiness/model/feeling_model.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeelingRepository {
  late APICacheManager _cacheManager;
  FeelingRepository(cachemanager) {
    _cacheManager = cachemanager;
  }
  Future<List<FeelingModel>> getAllFeelings() async {
    try {
      /* final session = Supabase.instance.client.auth.currentSession;
      print("session: ${session != null}");
      print("user: ${Supabase.instance.client.auth.currentUser?.id}"); */
      final response = await Supabase.instance.client
          .from('feeling')
          .select()
          .limit(9)
          .timeout(15.seconds);

      return (response as List<dynamic>)
          .map((json) => FeelingModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Datenbank-Fehler: ${e.message}');
    } catch (e) {
      throw Exception('Netzwerkfehler: $e');
    }
  }

  Future<HappinessPackModel?> loadHappinessPackage(
    String feelingId,
  ) async {
    try {
      String cacheString = await _cacheManager.read(actionK);
      if (cacheString.isEmpty) {
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

  Future<String?> sendDailyFeeling(String feelingId) async {
    print('feeling id');
    print(feelingId);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception(
            'No authenticated user. Ensure AuthService.init() ran.');
      }
      final profile = await Supabase.instance.client
          .from('user_profile')
          .select('user_id')
          .eq('user_id', user.id)
          .single();
      final String userProfileId = profile['user_id'] as String;
      // Update not working yet!todo
      //2) Upsert: pro Tag genau ein Eintrag
      // Voraussetzung für sauberen Upsert:
      // - Spalte feeling_date (date) existiert
      // - Unique Index auf (user_profile_id, feeling_date) existiert
      print('user profiel id');
      print(userProfileId);
      await Supabase.instance.client.from('user_feelings').upsert(
        {
          'user_profile_id': userProfileId,
          'feeling_id': feelingId,
          'created_at':
              DateTime.now().toUtc().toIso8601String().substring(0, 10),
        },
        onConflict: 'user_profile_id,created_at',
      );
      return 'success';
    } on PostgrestException catch (e) {
      print('PostgrestException: ${e.message}');
      print('Details: ${e.details}');
      print('Hint: ${e.hint}');
      print('Code: ${e.code}');
      rethrow;
    } catch (e) {
      print('Unknown error: $e');
      rethrow;
    }
  }
}
