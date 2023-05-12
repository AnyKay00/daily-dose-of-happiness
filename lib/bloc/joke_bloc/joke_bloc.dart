import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_event.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_state.dart';
import 'package:daily_dose_of_happiness/repository/joke_repository.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  JokeRepository repository;
  JokeBloc({required this.repository}) : super(LoadingJokeState()) {
    //overrides event handler - on function, one handler per event
    on<LoadJokeEvent>((event, emit) async {
      //set state to loading
      emit(LoadingJokeState());
      try {
        final response = await repository.loadDailyJoke();
        //set state to success
        if (response != null) {
          emit((LoadedJokeState(joke: [response])));
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
  }
}
