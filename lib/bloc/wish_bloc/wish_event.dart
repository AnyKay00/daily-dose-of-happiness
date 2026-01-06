

sealed class WishEvent {}

class WishCreateRequested extends WishEvent {
  final String body;
  WishCreateRequested(this.body);
}

class WishUpdateRequested extends WishEvent {
  final String wishId;
  final String body;
  WishUpdateRequested({required this.wishId, required this.body});
}

class WishVoteRequested extends WishEvent {
  final String wishId;
  final int value; // 1 oder -1
  WishVoteRequested({required this.wishId, required this.value});
}

class WishVoteCleared extends WishEvent {
  final String wishId;
  WishVoteCleared({required this.wishId});
}

class WishCommentAddRequested extends WishEvent {
  final String wishId;
  final String body;
  WishCommentAddRequested({required this.wishId, required this.body});
}

class WishCommentUpdateRequested extends WishEvent {
  final String commentId;
  final String body;
  WishCommentUpdateRequested({required this.commentId, required this.body});
}

class WishCommentsLoadRequested extends WishEvent {
  final String wishId;
  WishCommentsLoadRequested(this.wishId);
}