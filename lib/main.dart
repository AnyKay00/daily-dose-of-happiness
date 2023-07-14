import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/movtivation_bloc.dart';
import 'package:daily_dose_of_happiness/repository/joke_repository.dart';
import 'package:daily_dose_of_happiness/repository/motivation_repository.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/navigation_screen.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<MotivationBloc>(
            create: (context) =>
                MotivationBloc(repository: MotivationRepository())),
        BlocProvider<JokeBloc>(
            create: (context) => JokeBloc(repository: JokeRepository()))
      ],
      child: MaterialApp(
        title: 'Daily dose of Happiness',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          useMaterial3: true,
        ),
        home: const NavigationScreen(),
      ),
    );
  }
}
