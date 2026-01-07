import 'dart:async';

import 'package:daily_dose_of_happiness/service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockAuthResponse extends Mock implements AuthResponse {}

class _MockUserResponse extends Mock implements UserResponse {}

class _MockUser extends Mock implements User {}

void main() {
  setUpAll(() {
    registerFallbackValue(UserAttributes());
  });

  group('AuthService.init', () {
    test('creates guest account when no session exists', () async {
      final supabase = _MockSupabaseClient();
      final auth = _MockGoTrueClient();
      final response = _MockAuthResponse();
      final user = _MockUser();
      final controller = StreamController<AuthState>.broadcast();
      var ensuredProfile = false;

      when(() => supabase.auth).thenReturn(auth);
      when(() => auth.currentUser).thenReturn(null);
      when(() => auth.onAuthStateChange).thenAnswer((_) => controller.stream);
      when(() => auth.signInAnonymously()).thenAnswer((_) async => response);
      when(() => response.user).thenReturn(user);
      when(() => user.id).thenReturn('guest-1');

      final service = AuthService(
        client: supabase,
        profileEnsurer: (id, {required isGuest}) async {
          ensuredProfile = true;
        },
      );
      await service.init();

      expect(service.currentUserId, 'guest-1');
      verify(() => auth.signInAnonymously()).called(1);
      expect(ensuredProfile, isTrue);

      await controller.close();
    });
  });

  group('AuthService.upgradeToEmailPassword', () {
    test('links credentials and marks profile as non guest', () async {
      final supabase = _MockSupabaseClient();
      final auth = _MockGoTrueClient();
      final response = _MockUserResponse();
      final user = _MockUser();
      final controller = StreamController<AuthState>.broadcast();
      var ensuredProfile = false;

      when(() => supabase.auth).thenReturn(auth);
      when(() => auth.onAuthStateChange).thenAnswer((_) => controller.stream);
      when(() => auth.updateUser(any())).thenAnswer((_) async => response);
      when(() => response.user).thenReturn(user);
      when(() => user.id).thenReturn('user-1');
      final service = AuthService(
        client: supabase,
        profileEnsurer: (id, {required isGuest}) async {
          ensuredProfile = !isGuest;
        },
      );
      await service.upgradeToEmailPassword(
        email: 'user@mail.com',
        password: 'secret',
      );

      verify(() => auth.updateUser(any())).called(1);
      expect(ensuredProfile, isTrue);

      await controller.close();
    });
  });
}
