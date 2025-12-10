class ActionModel {
  String id;
  String actionText;
  bool liked = false;
  bool saved = false;

  ActionModel({required this.id, required this.actionText});

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
        id: json['id']?.toString() ?? '',
        actionText: json['action_text']?.toString() ?? '');
  }
}
