import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_event.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_state.dart';
import 'package:daily_dose_of_happiness/repository/motivation_repository.dart';

class MotivationBloc extends Bloc<MotivationEvent, MotivationState> {
  MotivationRepository repository;
  MotivationBloc({required this.repository}) : super(LoadingMotivationState()) {
    on<SaveMotivationToMemoryBookEvent>((event, emit) async {
      try {
        repository.saveMotivationToMemoryBook(event.id);
      } catch (_) {
        print('Error saving motivation to memory book');
      }
    });
    on<LikeMotivationEvent>((event, emit) async {
      try {
        repository.likeMotivationToMemoryBook(event.id);
      } catch (_) {
        print('Error saving motivation to memory book');
      }
    });
  }
}
