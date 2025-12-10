import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_event.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_state.dart';
import 'package:daily_dose_of_happiness/model/dailys/joke_model.dart';
import 'package:daily_dose_of_happiness/repository/joke_repository.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  JokeRepository repository;
  JokeBloc({required this.repository}) : super(LoadingJokeState()) {
    on<LoadJokeEvent>((event, emit) async {
      //set state to loading
      emit(LoadingJokeState());
      try {
        final response = JokeModel(
            id: 'id', joke: 'Was macht ein Keks unter einem Baum? Krümel');
        //await repository.loadDailyJoke();
        //set state to success
        if (response != null) {
          emit((LoadedJokeState(joke: response)));
        }
        //set state to fail
        else {
          emit(FailedLoadJokeState());
        }
      } catch (_) {
        //set state to fail
        emit(FailedLoadJokeState());
      }
    });

    on<SaveJokeToMemoryBookEvent>((event, emit) async {
      try {
        repository.saveJokeToMemoryBook(event.id);
      } catch (_) {
        // Optional: Du könntest hier einen neuen Zustand emitten, um einen Fehler beim Speichern anzuzeigen.
      }
    });
    on<LikeJokeEvent>((event, emit) async {
      try {
        repository.likeJokeToMemoryBook(event.id);
      } catch (_) {
        // Optional: Du könntest hier einen neuen Zustand emitten, um einen Fehler beim Speichern anzuzeigen.
      }
    });
  }
}
