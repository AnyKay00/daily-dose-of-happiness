import 'package:auto_size_text/auto_size_text.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_bloc.dart';
import 'package:daily_dose_of_happiness/bloc/joke_bloc/joke_state.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/widgets/app_drawer.dart';
import 'package:daily_dose_of_happiness/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class DailyJokeScreen extends StatefulWidget {
  static GlobalKey<NavigatorState> jokeKey = GlobalKey<NavigatorState>();
  const DailyJokeScreen({super.key});

  @override
  State<DailyJokeScreen> createState() => _DailyJokeScreenState();
}

class _DailyJokeScreenState extends State<DailyJokeScreen> {
  static GlobalKey<NavigatorState> _jokeKey = GlobalKey<NavigatorState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    DailyJokeScreen.jokeKey = _jokeKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: AppColors.backgroundColor,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    var _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.bottom -
        MediaQuery.of(context).viewPadding.top -
        kBottomNavigationBarHeight;
    return SingleChildScrollView(
      child: SizedBox(
        height: _height,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_getHeader(), _getJoke(), _getIllustration()]),
      ),
    );
  }

  Widget _getHeader() {
    return Arc(
      height: 20,
      clipShadows: [ClipShadow(color: Colors.black45)],
      child: Container(
          height: 130,
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top, bottom: 5),
          width: double.infinity,
          decoration: BoxDecoration(gradient: AppGradients.linearGradient),
          child: HeaderWidget(scaffoldKey: scaffoldKey)),
    );
  }

  Widget _getJoke() {
    return BlocBuilder<JokeBloc, JokeState>(builder: (context, state) {
      if (state is LoadedJokeState) {
        return Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10.0),
          child: Center(
            child: AutoSizeText(state.joke[0].joke,
                minFontSize: 16,
                maxFontSize: 50,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 26,
                    color: AppColors.ligthTextColor,
                    fontWeight: FontWeight.w500)),
          ),
        );
      }
      return Container();
    });
  }

  Widget _getIllustration() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: SvgPicture.asset(
          'assets/nature.svg',
          width: MediaQuery.of(context).size.width / 2.5,
        ),
      ),
    );
  }
}
