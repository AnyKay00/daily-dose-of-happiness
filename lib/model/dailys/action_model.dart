class ActionModel {
  String id;
  String shortId;
  String actionText;
  bool liked = false;
  bool saved = false;

  ActionModel(
      {required this.id, required this.actionText, required this.shortId});

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
        id: json['id']?.toString() ?? '',
        shortId: json['short_id']?.toString() ?? '',
        actionText: json['text']?.toString() ?? '');
  }
}
