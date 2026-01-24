import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionUpdateDialog extends StatefulWidget {
  final dynamic appVersionResult;
  const AppVersionUpdateDialog({super.key, this.appVersionResult});

  @override
  State<AppVersionUpdateDialog> createState() => _AppVersionUpdateDialogState();
}

class _AppVersionUpdateDialogState extends State<AppVersionUpdateDialog> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              const Spacer(flex: 2),
              Text(
                'Neue Version verfügbar',
                textAlign: TextAlign.center,
                style: AppTextStyle.getHeaderTextStyle(
                  AppColors.textColor,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Es ist eine neue Version der App verfügbar. Bitte aktualisiere die App, um alle neuen Funktionen und Verbesserungen zu erhalten.',
                textAlign: TextAlign.center,
                style: AppTextStyle.getHeaderTextStyle(AppColors.textColor),
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
                    backgroundColor: AppColors.primaryColor,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () async => await launchUrl(
                    Uri.parse(widget.appVersionResult!.storeUrl!),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Text(
                    'Update',
                    style: AppTextStyle.getHeaderTextStyle(Colors.white),
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
