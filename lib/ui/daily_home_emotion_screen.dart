import 'dart:convert';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_event.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_bloc/feeling_state.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_state.dart';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/happiness_pack_bloc/happiness_pack_event.dart';
import 'package:daily_dose_of_happiness/model/feeling_model.dart';
import 'package:daily_dose_of_happiness/service/const_variables.dart';
import 'package:daily_dose_of_happiness/service/local_storage_manager.dart';
import 'package:daily_dose_of_happiness/service/wrapper.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DailyHomeScreen extends StatefulWidget {
  int selectedFeelingCount = 0;
  DayTime dayTime = DayTime.fallback;
  DailyHomeScreen(
      {super.key, required this.selectedFeelingCount, required this.dayTime});

  @override
  State<DailyHomeScreen> createState() => _DailyHomeScreenState();
}

class _DailyHomeScreenState extends State<DailyHomeScreen> {
  late APICacheManager cacheManager;
  double width = 0;
  int _pageIndex = 0;

  @override
  void didChangeDependencies() {
    cacheManager = Provider.of<APICacheManager>(context, listen: false);
    width = MediaQuery.sizeOf(context).width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: BlocBuilder<FeelingListBloc, FeelingListState>(
        builder: (context, state) {
          if (state is LoadingFeelingListState || state is InitFeelingState) {
            // Während des Ladens zeigen wir trotzdem schon Screen 0 (Intro) an?
            // Oder einen Ladescreen. Hier ein Ladescreen:
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedFeelingListState) {
            return _buildReelPageView(context, state.feelings);
          } else if (state is FailedLoadFeelingListState) {
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
    return Stack(
      children: [
        PageView.builder(
          scrollDirection: Axis.vertical,
          onPageChanged: (index) => setState(() => _pageIndex = index),
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
        ),
        if (_pageIndex != 0)
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: _DotsIndicator(
                expanded: width > 800 ? true : false,
                count: feelings.length,
                index: _pageIndex - 1),
          ),
      ],
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
              style: AppTextStyle.getdynamicTextStyle(
                      AppColors.textColor.withAlpha(150), 20)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Text(
              widget.selectedFeelingCount > 1
                  ? "Wie geht es dir jetzt gerade?"
                  : "Wie geht es dir heute?",
              textAlign: TextAlign.center,
              style: AppTextStyle.getdynamicTextStyle(AppColors.textColor, 36),
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
    final widthPina = width > 900 ? width / 4.5 : width / 2.5;
    return Container(
      key: UniqueKey(),
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
                    width: widthPina,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  //increment chosed feeling to cache
                  int newCounter = widget.selectedFeelingCount + 1;
                  Map<String, String> json = {
                    'date': DateTime.now().toIso8601String(),
                    'counter': newCounter.toString(),
                    'day_time': getCurrentDayTimeEnum().name
                  };
                  cacheManager.write(feelingSelectedCountK, jsonEncode(json));
                  //save daily feeling
                  BlocProvider.of<FeelingBloc>(context).add(
                    SendDailyFeelingEvent(feelingId: feeling.id),
                  );
                  // oldDailysBlocHandler.triggerDalysBlocEvents(context);
                  //get happinesspack
                  BlocProvider.of<HappinessPackBloc>(context).add(
                      LoadHappinessPackOfFeelingEvent(feelingId: feeling.id));
                  //navigate to feed
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const FeedScreen()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  height: 65,
                  width: width > 700 ? width / 1.5 : double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppGradients.buttonGradient,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: const Text(
                      "Auswählen",
                      style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
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

class _DotsIndicator extends StatelessWidget {
  final int count;
  final bool expanded;
  final int index;

  const _DotsIndicator({
    required this.count,
    required this.expanded,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: expanded && isActive
              ? 28
              : !expanded && isActive
                  ? 18
                  : 10,
          width: expanded ? 18 : 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            border: Border.all(width: 0.5, color: Colors.white),
            color: isActive ? AppColors.secondaryColor : Colors.white,
          ),
        );
      }),
    );
  }
}
