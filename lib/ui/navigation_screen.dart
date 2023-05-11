import 'dart:collection';

import 'package:daily_dose_of_happiness/bloc/motivation_bloc/motivation_event.dart';
import 'package:daily_dose_of_happiness/bloc/motivation_bloc/movtivation_bloc.dart';
import 'package:daily_dose_of_happiness/static/style.dart';
import 'package:daily_dose_of_happiness/ui/daily_home_screen.dart';
import 'package:daily_dose_of_happiness/ui/daily_joke_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  ListQueue _navigationQueue = ListQueue();
  final _pages = const <Widget>[
    DailyHomeScreen(),
    DailyJokeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    //quick load
    BlocProvider.of<MotivationBloc>(context).add(LoadMotivationEvent());

    return WillPopScope(
      onWillPop: () async {
        // navigator in widgets
        switch (_selectedIndex) {
          case 0:
            //WIP: working properly
            if (DailyHomeScreen.homeKey.currentState != null &&
                DailyHomeScreen.homeKey.currentState!.canPop()) {
              DailyHomeScreen.homeKey.currentState!.pop();
              return false;
            }
            break;
          case 2:
            //WIP: not working - key is null
            if (DailyJokeScreen.jokeKey.currentState != null &&
                DailyJokeScreen.jokeKey.currentState!.canPop()) {
              DailyJokeScreen.jokeKey.currentState!.pop();
              return false;
            }
            break;
        }
        //go  bavk between tabs
        if (_navigationQueue.isNotEmpty) {
          setState(() {
            _selectedIndex = _navigationQueue.last;
            _navigationQueue.removeLast();
            _onTapHandler(_selectedIndex);
          });
          return false;
        }
        if (_selectedIndex == 0) {
          return true;
        }
        return true;
      },
      child: Scaffold(
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: '',
              icon: Container(
                decoration: BoxDecoration(
                    color: _selectedIndex == 0
                        ? AppColors.secondaryColor
                        : Colors.transparent,
                    shape: BoxShape.circle),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.calendar_month),
                ),
              ),
            ),
            BottomNavigationBarItem(
                label: '',
                icon: Container(
                  decoration: BoxDecoration(
                      color: _selectedIndex == 1
                          ? AppColors.secondaryColor
                          : Colors.transparent,
                      shape: BoxShape.circle),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.tag_faces),
                  ),
                )),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: AppColors.secondaryColor,
          backgroundColor: Colors.white,
          elevation: 16.0,
          iconSize: 22,
          onTap: (index) {
            _navigationQueue.add(_selectedIndex);
            _onTapHandler(index);
          },
        ),
      ),
    );
  }

  void _onTapHandler(int index) {
    // add the right bloc event and fill navigationque
    setState(() {
      switch (index) {
        // home
        case 0:
          BlocProvider.of<MotivationBloc>(context).add(LoadMotivationEvent());
          break;
        //jokes
        case 1:
          break;
      }
      _selectedIndex = index;
    });
  }
}
