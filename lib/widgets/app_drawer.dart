import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  final Uri _imprintlink = Uri.parse(
      'https://anykay00.github.io/daily-dose-of-happiness/index.html#about');
  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 10,
          bottom: 25.0,
          left: 15,
          right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //logo and text
          const Center(
              child: Text('Daily Dose Of Happiness',
                  style: TextStyle(fontWeight: FontWeight.w600))),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(600),
                  child: Image.asset(
                    'assets/app_logo.png',
                    width: 100,
                  )),
            ),
          ),
        
          const Divider(
            height: 50,
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
      ),
    );
  }
}
