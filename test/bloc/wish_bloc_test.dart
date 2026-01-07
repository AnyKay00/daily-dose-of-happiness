import 'package:bloc_test/bloc_test.dart';
import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_event.dart';
import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_state.dart';
import 'package:daily_dose_of_happiness/model/wish/wish_comment_model.dart';
import 'package:daily_dose_of_happiness/model/wish/wish_model.dart';
import 'package:daily_dose_of_happiness/repository/wish_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockWishRepository extends Mock implements WishRepository {}

WishModel _fakeWish() => WishModel(
      id: 'id-1',
      body: 'body',
      status: 'open',
      score: 0,
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023, 1, 2),
      isMine: false,
    );

WishCommentModel _fakeComment() => WishCommentModel(
      id: 'c-1',
      wishId: 'id-1',
      body: 'comment',
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023, 1, 2),
      isMine: true,
    );

void main() {
  late _MockWishRepository repository;

  setUp(() {
    repository = _MockWishRepository();
  });

  group('WishBloc', () {
    blocTest<WishBloc, WishState>(
      'emits success when WishCreateRequested succeeds',
      build: () {
        when(() => repository.createWish(any())).thenAnswer((_) async => _fakeWish());
        return WishBloc(repo: repository);
      },
      act: (bloc) => bloc.add(WishCreateRequested('body')),
      expect: () => [
        isA<WishActionInProgress>(),
        isA<WishActionSuccess>(),
      ],
    );

    blocTest<WishBloc, WishState>(
      'emits error when WishCreateRequested fails',
      build: () {
        when(() => repository.createWish(any())).thenThrow(Exception('fail'));
        return WishBloc(repo: repository);
      },
      act: (bloc) => bloc.add(WishCreateRequested('body')),
      expect: () => [
        isA<WishActionInProgress>(),
        isA<WishActionError>(),
      ],
    );

    blocTest<WishBloc, WishState>(
      'emits loaded comments when WishCommentsLoadRequested succeeds',
      build: () {
        when(() => repository.loadComments(any())).thenAnswer((_) async => [_fakeComment()]);
        return WishBloc(repo: repository);
      },
      act: (bloc) => bloc.add(WishCommentsLoadRequested('id-1')),
      expect: () => [
        isA<WishActionInProgress>(),
        isA<WishCommentsLoaded>(),
      ],
    );

    blocTest<WishBloc, WishState>(
      'emits error when load comments fails',
      build: () {
        when(() => repository.loadComments(any())).thenThrow(Exception('boom'));
        return WishBloc(repo: repository);
      },
      act: (bloc) => bloc.add(WishCommentsLoadRequested('id-1')),
      expect: () => [
        isA<WishActionInProgress>(),
        isA<WishActionError>(),
      ],
    );
  });
}
