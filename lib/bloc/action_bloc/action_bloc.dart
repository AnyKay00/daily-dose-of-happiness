import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/action_bloc/action_event.dart';
import 'package:daily_dose_of_happiness/bloc/action_bloc/action_state.dart';
import 'package:daily_dose_of_happiness/repository/action_repository.dart';

class ActionBloc extends Bloc<ActionEvent, ActionState> {
  ActionRepository repository;
  ActionBloc({required this.repository}) : super(LoadingActionState()) {
    on<SaveActionToMemoryBookEvent>((event, emit) async {
      try {
        repository.saveActionToMemoryBook(event.id);
      } catch (_) {
        print('Error saving action to memory book');
      }
    });
    on<LikeActionEvent>((event, emit) async {
      try {
        repository.likeActionToMemoryBook(event.id);
      } catch (_) {
        print('Error saving action to memory book');
      }
    });
  }
}
