import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/navigation_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily dose of Happiness',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      home: const NavigationScreen(),
    );
  }
}
