import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
/*
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
 */

typedef ProfileEnsurer = Future<void> Function(
  String userId, {
  required bool isGuest,
});

class AuthService extends ChangeNotifier {
  final SupabaseClient supabase;
  final ProfileEnsurer? profileEnsurer;

  AuthService({SupabaseClient? client, this.profileEnsurer})
      : supabase = client ?? Supabase.instance.client;

  String? _currentUserId;
  String? get currentUserId => _currentUserId;

  StreamSubscription<AuthState>? _authSub;

  Future<void> init() async {
    // 1) Setze initial aus ggf. bereits persistierter Session
    _currentUserId = supabase.auth.currentUser?.id;

    // 2) Subscribe auf Auth-Änderungen (Token refresh, SignOut etc.)
    _authSub?.cancel();
    _authSub = supabase.auth.onAuthStateChange.listen((data) {
      _currentUserId = data.session?.user.id;
      notifyListeners();
    });
    // 3) Wenn noch kein User existiert, erstelle Guest/Anonymous User
    if (_currentUserId == null) {
      await _createGuestUser();
    } else {
      // Optional: user_profile sicherstellen
      await _ensureProfile(_currentUserId!, isGuest: true);
    }

    notifyListeners();
  }

  Future<void> _createGuestUser() async {
    final res = await supabase.auth.signInAnonymously();
  
    final user = res.user;
    if (user == null) {
      throw Exception('Anonymous sign-in failed: user is null');
    }

    _currentUserId = user.id;

    // Optional (wenn kein Trigger existiert): user_profile upsert
    await _ensureProfile(user.id, isGuest: true);
  }

  Future<void> _ensureProfile(String userId,
      {required bool isGuest}) async {
    if (profileEnsurer != null) {
      await profileEnsurer!(userId, isGuest: isGuest);
      return;
    }
    await _ensureUserProfile(userId, isGuest: isGuest);
  }

  Future<void> _ensureUserProfile(String userId,
      {required bool isGuest}) async {
    // Wenn du DB-Trigger nutzt, kann dieser Block entfallen.
    await supabase.from('user_profile').upsert(
      {
        'user_id': userId,
        'is_guest': isGuest,
      },
      onConflict: 'user_id',
    );
  }

  /// Optional: später Account upgraden (Email/Passwort)
  Future<void> upgradeToEmailPassword({
    required String email,
    required String password,
  }) async {
    // Je nach gewünschtem Flow: signUp oder updateUser.
    // Für anonyme User kann man häufig ein "linking" via updateUser machen.
    final res = await supabase.auth.updateUser(
      UserAttributes(email: email, password: password),
    );

    if (res.user == null) {
      throw Exception('Upgrade failed: user is null');
    }

    _currentUserId = res.user!.id;
    await _ensureProfile(_currentUserId!, isGuest: false);

    notifyListeners();
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    _currentUserId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
