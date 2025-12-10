import 'dart:convert';

import 'package:daily_dose_of_happiness/service/bloc_handler.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/ui/daily_home_emotion_screen.dart';
import 'package:daily_dose_of_happiness/ui/feed_screen.dart';
import 'package:daily_dose_of_happiness/ui/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  final int index;
  const Wrapper({Key? key, this.index = 0}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late Future<String> _chosedFeelingCounter;

  bool _homepageBlocTriggered = false;

  @override
  Widget build(BuildContext context) {
    final cacheManager = Provider.of<APICacheManager>(context, listen: true);

    return FutureBuilder<String>(
      future: cacheManager.read(feelingSelectedCountK),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        // Fall: Nutzer darf weiteres Gefühl wählen
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          //  'date': DateTime.now().toIso8601String(),
          //  'counter': newCounter.toString()
          Map<String, dynamic> data =
              Map<String, dynamic>.from(jsonDecode(snapshot.data!));

          int selectedFeelingCount = int.parse(data['counter'] ?? 0);
          if (selectedFeelingCount < 1) {
            //user can select a feeling
            return DailyHomeScreen(selectedFeelingCount: selectedFeelingCount);
          }
          //Fall: Nutzer hat anzahl gefühle pro tag erreicht

          //trigger loading dailys
          DailysBlocHandler.triggerDalysBlocEvents(context);
          return const FeedScreen();
        }
        //data is empty -> first time user
        //return const OnboardingScreen();
        return DailyHomeScreen(selectedFeelingCount: 0);
      },
    );
  }
}
