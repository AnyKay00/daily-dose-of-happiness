import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_event.dart';
import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_state.dart';
import 'package:daily_dose_of_happiness/repository/wish_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishBloc extends Bloc<WishEvent, WishState> {
  final WishRepository repo;

  WishBloc({required this.repo}) : super(WishIdle()) {
    on<WishCreateRequested>((event, emit) async {
      emit(WishActionInProgress());
      try {
        await repo.createWish(event.body);
        emit(WishActionSuccess());
      } catch (e) {
        emit(WishActionError(e.toString()));
      }
    });

    on<WishUpdateRequested>((event, emit) async {
      emit(WishActionInProgress());
      try {
        await repo.updateOwnWish(wishId: event.wishId, body: event.body);
        emit(WishActionSuccess());
      } catch (e) {
        emit(WishActionError(e.toString()));
      }
    });

    on<WishVoteRequested>((event, emit) async {
      emit(WishActionInProgress());
      try {
        await repo.voteOnWish(event.wishId, event.value);
        emit(WishActionSuccess());
      } catch (e) {
        emit(WishActionError(e.toString()));
      }
    });

    on<WishVoteCleared>((event, emit) async {
      emit(WishActionInProgress());
      try {
        await repo.clearVote(wishId: event.wishId);
        emit(WishActionSuccess());
      } catch (e) {
        emit(WishActionError(e.toString()));
      }
    });

    on<WishCommentAddRequested>((event, emit) async {
      emit(WishActionInProgress());
      try {
        await repo.addComment(wishId: event.wishId, body: event.body);
        emit(WishActionSuccess());
      } catch (e) {
        emit(WishActionError(e.toString()));
      }
    });

    on<WishCommentUpdateRequested>((event, emit) async {
      emit(WishActionInProgress());
      try {
        await repo.updateOwnComment(
            commentId: event.commentId, body: event.body);
        emit(WishActionSuccess());
      } catch (e) {
        emit(WishActionError(e.toString()));
      }
    });

    on<WishCommentsLoadRequested>((event, emit) async {
      emit(WishActionInProgress());
      try {
        final comments = await repo.loadComments(event.wishId);
        emit(WishCommentsLoaded(wishId: event.wishId, comments: comments));
      } catch (e) {
        emit(WishActionError(e.toString()));
      }
    });
  }
}
