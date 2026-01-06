import 'package:daily_dose_of_happiness/model/wish/wish_comment_model.dart';

sealed class WishState {}

class WishIdle extends WishState {}

class WishActionInProgress extends WishState {}

class WishActionSuccess extends WishState {}

class WishActionError extends WishState {
  final String message;
  WishActionError(this.message);
}

class WishCommentsLoaded extends WishState {
  final String wishId;
  final List<WishCommentModel> comments;
  WishCommentsLoaded({required this.wishId, required this.comments});
}
