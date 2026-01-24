import 'package:daily_dose_of_happiness/bloc/action_bloc/action_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_bloc.dart';

import 'package:app_version_update/app_version_update.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_event.dart';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/memory_book_bloc/memory_book_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/wish_bloc/wish_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/wish_list_bloc/wish_list_bloc.dart';
import 'package:daily_dose_of_happiness/repository/action_repository.dart';
import 'package:daily_dose_of_happiness/repository/feeling_repository.dart';
import 'package:daily_dose_of_happiness/repository/joke_repository.dart';
import 'package:daily_dose_of_happiness/repository/memory_book_repository.dart';
import 'package:daily_dose_of_happiness/repository/motivation_repository.dart';
import 'package:daily_dose_of_happiness/repository/wish_repository.dart';
import 'package:daily_dose_of_happiness/service/auth_service.dart';
import 'package:daily_dose_of_happiness/service/bloc_handler.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/service/wrapper.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/widgets/consent_widget.dart';
import 'package:daily_dose_of_happiness/widgets/update_dialog.dart';
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
    final wishRepo = WishRepository(Supabase.instance.client);

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
                      HappinessPackBloc(repository: feelingRepo)),
              BlocProvider<WishBloc>(
                  create: (context) => WishBloc(repo: wishRepo)),
              BlocProvider<WishListBloc>(
                  create: (context) => WishListBloc(repo: wishRepo)),
              BlocProvider<MemoryBookBloc>(
                  create: (context) => MemoryBookBloc(
                      repo: MemoryBookRepository(Supabase.instance.client))),
            ],
            child: MaterialApp(
              title: 'Daily dose of Happiness',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
                useMaterial3: true,
              ),
              home: ConsentGate(child: AppBootstrapScreen()),
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
  bool checkedVersion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;
    _bootstrap();
  }

  void checkVersion(BuildContext context) async {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    if (isIOS) {
      //TODO
      await AppVersionUpdate.checkForUpdates(
        appleId: "6449080903",
        playStoreId: "com.invio.dailydoseofhappiness",
        country: 'de',
      ).then((data) async {
        if (data.canUpdate! && checkedVersion == false) {
          checkedVersion = true;

          await showDialog(
            barrierDismissible: false,
            fullscreenDialog: true,
            context: context,
            builder: (context) =>
                AppVersionUpdateDialog(appVersionResult: data),
          );
        }
      });
    } else {
      await AppVersionUpdate.checkForUpdates().then((data) async {
        if (data.canUpdate! && checkedVersion == false) {
          checkedVersion = true;

          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
                AppVersionUpdateDialog(appVersionResult: data),
          );
        }
      });
    }
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
      backgroundColor: AppColors.secondaryColor,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
