import 'package:daily_dose_of_happiness/bloc/wish_list_bloc/wish_list_event.dart';
import 'package:daily_dose_of_happiness/bloc/wish_list_bloc/wish_list_state.dart';
import 'package:daily_dose_of_happiness/repository/wish_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  final WishRepository repo;

  WishListBloc({required this.repo}) : super(WishListInitial()) {
    on<LoadWishesEvent>((event, emit) async {
      emit(WishListLoading());
      try {
        final wishes = await repo.loadWishes();

        if (wishes.isEmpty) {
          emit(EmptyWishList());
        } else {
          emit(WishListLoaded(wishes));
        }
      } catch (e) {
        emit(WishListError(e.toString()));
      }
    });
  }
}
