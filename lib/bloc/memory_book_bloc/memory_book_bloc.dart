import 'package:daily_dose_of_happiness/bloc/memory_book_bloc/memory_book_event.dart';
import 'package:daily_dose_of_happiness/bloc/memory_book_bloc/memory_book_state.dart';
import 'package:daily_dose_of_happiness/repository/memory_book_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemoryBookBloc extends Bloc<MemoryBookEvent, MemoryBookState> {
  final MemoryBookRepository repo;

  MemoryBookBloc({required this.repo}) : super(MemoryBookInitial()) {
    on<LoadLast7DaysFeelingsEvent>((event, emit) async {
      emit(LoadingMemoryBookState());
      try {
        final entries = await repo.fetchLast7Days();

        if (entries.isEmpty) {
          emit(EmptyMemoryBookState());
        } else {
          emit(LoadedLast7DaysFeelingsMemoryBookState(entries));
        }
      } catch (e) {
        emit(MemoryBookErrorState(e.toString()));
      }
    });
  }
}
