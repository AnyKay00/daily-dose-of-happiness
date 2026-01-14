import 'package:daily_dose_of_happiness/model/memory_book/daily_entry_mb_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MemoryBookRepository {
  MemoryBookRepository(this._client);

  final SupabaseClient _client;

  Future<List<DailyEntryMB>> fetchLast7Days() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception(
            'No authenticated user. Ensure AuthService.init() ran. In MemoryBookRepository.');
      }
      final result = await _client.rpc(
        'get_memory_book_last_7_days',
        params: {'p_user_profile_id': user.id},
      );

      // result ist dynamisch, meist List<dynamic>
      final rows = (result as List).cast<Map<String, dynamic>>();
      print(result);
      return rows.map(DailyEntryMB.fromJson).toList();
    } on PostgrestException catch (e) {
      throw Exception('MemoryBook RPC failed: ${e.message}');
    } catch (e) {
      throw Exception('MemoryBook fetch failed: $e');
    }
  }
}
