import 'package:daily_dose_of_happiness/code/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/navigation_screen.dart';
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Private Policy',
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          // iframe with policy
          TextButton(
              onPressed: () {
                APICacheManager manager = APICacheManager('agreement');
                manager.updateOrWriteToFile(true);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const NavigationScreen()),
                  ModalRoute.withName('/'),
                );
              },
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      TextStyle(color: AppColors.primaryColor, fontSize: 28)),
                  padding: MaterialStateProperty.all(EdgeInsets.only(
                      top: 10, bottom: 10, left: 30, right: 30)),
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              child: const Text(
                'Accept',
              ))
        ],
      ),
    );
  }
}
