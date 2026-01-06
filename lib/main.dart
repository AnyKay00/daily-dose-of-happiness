import 'package:daily_dose_of_happiness/bloc/action_bloc/action_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_event.dart';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_bloc.dart';
import 'package:daily_dose_of_happiness/repository/action_repository.dart';
import 'package:daily_dose_of_happiness/repository/feeling_repository.dart';
import 'package:daily_dose_of_happiness/repository/joke_repository.dart';
import 'package:daily_dose_of_happiness/repository/motivation_repository.dart';
import 'package:daily_dose_of_happiness/service/auth_service.dart';
import 'package:daily_dose_of_happiness/service/bloc_handler.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/service/wrapper.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: baseUrl,
    anonKey: apiKey,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    APICacheManager cacheManager = APICacheManager();
    final feelingRepo = FeelingRepository(cacheManager);

    return MultiProvider(
        providers: [
          Provider<APICacheManager>.value(value: cacheManager),
          ChangeNotifierProvider<AuthService>(create: (_) => AuthService())
        ],
        builder: (context, widget) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<MotivationBloc>(
                  create: (context) => MotivationBloc(
                      repository: MotivationRepository(cacheManager))),
              BlocProvider<JokeBloc>(
                  create: (context) =>
                      JokeBloc(repository: JokeRepository(cacheManager))),
              BlocProvider<ActionBloc>(
                  create: (context) =>
                      ActionBloc(repository: ActionRepository(cacheManager))),
              BlocProvider<FeelingListBloc>(
                create: (context) => FeelingListBloc(repository: feelingRepo)
                  ..add(LoadFeelingsEvent()),
              ),
              BlocProvider<FeelingBloc>(
                  create: (context) => FeelingBloc(repository: feelingRepo)),
              BlocProvider<HappinessPackBloc>(
                  create: (context) =>
                      HappinessPackBloc(repository: feelingRepo))
            ],
            child: MaterialApp(
              title: 'Daily dose of Happiness',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
                useMaterial3: true,
              ),
              home: AppBootstrapScreen(),
            ),
          );
        });
  }
}

class AppBootstrapScreen extends StatefulWidget {
  const AppBootstrapScreen({super.key});

  @override
  State<AppBootstrapScreen> createState() => _AppBootstrapScreenState();
}

class _AppBootstrapScreenState extends State<AppBootstrapScreen> {
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      // Wichtig: init() setzt currentUserId aus Session ODER erstellt Guest
      await context.read<AuthService>().init();

      if (!mounted) return;
      // Nach erfolgreichem Bootstrap in die App weiter
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Wrapper()),
      );
    } catch (e) {
      // Minimaler Fehler-Fallback (du kannst das später schöner machen)
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authentication fehlgeschlagen: $e'),
          duration: 10.seconds,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
