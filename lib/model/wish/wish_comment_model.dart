class WishCommentModel {
  final String id;
  final String wishId;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isMine;

  WishCommentModel({
    required this.id,
    required this.wishId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.isMine,
  });

  factory WishCommentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return WishCommentModel(
        id: '',
        wishId: '',
        body: '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
        isMine: false,
      );
    }

    return WishCommentModel(
      id: json['id']?.toString() ?? '',
      wishId: json['idea_id']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isMine: json['is_mine'] == true,
    );
  }
}
