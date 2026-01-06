import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_event.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_state.dart';
import 'package:daily_dose_of_happiness/repository/joke_repository.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  JokeRepository repository;
  JokeBloc({required this.repository}) : super(LoadingJokeState()) {
    on<SaveJokeToMemoryBookEvent>((event, emit) async {
      try {
        repository.saveJokeToMemoryBook(event.id);
      } catch (_) {
        print('Error saving joke to memory book');
      }
    });
    on<LikeJokeEvent>((event, emit) async {
      try {
        repository.likeJokeToMemoryBook(event.id);
      } catch (_) {
        print('Error saving joke to memory book');
      }
    });
  }
}
