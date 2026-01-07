import 'package:bloc_test/bloc_test.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_event.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_state.dart';
import 'package:daily_dose_of_happiness/repository/feeling_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFeelingRepository extends Mock implements FeelingRepository {}

void main() {
  late _MockFeelingRepository repository;

  setUp(() {
    repository = _MockFeelingRepository();
  });

  group('FeelingBloc', () {
    blocTest<FeelingBloc, FeelingState>(
      'emits success when repository acknowledges daily feeling',
      build: () {
        when(() => repository.sendDailyFeeling(any()))
            .thenAnswer((_) async => 'success');
        return FeelingBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const SendDailyFeelingEvent(feelingId: 'feel-1')),
      expect: () => [
        isA<LoadingFeelingState>(),
        isA<SuccessfullFeelingState>(),
      ],
    );

    blocTest<FeelingBloc, FeelingState>(
      'emits failure when repository throws',
      build: () {
        when(() => repository.sendDailyFeeling(any()))
            .thenThrow(Exception('boom'));
        return FeelingBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const SendDailyFeelingEvent(feelingId: 'feel-1')),
      expect: () => [
        isA<LoadingFeelingState>(),
        isA<FailedLoadFeelingState>(),
      ],
    );
  });
}
