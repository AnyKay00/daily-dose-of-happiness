import 'dart:convert';
import 'package:daily_dose_of_happiness/service/bloc_handler.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService(this._cache) {
    currentUserId = null;
  }

  final APICacheManager _cache;
  static const String _guestIdKey = 'guest_id';

  String? currentUserId;

  // Supabase-Konfiguration
  final String _supabaseUrl = baseUrl;
  final String _supabaseApiKey = apiKey;
  static const String _guestTableName = 'profile/';

  /// Factory Init – falls du intial logic brauchst
  static Future<AuthService> init() async {
    final cache = APICacheManager();
    final service = AuthService(cache);
    final id = await service.readGuestId();
    if (id.isNotEmpty) service.currentUserId = id;
    return service;
  }

  // -------------------------------------------------------------
  // 1) Guest User via Supabase REST anlegen
  // -------------------------------------------------------------
  Future<String> createGuestUser() async {
    final uri = Uri.parse('$_supabaseUrl/rest/v1/$_guestTableName');

    final response = await http.post(
      uri,
      headers: {
        'apikey': _supabaseApiKey,
        'Authorization': 'Bearer $_supabaseApiKey',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      },
      body: jsonEncode({}), // falls du Felder brauchst: hier ergänzen
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Failed to create guest user: ${response.statusCode}\n${response.body}',
      );
    }

    final List<dynamic> jsonList = jsonDecode(response.body);

    if (jsonList.isEmpty || jsonList.first['id'] == null) {
      throw Exception('Guest user created but no id returned.');
    }

    final String guestId = jsonList.first['id'];

    await writeGuestId(guestId);

    return guestId;
  }

  Future<String> readGuestId() async {
    final id = await _cache.read(_guestIdKey);
    currentUserId = id.isNotEmpty ? id : null;
    return id;
  }

  Future<void> writeGuestId(String id) async {
    currentUserId = id;
    _cache.write(_guestIdKey, id);
  }
}
