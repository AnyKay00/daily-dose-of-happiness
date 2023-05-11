import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [_buildHeader()],
      ),
    );
  }

  Widget _buildHeader() {
    return Arc(
        height: 20,
        child: Container(
          height: (MediaQuery.of(context).size.height / 4) * 2,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: AppGradients.linearGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('DAILY DOSE OF HAPPINESS',
                  style: AppTextStyle.getHeaderTextStyle(
                      Colors.white.withOpacity(0.6))),
              const Spacer(),
              const Text(
                  'We dont stop playing because we grow old; we grow old because we stop playing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
            ],
          ),
        ));
  }
}
