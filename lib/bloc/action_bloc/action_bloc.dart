import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/action_bloc/action_event.dart';
import 'package:daily_dose_of_happiness/bloc/action_bloc/action_state.dart';
import 'package:daily_dose_of_happiness/repository/action_repository.dart';

class ActionBloc extends Bloc<ActionEvent, ActionState> {
  ActionRepository repository;
  ActionBloc({required this.repository}) : super(LoadingActionState()) {
    //overrides event handler - on function, one handler per event
    on<LoadActionEvent>((event, emit) async {
      //set state to loading
      emit(LoadingActionState());
      try {
        final response = await repository.loadDailyAction();
        //set state to success
        if (response != null) {
          emit((LoadedActionState(action: response)));
        }
        //set state to fail
        else {
          emit(FailedLoadActionState());
        }
      } catch (_) {
        //set state to fail
        emit(FailedLoadActionState());
      }
    });
  }
}
