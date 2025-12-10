class ActionModel {
  String id;
  String action;
  bool liked = false;
  bool saved = false;

  ActionModel({required this.id, required this.action});

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
        id: json['id']?.toString() ?? '',
        action: json['action']?.toString() ?? '');
  }
}
