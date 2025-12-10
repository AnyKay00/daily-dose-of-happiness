class MotivationModel {
  String text;
  String authorName;

  bool liked = false;
  bool saved = false;
  
  MotivationModel({required this.authorName, required this.text});

  factory MotivationModel.fromJson(Map<String, dynamic> json) {
    return MotivationModel(
        text: json['q'].toString(), authorName: json['a'].toString());
  }
}
