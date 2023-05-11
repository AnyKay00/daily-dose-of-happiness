import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';

class DailyJokeScreen extends StatefulWidget {
  static GlobalKey<NavigatorState> jokeKey = GlobalKey<NavigatorState>();
  const DailyJokeScreen({super.key});

  @override
  State<DailyJokeScreen> createState() => _DailyJokeScreenState();
}

class _DailyJokeScreenState extends State<DailyJokeScreen> {
  static GlobalKey<NavigatorState> _jokeKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    DailyJokeScreen.jokeKey = _jokeKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      child: Container(
        height: 200,
        width: 200,
        color: AppColors.primaryColor,
      ),
    );
  }
}
