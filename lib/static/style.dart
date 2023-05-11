import 'package:flutter/material.dart';

class AppColors {
  const AppColors();

  static const Color primaryColor = Color.fromARGB(255, 239, 203, 94);

  static const Color secondaryColor = Color.fromARGB(255, 236, 176, 82);

  static const Color ligthTextColor = Color.fromARGB(255, 160, 160, 160);
  static const Color backgroundColor = Color.fromARGB(255, 240, 240, 240);
}

class AppTextStyle {
  const AppTextStyle();

  static TextStyle getHeaderTextStyle(Color clr) {
    return TextStyle(fontSize: 18, color: clr);
  }
}

class AppGradients {
  const AppGradients();
  static LinearGradient linearGradient = const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomCenter,
      colors: [
        /*   AppColors.primaryColorGradientStart,
        // AppColors.primaryColorGradientMiddle,
        AppColors.primaryColorGradientEnd */
        AppColors.primaryColor,
        AppColors.secondaryColor,
      ]);
}
