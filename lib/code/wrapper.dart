import 'package:daily_dose_of_happiness/code/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/ui/first_private_policy_screen.dart';
import 'package:daily_dose_of_happiness/ui/navigation_screen.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getFile(), //auth.readLoginFlagFromStorage(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return const OnboardingScreen();
          }
          //Navigator.of(context).pushNamed(homeRoute)
          return const NavigationScreen();
        });
  }

  Future<bool> getFile() async {
    APICacheManager manager = APICacheManager('agreement');
    Map<String, dynamic>? cache = await manager.readFromFile();
    // TODO read file properly
    print('""""""""""');
    print(cache);
    return true;
  }
}
