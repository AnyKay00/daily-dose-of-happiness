import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_event.dart';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_state.dart';
import 'package:daily_dose_of_happiness/repository/feeling_repository.dart';

class HappinessPackBloc extends Bloc<HappinessPackEvent, HappinessPackState> {
  FeelingRepository repository;

  HappinessPackBloc({required this.repository})
      : super(InitHappinessPackState()) {
    on<GetHappinessPackOfFeelingEvent>((event, emit) async {
      //set state to loading
      emit(LoadingHappinessPackState());
      try {
        final response = await repository.loadHappinessPackage(event.feelingId);
        //set state to success
        if (response != null) {
          emit(LoadedHappinessPackState(pack: response));
        }
        //set state to fail
        else {
          emit(FailedLoadHappinessPackState());
        }
      } catch (_) {
        //set state to fail
        emit(FailedLoadHappinessPackState());
      }
    });
  }
}
