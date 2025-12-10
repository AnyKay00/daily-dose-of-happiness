import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_event.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_state.dart';
import 'package:daily_dose_of_happiness/repository/feeling_repository.dart';

class FeelingBloc extends Bloc<FeelingEvent, FeelingState> {
  FeelingRepository repository;
  FeelingBloc({required this.repository}) : super(InitFeelingState()) {
    on<SendDailyFeelingsEvent>((event, emit) async {
      //set state to loading
      emit(LoadingFeelingState());
      try {
        final response = await repository.sendDailyFeeling(event.feelingId);
        //set state to success
        if (response != null) {
          emit(SuccessfullFeelingState());
        }
        //set state to fail
        else {
          emit(FailedLoadFeelingState());
        }
      } catch (_) {
        //set state to fail
        emit(FailedLoadFeelingState());
      }
    });
  }
}
