import 'package:daily_dose_of_happiness/bloc/wish_list_bloc/wish_list_event.dart';
import 'package:daily_dose_of_happiness/bloc/wish_list_bloc/wish_list_state.dart';
import 'package:daily_dose_of_happiness/repository/wish_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  final WishRepository repo;

  WishListBloc({required this.repo}) : super(WishListInitial()) {
    on<WishListLoadRequested>((event, emit) async {
      emit(WishListLoading());
      try {
        final wishes = await repo.loadWishes();
        emit(WishListLoaded(wishes));
      } catch (e) {
        emit(WishListError(e.toString()));
      }
    });
  }
}
