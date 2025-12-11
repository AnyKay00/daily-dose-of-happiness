import 'package:daily_dose_of_happiness/bloc/action_bloc/action_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/action_bloc/action_event.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_event.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_bloc.dart'
    show MotivationBloc;
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailysBlocHandler {
  static void triggerDalysBlocEvents(BuildContext context) {
    BlocProvider.of<MotivationBloc>(context).add(LoadMotivationEvent());
    BlocProvider.of<JokeBloc>(context).add(LoadJokeEvent());
    BlocProvider.of<ActionBloc>(context).add(LoadActionEvent());
  }
}

Map<String, String> buildHttpsHeader() {
  return {
    "Authorization": 'Bearer sb_publishable_LxMknhDaYeflhZ7mr-6hqA_rIEcxRwB',
    "Content-type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": "true",
  };
}

final String baseUrl = 'https://tepdsacsvcamgwwtffvl.supabase.co/';
final String apiKey = 'sb_publishable_LxMknhDaYeflhZ7mr-6hqA_rIEcxRwB';
