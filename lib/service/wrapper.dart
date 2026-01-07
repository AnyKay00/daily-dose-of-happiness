import 'dart:convert';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_event.dart';
import 'package:daily_dose_of_happiness/service/auth_service.dart';
import 'package:daily_dose_of_happiness/service/bloc_handler.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/ui/daily_home_emotion_screen.dart';
import 'package:daily_dose_of_happiness/ui/feed_screen.dart';
import 'package:daily_dose_of_happiness/ui/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

enum DayTime { morning, midday, evening, night, fallback }

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late APICacheManager cacheManager;

  @override
  void didChangeDependencies() {
    cacheManager = Provider.of<APICacheManager>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
          DayTime? savedDayTime;

          try {
            if (data['date'] != null) {
              savedDate = DateTime.parse(data['date']);
            }
            if (data['day_time'] != null) {
              savedDayTime = DayTime.values
                  .where((time) => time.name == data['day_time'])
                  .firstOrNull;
            }
          } catch (e) {
            print('Error parsing date: $e');
          }

          final now = DateTime.now();
          savedDate ??= now;

          // Nur Tag/Monat/Jahr vergleichen (ohne Uhrzeit)
          final todayDay = DateTime(now.year, now.month, now.day);
          final savedDay =
              DateTime(savedDate.year, savedDate.month, savedDate.day);

          // Neuer Tag -> Reset und aktuelle Tageszeit ermitteln
          if (savedDay.isBefore(todayDay)) {
            DayTime currentDayTime = getCurrentDayTimeEnum();
            cacheManager.deleteHapinessPack();
            return DailyHomeScreen(
              selectedFeelingCount: 0,
              dayTime: currentDayTime,
            );
          }

          // Gleicher Tag
          if (savedDay == todayDay) {
            DayTime currentDayTime = getCurrentDayTimeEnum();
            int selectedFeelingCount =
                int.parse(data['counter']?.toString() ?? '0');

            // Prüfe ob User in dieser Tageszeit wählen darf
            if (_canSelectEmotion(savedDayTime, currentDayTime)) {
              cacheManager.deleteHapinessPack();
              return DailyHomeScreen(
                selectedFeelingCount: selectedFeelingCount,
                dayTime: currentDayTime,
              );
            }

            BlocProvider.of<HappinessPackBloc>(context).add(
                LoadHappinessPackOfFeelingEvent(feelingId: defaultEmotionId));
            return const FeedScreen();
          }

          BlocProvider.of<HappinessPackBloc>(context).add(
              LoadHappinessPackOfFeelingEvent(feelingId: defaultEmotionId));
          return const FeedScreen();
        }

        // Data is empty -> first time user
        return const OnboardingScreen();
      },
    );
  }
}

bool _canSelectEmotion(DayTime? lastDayTime, DayTime currentDayTime) {
  if (lastDayTime == null) {
    return true; // Noch keine Emotion heute gewählt
  }
  // Wenn die letzte Wahl in einer anderen Tageszeit war, darf gewählt werden
  if (currentDayTime == DayTime.morning && lastDayTime != DayTime.morning) {
    return true;
  }
  if (currentDayTime == DayTime.evening && lastDayTime != DayTime.evening) {
    return true;
  }
  return false; // Bereits in dieser Tageszeit gewählt
}

DayTime getCurrentDayTimeEnum() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour >= 0 && hour < 12) {
    return DayTime.morning;
  } else if (hour >= 12 && hour < 24) {
    return DayTime.evening;
  }
  return DayTime.fallback;
}
