import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_state.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_lisT_state.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_event.dart';
import 'package:daily_dose_of_happiness/model/feeling_model.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyHomeScreen extends StatefulWidget {
  const DailyHomeScreen({super.key});

  @override
  State<DailyHomeScreen> createState() => _DailyHomeScreenState();
}

class _DailyHomeScreenState extends State<DailyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BlocListener für einmalige Aktionen (wie SnackBar anzeigen)
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
      color: AppColors.backgroundColor,
      padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + 20,
          bottom: MediaQuery.paddingOf(context).bottom + 20,
          left: 20,
          right: 20),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Daily Check-in",
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.ligthTextColor,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            const Text(
              "Wie geht es dir heute?",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
            ),
            Spacer(),
            const Text("Swipe to start"),
            Icon(Icons.keyboard_double_arrow_down,
                size: 40, color: Colors.grey[800]),
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
                    'asset/feelings/pina_${feeling.feelingName.name}.png',
                    width: MediaQuery.sizeOf(context).width / 2.5,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    feeling.feelingName.name,
                    style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
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
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    //save daily feeling
                    //navigate to feed
                    Navigator.push(
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
