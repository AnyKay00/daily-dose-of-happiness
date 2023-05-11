import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';

class DailyHomeScreen extends StatefulWidget {
  static GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  const DailyHomeScreen({super.key});

  @override
  State<DailyHomeScreen> createState() => _DailyHomeScreenState();
}

class _DailyHomeScreenState extends State<DailyHomeScreen> {
  static GlobalKey<NavigatorState> _homeKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    DailyHomeScreen.homeKey = _homeKey;
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
