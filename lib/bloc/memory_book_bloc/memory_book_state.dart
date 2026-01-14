import 'package:daily_dose_of_happiness/model/memory_book/daily_entry_mb_model.dart';

sealed class MemoryBookState {}

class MemoryBookInitial extends MemoryBookState {}

class LoadingMemoryBookState extends MemoryBookState {}

class EmptyMemoryBookState extends MemoryBookState {}

class LoadedLast7DaysFeelingsMemoryBookState extends MemoryBookState {
  final List<DailyEntryMB> entries;
  LoadedLast7DaysFeelingsMemoryBookState(this.entries);
}

class MemoryBookErrorState extends MemoryBookState {
  final String message;
  MemoryBookErrorState(this.message);
}
