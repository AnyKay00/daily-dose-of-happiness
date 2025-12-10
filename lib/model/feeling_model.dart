import 'package:flutter/material.dart';

enum FeelingEnum { happy, sad, afraid, stressed, calm, motivated, tiered }

class FeelingModel {
  String id;
  FeelingEnum feelingName;
  Color feelingColor;

  FeelingModel(
      {required this.id,
      required this.feelingName,
      required this.feelingColor});

  factory FeelingModel.fromJson(Map<String, dynamic> json) {
    return FeelingModel(
      id: json['id']?.toString() ?? '',
      //todo from ennum
      feelingName: FeelingEnum.happy, //json['feeling']?.toString() ?? '',
      feelingColor: json['color'] != null
          ? buildColor(json['color']?.toString() ?? '#72ACD4')
          : const Color(0xFF72ACD4),
    );
  }
}

Color buildColor(String colorcode) {
  if (colorcode.isEmpty) colorcode = '#72ACD4';
  String hexA = '0xFF${colorcode.substring(1)}';
  return Color(int.parse(hexA));
}
