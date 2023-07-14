import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Column(
      children: [
        Text('Private Policy'),
        Text('accept'),
        // iframe with policy
      ],
    );
  }
}
