import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  final Uri _urlZenquotes = Uri.parse('https://zenquotes.io/');
  final Uri _urljokeapi = Uri.parse('https://sv443.net/jokeapi/v2/');
  final Uri _urldadjokeapi = Uri.parse('https://icanhazdadjoke.com/');
  final Uri _imprintlink = Uri.parse(
      'https://anykay00.github.io/daily-dose-of-happiness/index.html#about');
  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        elevation: 0.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        width: MediaQuery.of(context).size.width / 1.5,
        child: SingleChildScrollView(
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
                    onPressed: () async {
                      if (!await launchUrl(_urlZenquotes)) {
                        throw Exception('Could not launch $_urlZenquotes');
                      }
                    },
                    child: Text(_urlZenquotes.toString())),
                const Text('Base JokeAPI',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const Text('Jokes provided by:'),
                TextButton(
                    onPressed: () async {
                      if (!await launchUrl(_urljokeapi)) {
                        throw Exception('Could not launch $_urljokeapi');
                      }
                    },
                    child: Text(_urljokeapi.toString())),
                const Text('DadJoke',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const Text('Jokes provided by:'),
                TextButton(
                    onPressed: () async {
                      if (!await launchUrl(_urldadjokeapi)) {
                        throw Exception('Could not launch $_urldadjokeapi');
                      }
                    },
                    child: Text(_urldadjokeapi.toString())),
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
                        throw Exception('Could not launch $_urlZenquotes');
                      }
                    },
                    child: const Text('Private Policy')),
              ],
            ),
          ),
        ));
  }
}
