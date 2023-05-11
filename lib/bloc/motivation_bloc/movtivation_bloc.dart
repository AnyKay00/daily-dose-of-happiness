import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_event.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_state.dart';
import 'package:daily_dose_of_happiness/repository/motivation_repository.dart';

class MotivationBloc extends Bloc<MotivationEvent, MotivationState> {
  MotivationRepository repository;
  MotivationBloc({required this.repository}) : super(LoadingMotivationState()) {
    //overrides event handler - on function, one handler per event
    on<LoadMotivationEvent>((event, emit) async {
      //set state to loading
      emit(LoadingMotivationState());
      try {
        final response = await repository.loadDailyMotivation();
        //set state to success
        if (response != null) {
          emit((LoadedMotivationState(motivation: [response])));
        }
        //set state to fail
        else {
          emit(FailedLoadMotivationState());
        }
      } catch (_) {
        //set state to fail
        emit(FailedLoadMotivationState());
      }
    });
  }
}
