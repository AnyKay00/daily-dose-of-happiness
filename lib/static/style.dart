import 'package:flutter/material.dart';

class AppColors {
  const AppColors();

  //static const Color primaryColor = Color(0xFFF7D774);
  static const Color primaryColor = Color(0xFF86BBCF);

  //static const Color secondaryColor = Color(0xFF4EC5C1);
  static const Color secondaryColor = Color(0xFFF2D882);

  static const Color backgroundColor = Color(0xFFFAF9F7);

  static const Color textColor = Color.fromARGB(255, 20, 25, 26);

  static const Color ligthTextColor = Color.fromARGB(255, 160, 160, 160);

  static const Color likeColor = Color.fromARGB(255, 205, 85, 85);

  static const Color pinaBlue = Color(0xFFC4D6F9);
  static const Color pinaBlueLight = Color(0xFFDBE6FB);
}

class AppTextStyle {
  const AppTextStyle();
  static TextStyle getdynamicTextStyle(Color clr, double size) {
    return TextStyle(fontSize: size, color: clr, fontFamily: 'Montserrat');
  }

  static TextStyle getHeaderTextStyle(Color clr) {
    return TextStyle(fontSize: 26, color: clr, fontFamily: 'Montserrat');
  }
}

class AppGradients {
  const AppGradients();
  static LinearGradient linearGradient = const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 97, 156, 178),
        AppColors.primaryColor,
        AppColors.secondaryColor,
      ]);
  static LinearGradient backgroundGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      /*  stops: [
        0.00001,
        0.1,
        0.57,
        0.99999
      ], */
      colors: [
        Color.fromARGB(255, 29, 76, 93),
        Color.fromARGB(255, 97, 156, 178),
        AppColors.primaryColor,
        //   Color(0xFF7CAEC1),
        Color(0xFFBFCAA6),
        AppColors.secondaryColor,
      ]);
  static LinearGradient pinaGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomCenter,
      /*  stops: [
        0.1,
        0.9999
      ], */
      colors: [
        Colors.white,
        AppColors.pinaBlueLight,
      ]);
  static LinearGradient buttonGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
      stops: [
        0.01,
        0.992,
      ],
      colors: [
        AppColors.secondaryColor,
        Color.fromARGB(255, 202, 201, 107)
      ]);
}

class AppDesignHelper {
  static String formatDate(DateTime dt) {
    // Simple + robust. Replace with intl if you already use it.
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$d.$m.$y';
  }
}
