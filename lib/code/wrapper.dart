import 'package:daily_dose_of_happiness/code/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/ui/first_private_policy_screen.dart';
import 'package:daily_dose_of_happiness/ui/navigation_screen.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);

  APICacheManager manager = APICacheManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: ,//auth.readLoginFlagFromStorage(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == 'true') {
            return OnboardingScreen();
          }
          //Navigator.of(context).pushNamed(homeRoute)
          return NavigationScreen();
        });
  }
}
