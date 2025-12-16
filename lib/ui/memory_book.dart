import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_state.dart';
import 'package:daily_dose_of_happiness/model/user_feeling_model.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MemoryBookScreen extends StatefulWidget {
  const MemoryBookScreen({super.key});

  @override
  State<MemoryBookScreen> createState() => _MemoryBookScreenState();
}

class _MemoryBookScreenState extends State<MemoryBookScreen> {
  bool _activePush = false;

  String version = '0.1.0';
  String buildNumber = '1.0';

  final Uri _imprintlink = Uri.parse(
      'https://anykay00.github.io/daily-dose-of-happiness/index.html#about');

  void initVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  @override
  Widget build(BuildContext context) {
    initVersionNumber();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.paddingOf(context).bottom + 20,
            top: MediaQuery.paddingOf(context).top + 20),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Spacer(),
              Text('Memory Book',
                  style: AppTextStyle.getdynamicTextStyle(Colors.black, 24)),
              Spacer(flex: 2)
            ],
          ),
          SizedBox(height: 20),
          //week feelings
          _buildWeekFeelings(),
          Divider(height: 90),
          Text('Bald kannst du auch Daylies speichern!',
              style: AppTextStyle.getdynamicTextStyle(Colors.black, 20)),
          Divider(height: 80),
          _buildSettings(),
          Divider(height: 90),
          _buildImprint()
          //saved dailys
          //Text('Gespeicherte Einträge',
          // style: AppTextStyle.getdynamicTextStyle(Colors.black, 20)),
          //SizedBox(height: 10),
          // _getSavedDailys(),
          //settings
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Einstellungen',
            style: AppTextStyle.getdynamicTextStyle(Colors.black, 20)),
        SizedBox(height: 10),
        //push
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Push-Benachrichtigungen',
              style: AppTextStyle.getdynamicTextStyle(Colors.black, 18),
            ),
            StatefulBuilder(
              builder: (context, setter) {
                return Switch(
                  value: _activePush,
                  activeColor: Colors.green[600],
                  activeTrackColor: Colors.green[100],
                  onChanged: (value) {
                    setter(() {
                      _activePush = value;
                    });
                  },
                );
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'E-Mail Benachrichtigungen',
              style: AppTextStyle.getdynamicTextStyle(Colors.black, 18),
            ),
            StatefulBuilder(
              builder: (context, setter) {
                return Switch(
                  value: _activePush,
                  activeColor: Colors.green[600],
                  activeTrackColor: Colors.green[100],
                  onChanged: (value) {
                    setter(() {
                      _activePush = value;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImprint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //logo and versions
        Center(
            child: Text('Daily Dose Of Happiness',
                style: AppTextStyle.getdynamicTextStyle(Colors.black, 16))),
        Center(
            child: Text('Version: $version',
                style: AppTextStyle.getdynamicTextStyle(Colors.black, 16))),
        Center(
            child: Text('Build: $version',
                style: AppTextStyle.getdynamicTextStyle(Colors.black, 16))),

        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(600),
                child: Image.asset(
                  'assets/app_logo.png',
                  width: 80,
                )),
          ),
        ),

        TextButton(
            onPressed: () async {
              if (!await launchUrl(_imprintlink)) {
                throw Exception('Could not launch $_imprintlink');
              }
            },
            child: const Text('Imprint')),
        TextButton(
            onPressed: () async {
              if (!await launchUrl(_imprintlink)) {
                throw Exception('Could not launch $_imprintlink');
              }
            },
            child: const Text('Private Policy')),
      ],
    );
  }
  /* Widget _getSavedDailys() {
    return BlocBuilder<Saved>(builder: (context, state) {
      if (state is LoadedLastWeekFeelingListState) {
        final feelings = state.feelings;
        if (feelings.isEmpty) {
          return Text('Du hast noch keine Einträge gespeichert.',
              style: AppTextStyle.getdynamicTextStyle(Colors.grey, 16));
        }
        return Column(
          children: feelings.map((feeling) {
            final dateText = DateFormat('dd.MM.yyyy').format(feeling.date);
            return ListTile(
              title: Text(dateText,
                  style: AppTextStyle.getdynamicTextStyle(Colors.black, 18)),
              subtitle: Text('Gefühl: ${feeling.feeling.feelingName.name}',
                  style: AppTextStyle.getdynamicTextStyle(Colors.black54, 16)),
            );
          }).toList(),
        );
      }
    });
  } */

  Widget _buildWeekFeelings() {
    return BlocBuilder<FeelingListBloc, FeelingListState>(
      builder: (context, state) {
        if (state is LoadingFeelingListState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LoadedLastWeekFeelingListState) {
          final List<UserFeelingModel> feelings = state.feelings;

          final DateTime today = DateTime.now();

          // Map: "yyyy-MM-dd" -> UserFeelingModel
          final Map<String, UserFeelingModel> feelingsByDate = {
            for (final f in feelings) _dateKey(f.date): f,
          };

          // letzte 6 Kalendertage inkl. heute
          final List<DateTime> lastSixDays = List.generate(6, (index) {
            final d = today.subtract(Duration(days: 5 - index));
            return DateTime(d.year, d.month, d.day);
          });
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: lastSixDays.map((day) {
              final bool isToday = _isSameDay(day, today);
              final String key = _dateKey(day);

              final UserFeelingModel? feelingForDay = feelingsByDate[key];

              return _DayFeelingItem(
                date: day,
                feeling: feelingForDay, // kann null sein → Platzhalter
                isToday: isToday,
              );
            }).toList(),
          );
        }

        if (state is FailedLoadFeelingListState) {
          return const Center(
            child: Text("Es ist ein Fehler aufgetreten, versuche es erneut."),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month}-${date.day}'; // reicht für Tagesgenauigkeit

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayFeelingItem extends StatelessWidget {
  final DateTime date;
  final UserFeelingModel? feeling;
  final bool isToday;

  const _DayFeelingItem({
    Key? key,
    required this.date,
    required this.feeling,
    required this.isToday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('d.M').format(date);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 7,
          height: MediaQuery.sizeOf(context).width / 7,
          child: (feeling != null)
              ? Image.asset(
                  'assets/feelings/pina_${feeling!.feeling.feelingName.name}.png',
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          dateText,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isToday ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
