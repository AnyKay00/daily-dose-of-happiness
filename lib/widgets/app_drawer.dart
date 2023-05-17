import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  final Uri _urlZenquotes = Uri.parse('https://zenquotes.io/');
  final Uri _urljokeapi = Uri.parse('https://sv443.net/jokeapi/v2/');
  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        elevation: 0.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        width: MediaQuery.of(context).size.width / 1.5,
        child: Padding(
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
              const Text('Credits',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 15,
              ),
              const Text('ZenQuotes',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const Text('Inspirational quotes provided by:'),
              TextButton(
                  onPressed: () {
                    _launchUrl();
                  },
                  child: Text(_urlZenquotes.toString())),
              const Text('JokeAPI',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const Text('Jokes provided by:'),
              TextButton(
                  onPressed: () {
                    _launchUrl();
                  },
                  child: Text(_urljokeapi.toString())),
              const Divider(
                height: 50,
              ),

              Text('INVIO')
            ],
          ),
        ));
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_urlZenquotes)) {
      throw Exception('Could not launch $_urlZenquotes');
    }
  }
}
