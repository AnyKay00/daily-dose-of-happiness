import 'dart:convert';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_event.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_state.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_event.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_state.dart';
import 'package:daily_dose_of_happiness/model/feeling_model.dart';
import 'package:daily_dose_of_happiness/service/bloc_handler.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DailyHomeScreen extends StatefulWidget {
  int selectedFeelingCount = 0;
  DailyHomeScreen({super.key, required this.selectedFeelingCount});

  @override
  State<DailyHomeScreen> createState() => _DailyHomeScreenState();
}

class _DailyHomeScreenState extends State<DailyHomeScreen> {
  late APICacheManager cacheManager;

  @override
  void didChangeDependencies() {
    cacheManager = Provider.of<APICacheManager>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FeelingListBloc, FeelingListState>(
        builder: (context, state) {
          if (state is LoadingFeelingListState || state is InitFeelingState) {
            // Während des Ladens zeigen wir trotzdem schon Screen 0 (Intro) an?
            // Oder einen Ladescreen. Hier ein Ladescreen:
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedFeelingListState) {
            return _buildReelPageView(context, state.feelings);
          } else if (state is LoadFeelingsEvent) {
            return const Center(
                child:
                    Text("Es ist ein Fehler aufgetreten, verusche er erneut."));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildReelPageView(BuildContext context, List<FeelingModel> feelings) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      // itemCount ist Datenlänge + 1 (für den Intro Screen)
      itemCount: feelings.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Index 0 ist IMMER der Intro Screen
          return _buildIntroPage();
        } else {
          // Alle weiteren Indices sind Daten (index - 1)
          final feeling = feelings[index - 1];
          return _buildFeelingPage(context, feeling, index);
        }
      },
    );
  }

  // --- UI PART 1: INTRO SCREEN ---
  Widget _buildIntroPage() {
    return Container(
      decoration: BoxDecoration(gradient: AppGradients.backgroundGradient),
      padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + 20,
          bottom: MediaQuery.paddingOf(context).bottom + 20,
          left: 20,
          right: 20),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Daily Check-in",
              style: AppTextStyle.getdynamicTextStyle(Colors.black87, 20),
            ),
            Spacer(),
            Text(
              "Wie geht es dir heute?",
              textAlign: TextAlign.center,
              style: AppTextStyle.getdynamicTextStyle(Colors.black87, 36),
            ),
            Spacer(),
            Text(
              "scroll",
              style: AppTextStyle.getdynamicTextStyle(Colors.black, 16),
            ),
            Icon(Icons.keyboard_double_arrow_down,
                    size: 40, color: Colors.grey[800])
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveY(end: 10, duration: 900.ms),
          ],
        ),
      ),
    );
  }

  // --- UI PART 2: FEELING ELEMENT SCREEN ---
  Widget _buildFeelingPage(
      BuildContext context, FeelingModel feeling, int index) {
    // Generiere eine Farbe basierend auf dem Index
    final Color backgroundColor = feeling.feelingColor;

    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            // Center Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/feelings/pina_${feeling.feelingName.name}.png',
                    width: MediaQuery.sizeOf(context).width / 2.5,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      feeling.feelingName.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

            // Select Button am Boden
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    //increment chosed feeling to cache
                    int newCounter = widget.selectedFeelingCount + 1;
                    Map<String, String> json = {
                      'date': DateTime.now().toIso8601String(),
                      'counter': newCounter.toString()
                    };
                    cacheManager.write(feelingSelectedCountK, jsonEncode(json));
                    //save daily feeling
                    BlocProvider.of<FeelingBloc>(context).add(
                      SendDailyFeelingsEvent(feelingId: feeling.id),
                    );
                    //trigger loading dailys
                    DailysBlocHandler.triggerDalysBlocEvents(context);
                    //navigate to feed
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FeedScreen()),
                    );
                    //trigger bloc event with feeling id
                  },
                  child: const Text(
                    "Auswählen",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
