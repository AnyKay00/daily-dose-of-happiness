import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_event.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_state.dart';
import 'package:daily_dose_of_happiness/model/dailys/motivation_model.dart';
import 'package:daily_dose_of_happiness/repository/motivation_repository.dart';

class MotivationBloc extends Bloc<MotivationEvent, MotivationState> {
  MotivationRepository repository;
  MotivationBloc({required this.repository}) : super(LoadingMotivationState()) {
    //overrides event handler - on function, one handler per event
    on<LoadMotivationEvent>((event, emit) async {
      //set state to loading
      emit(LoadingMotivationState());
      try {
        final response =
            MotivationModel(id: 'id', authorName: 'Me', text: 'Be strong');
        //await repository.loadDailyMotivation();
        //set state to success
        if (response != null) {
          emit((LoadedMotivationState(motivation: response)));
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
    on<SaveMotivationToMemoryBookEvent>((event, emit) async {
      try {
        repository.saveMotivationToMemoryBook(event.id);
      } catch (_) {
        // Optional: Du könntest hier einen neuen Zustand emitten, um einen Fehler beim Speichern anzuzeigen.
      }
    });
    on<LikeMotivationEvent>((event, emit) async {
      try {
        repository.likeMotivationToMemoryBook(event.id);
      } catch (_) {
        // Optional: Du könntest hier einen neuen Zustand emitten, um einen Fehler beim Speichern anzuzeigen.
      }
    });
  }
}
