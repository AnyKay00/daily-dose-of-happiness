class WishModel {
  final String id;
  final String body;
  final String status;
  final int score;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isMine;

  /// Eigener Vote: +1, -1 oder null (kein Vote)
  final int? myVote;

  WishModel({
    required this.id,
    required this.body,
    required this.status,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
    required this.isMine,
    this.myVote,
  });

  WishModel copyWith({
    int? score,
    int? myVote,
  }) {
    return WishModel(
      id: id,
      body: body,
      status: status,
      score: score ?? this.score,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isMine: isMine,
      myVote: myVote ?? this.myVote,
    );
  }

  factory WishModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return WishModel(
        id: '',
        body: '',
        status: '',
        score: 0,
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
        isMine: false,
      );
    }

    return WishModel(
      id: json['id']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      status: json['status']?.toString() ?? 'open',
      score: (json['score'] is num)
          ? (json['score'] as num).toInt()
          : int.tryParse(json['score']?.toString() ?? '') ?? 0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isMine: json['is_mine'] == true,
      myVote: json['my_vote'] == null
          ? null
          : (json['my_vote'] is num)
              ? (json['my_vote'] as num).toInt()
              : int.tryParse(json['my_vote']?.toString() ?? ''),
    );
  }
}
