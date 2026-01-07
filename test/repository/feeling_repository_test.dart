import 'dart:convert';

import 'package:daily_dose_of_happiness/repository/feeling_repository.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeCacheManager implements APICacheManager {
  final Map<String, String> _store = {};

  @override
  FlutterSecureStorage get storage => throw UnimplementedError();

  @override
  Future<String> read(String key) async => _store[key] ?? '';

  @override
  void write(String key, String value) {
    _store[key] = value;
  }

  @override
  void deleteAll() {
    _store.clear();
  }

  @override
  void deleteHapinessPack() {
    _store.remove(motivationK);
    _store.remove(jokeK);
    _store.remove(actionK);
  }

  @override
  void delete(String key) {
    _store.remove(key);
  }
}

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockUser extends Mock implements User {}

void main() {
  group('FeelingRepository.loadHappinessPackage', () {
    test('returns cached pack without calling RPC when cache is warm',
        () async {
      final cache = _FakeCacheManager();
      final client = _MockSupabaseClient();
      final repo = FeelingRepository(cache, client: client);
      final cached = {
        'feeling_id': 'feel-1',
        'generated_at': '2023-01-01T00:00:00.000Z',
        'joke': null,
        'motivation': null,
        'action': null,
      };
      cache.write(happinessPackK, jsonEncode(cached));

      final pack = await repo.loadHappinessPackage('feel-1');

      expect(pack, isNotNull);
      expect(pack!.feelingId, 'feel-1');
      verifyNever(() => client.rpc(any(), params: any(named: 'params')));
    });
  });

  group('FeelingRepository.sendDailyFeeling', () {
    test('throws when no authenticated user is available', () {
      final cache = _FakeCacheManager();
      final client = _MockSupabaseClient();
      final auth = _MockGoTrueClient();
      when(() => client.auth).thenReturn(auth);
      when(() => auth.currentUser).thenReturn(null);
      final repo = FeelingRepository(cache, client: client);

      expect(
        () => repo.sendDailyFeeling('feel-1'),
        throwsException,
      );
    });
  });
}
