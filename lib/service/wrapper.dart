import 'dart:convert';

import 'package:daily_dose_of_happiness/service/bloc_handler.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/ui/daily_home_emotion_screen.dart';
import 'package:daily_dose_of_happiness/ui/feed_screen.dart';
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
          Map<String, dynamic> data =
              Map<String, dynamic>.from(jsonDecode(snapshot.data!));
          DateTime? savedDate;
          try {
            if (data['date'] != null) {
              savedDate = DateTime.parse(data['date']);
              print(savedDate);
            }
          } catch (e) {
            print('Error parsing date: $e');
          }
          final now = DateTime.now();
          // Fallback: wenn kein gültiges Datum → behandle wie heute
          savedDate ??= now;
          print(savedDate);

          // Nur Tag/Monat/Jahr vergleichen (ohne Uhrzeit)
          final todayDay = DateTime(now.year, now.month, now.day);
          final savedDay =
              DateTime(savedDate.year, savedDate.month, savedDate.day);
          // -----------------------------
          // FALL 1: Datum liegt in der Vergangenheit
          // → immer DailyHomeScreen
          // -----------------------------
          if (savedDay.isBefore(todayDay)) {
            return DailyHomeScreen(selectedFeelingCount: 0);
          }
          if (savedDay == todayDay) {
            int selectedFeelingCount =
                int.parse(data['counter']?.toString() ?? '0');

            if (selectedFeelingCount < 2) {
              // User kann heute noch ein Gefühl auswählen
              return DailyHomeScreen(
                  selectedFeelingCount: selectedFeelingCount);
            }

            // Tageslimit erreicht → Feed anzeigen
            DailysBlocHandler.triggerDalysBlocEvents(context);
            return const FeedScreen();
          }

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
