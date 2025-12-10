import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_lisT_state.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_event.dart';
import 'package:daily_dose_of_happiness/repository/feeling_repository.dart';

class FeelingListBloc extends Bloc<FeelingListEvent, FeelingListState> {
  FeelingRepository repository;
  FeelingListBloc({required this.repository}) : super(InitFeelingListState()) {
    //overrides event handler - on function, one handler per event
    on<LoadFeelingsEvent>((event, emit) async {
      //set state to loading
      emit(LoadingFeelingListState());
      try {
        final response = await repository.loadFeelings();
        //set state to success
        if (response != null) {
          emit((LoadedFeelingListState(feelings: response)));
        }
        //set state to fail
        else {
          emit(FailedLoadFeelingListState());
        }
      } catch (_) {
        //set state to fail
        emit(FailedLoadFeelingListState());
      }
    });
  }
}
