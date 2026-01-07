import 'package:bloc_test/bloc_test.dart';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_event.dart';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_state.dart';
import 'package:daily_dose_of_happiness/model/dailys/happiness_package_model.dart';
import 'package:daily_dose_of_happiness/repository/feeling_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFeelingRepository extends Mock implements FeelingRepository {}

HappinessPackModel _fakePack() => HappinessPackModel(
      feelingId: 'feel-1',
      generatedAt: DateTime(2023),
      joke: null,
      motivation: null,
      action: null,
    );

void main() {
  late _MockFeelingRepository repository;

  setUp(() {
    repository = _MockFeelingRepository();
  });

  group('HappinessPackBloc', () {
    blocTest<HappinessPackBloc, HappinessPackState>(
      'emits LoadedHappinessPackState when repository returns a pack',
      build: () {
        when(() => repository.loadHappinessPackage(any()))
            .thenAnswer((_) async => _fakePack());
        return HappinessPackBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const LoadHappinessPackOfFeelingEvent(feelingId: 'feel-1')),
      expect: () => [
        isA<LoadingHappinessPackState>(),
        isA<LoadedHappinessPackState>(),
      ],
    );

    blocTest<HappinessPackBloc, HappinessPackState>(
      'emits failure state when repository returns null',
      build: () {
        when(() => repository.loadHappinessPackage(any()))
            .thenAnswer((_) async => null);
        return HappinessPackBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const LoadHappinessPackOfFeelingEvent(feelingId: 'feel-1')),
      expect: () => [
        isA<LoadingHappinessPackState>(),
        isA<FailedLoadHappinessPackState>(),
      ],
    );

    blocTest<HappinessPackBloc, HappinessPackState>(
      'emits failure state when repository throws',
      build: () {
        when(() => repository.loadHappinessPackage(any()))
            .thenThrow(Exception('network'));
        return HappinessPackBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const LoadHappinessPackOfFeelingEvent(feelingId: 'feel-1')),
      expect: () => [
        isA<LoadingHappinessPackState>(),
        isA<FailedLoadHappinessPackState>(),
      ],
    );
  });
}
