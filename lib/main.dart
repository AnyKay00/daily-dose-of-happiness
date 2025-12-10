import 'package:daily_dose_of_happiness/bloc/action_bloc/action_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_event.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_bloc.dart';
import 'package:daily_dose_of_happiness/repository/action_repository.dart';
import 'package:daily_dose_of_happiness/repository/feeling_repository.dart';
import 'package:daily_dose_of_happiness/repository/joke_repository.dart';
import 'package:daily_dose_of_happiness/repository/motivation_repository.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/daily_home_emotion_screen.dart';
import 'package:daily_dose_of_happiness/ui/memory_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    APICacheManager cacheManager = APICacheManager();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<MotivationBloc>(
            create: (context) =>
                MotivationBloc(repository: MotivationRepository(cacheManager))),
        BlocProvider<JokeBloc>(
            create: (context) =>
                JokeBloc(repository: JokeRepository(cacheManager))),
        BlocProvider<ActionBloc>(
            create: (context) =>
                ActionBloc(repository: ActionRepository(cacheManager))),
        BlocProvider<FeelingListBloc>(
          create: (context) => FeelingListBloc(repository: FeelingRepository())
            ..add(LoadFeelingsEvent()),
        ),
        BlocProvider<FeelingBloc>(
            create: (context) => FeelingBloc(repository: FeelingRepository()))
      ],
      child: MaterialApp(
        title: 'Daily dose of Happiness',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          useMaterial3: true,
        ),
        home: const DailyHomeScreen(),
      ),
    );
  }
}
