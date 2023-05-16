import 'package:auto_size_text/auto_size_text.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_state.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/movtivation_bloc.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class DailyHomeScreen extends StatefulWidget {
  static GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  const DailyHomeScreen({super.key});

  @override
  State<DailyHomeScreen> createState() => _DailyHomeScreenState();
}

class _DailyHomeScreenState extends State<DailyHomeScreen> {
  static GlobalKey<NavigatorState> _homeKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    DailyHomeScreen.homeKey = _homeKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildHeader(),
            const Spacer(),
            SvgPicture.asset(
              'assets/heart.svg',
              width: MediaQuery.of(context).size.width - 160,
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Arc(
        height: 20,
        clipShadows: [ClipShadow(color: Colors.black45)],
        child: Container(
          height: (MediaQuery.of(context).size.height / 4) * 2,
          width: double.infinity,
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          decoration: BoxDecoration(gradient: AppGradients.linearGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('DAILY DOSE OF HAPPINESS',
                  style: AppTextStyle.getHeaderTextStyle(
                      Colors.white.withOpacity(0.6))),
              const Spacer(),
              BlocBuilder<MotivationBloc, MotivationState>(
                  builder: (context, state) {
                if (state is LoadedMotivationState) {
                  return Column(
                    children: [
                      AutoSizeText(state.motivation[0].text,
                          textAlign: TextAlign.center,
                          maxFontSize: 26,
                          minFontSize: 16,
                          style: const TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      Text('- ' + state.motivation[0].authorName + ' -',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                    ],
                  );
                } else if (state is FailedLoadMotivationState) {
                  return const Text('Heute gibt es keinen neuen Spruch..');
                }
                return Container();
              }),
              const Spacer(),
            ],
          ),
        ));
  }
}
