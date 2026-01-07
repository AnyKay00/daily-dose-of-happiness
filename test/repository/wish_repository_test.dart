import 'package:daily_dose_of_happiness/repository/wish_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockUser extends Mock implements User {}

class _MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

void main() {
  late _MockSupabaseClient supabase;
  late _MockGoTrueClient auth;
  late WishRepository repository;

  setUp(() {
    supabase = _MockSupabaseClient();
    auth = _MockGoTrueClient();
    when(() => supabase.auth).thenReturn(auth);
    repository = WishRepository(supabase);
  });

  group('loadMyVotesForWishIds', () {
    test('returns empty map when called with empty id list', () async {
      final result = await repository.loadMyVotesForWishIds([]);

      expect(result, isEmpty);
      verifyNever(() => supabase.from(any()));
    });

    test('throws when user is missing', () async {
      when(() => auth.currentUser).thenReturn(null);

      expect(
        () => repository.loadMyVotesForWishIds(['wish-42']),
        throwsException,
      );
    });
  });

  group('voteOnWish', () {
    test('throws when user missing even before validating value', () {
      when(() => auth.currentUser).thenReturn(null);

      expect(
        () => repository.voteOnWish('wish-1', 1),
        throwsException,
      );
    });

    test('wraps invalid values in repository exception', () async {
      final user = _MockUser();
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.id).thenReturn('uid-1');

      expect(
        () => repository.voteOnWish('wish-1', 0),
        throwsException,
      );
      verifyNever(() => supabase.from(any()));
    });
  });
}
