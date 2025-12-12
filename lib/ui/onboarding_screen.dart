import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/daily_home_emotion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  static const int _pageCount = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_pageIndex < _pageCount - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DailyHomeScreen(
                  selectedFeelingCount: 0,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _pageIndex == _pageCount - 1;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: AppGradients.backgroundGradient),
          child: Column(
            children: [
              // Top area (optional: skip button)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Optional skip: jump to last page
                        _pageController.animateToPage(
                          _pageCount - 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      child: const Text('Überspringen'),
                    ),
                  ],
                ),
              ),

              // PageView
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // button only
                  onPageChanged: (index) => setState(() => _pageIndex = index),
                  children: const [
                    _OnboardingPage(
                      title: 'Willkommen bei deiner Daily Dose of Happiness',
                      body:
                          'Diese App begleitet dich mit kleinen Momenten der Achtsamkeit durch deinen Alltag.\n'
                          'Kein Druck, keine Ziele, kein Vergleichen.\n'
                          'Nur ein kurzer Check-in – einmal am Tag, ganz für dich.',
                      pinaText: 'Hey ich bin Pina',
                    ),
                    _OnboardingPage(
                      title: 'Wie fühlst du dich gerade?',
                      body:
                          'Einmal am Tag wählst du, wie du dich in diesem Moment fühlst.\n',
                      pinaText:
                          'Alles ist erlaubt. Es gibt kein richtig oder falsch.',
                    ),
                    _OnboardingPage(
                      title: 'Deine Daily Dose entsteht aus deinem Gefühl',
                      body:
                          'Basierend auf deinem aktuellen Gemütszustand stell dir Pina deine persönliches Happiness Paket zusammen.\n'
                          'Es ist an das angepasst, was du gerade brauchst.',
                      pinaText: 'Ganz auf dich eingestellt!',
                    ),
                    /*  _OnboardingPage(
                      title: 'Sag uns, was dir gut tut',
                      body:
                          'Du kannst Feedback geben, damit wir besser verstehen, was dir hilft.\n'
                          'Und du kannst Inhalte speichern, die dir besonders gut tun.',
                   pinaText: '',
                    ) */
                  ],
                ),
              ),

              // Bottom controls
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DotsIndicator(
                      count: _pageCount,
                      index: _pageIndex,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.white)),
                        child: Text(isLast ? 'Lass uns starten' : 'Weiter'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String body;
  final String pinaText;

  const _OnboardingPage({
    required this.title,
    required this.body,
    required this.pinaText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.getHeaderTextStyle(Colors.black87)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),
              Text(
                body,
                style: AppTextStyle.getdynamicTextStyle(Colors.black87, 18),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: Image.asset(
                      "assets/feelings/pina_happy.png",
                      scale: 3,
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(end: 8, duration: 1.seconds)
                        .rotate(end: 0.02),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: AppGradients.pinaGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        pinaText,
                        style: AppTextStyle.getdynamicTextStyle(
                            Colors.black87, 18),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 1.seconds)
            ],
          ),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int index;

  const _DotsIndicator({
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            color: isActive
                ? AppColors.secondaryColor.withAlpha(130)
                : Colors.white,
          ),
        );
      }),
    );
  }
}
