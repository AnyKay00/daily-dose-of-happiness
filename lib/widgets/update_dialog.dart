import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionUpdateDialog extends StatefulWidget {
  final dynamic appVersionResult;
  const AppVersionUpdateDialog({super.key, this.appVersionResult});

  @override
  State<AppVersionUpdateDialog> createState() => _AppVersionUpdateDialogState();
}

class _AppVersionUpdateDialogState extends State<AppVersionUpdateDialog> {
  Widget _buildIntroOverlay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bild von Pina
          Image.asset(
            'assets/feelings/pina_happy.png',
            height: 120,
            fit: BoxFit.cover,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(end: 8, duration: 1.seconds)
              .rotate(end: 0.02, begin: -0.02),
          const SizedBox(width: 16),
          // Sprechblase
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                "Ich bin nach dem Update wieder für dich da",
                style: AppTextStyle.getdynamicTextStyle(
                  Colors.black87,
                  18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String _url = widget.appVersionResult != null
        ? widget.appVersionResult?.storeUrl ?? 'https://ddoh.lioverse.de'
        : 'https://ddoh.lioverse.de';
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              const Spacer(flex: 4),
              Text(
                'Neue Version verfügbar',
                textAlign: TextAlign.center,
                style: AppTextStyle.getHeaderTextStyle(
                  AppColors.textColor,
                ),
              ),
              const Spacer(flex: 1),
              Text(
                'Es ist eine neue Version der App verfügbar. Bitte aktualisiere die App, um alle neuen Funktionen und Verbesserungen zu erhalten.',
                textAlign: TextAlign.center,
                style:
                    AppTextStyle.getdynamicTextStyle(AppColors.textColor, 18),
              ),
              const Spacer(flex: 1),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                      bottom: 12.0,
                      left: 10,
                      right: 10,
                    ),
                    backgroundColor: AppColors.secondaryColor,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () async => await launchUrl(
                    Uri.parse(_url),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Text(
                    'Update',
                    style: AppTextStyle.getHeaderTextStyle(Colors.black87),
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              _buildIntroOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}
