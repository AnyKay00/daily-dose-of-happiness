import 'package:daily_dose_of_happiness/model/wish/wish_model.dart';

sealed class WishListState {}

class WishListInitial extends WishListState {}

class WishListLoading extends WishListState {}

class WishListLoaded extends WishListState {
  final List<WishModel> wishes;
  WishListLoaded(this.wishes);
}

class WishListError extends WishListState {
  final String message;
  WishListError(this.message);
}
