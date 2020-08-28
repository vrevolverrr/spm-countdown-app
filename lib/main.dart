import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spm_countdown/methods/calculate_plant_state.dart';
import 'package:spm_countdown/methods/io.dart';
import 'package:spm_countdown/methods/filenames.dart';
import 'package:spm_countdown/behaviours/CustomScrollPhysics.dart';
import 'package:spm_countdown/behaviours/noScrollOverflowBehaviour.dart';
import 'package:spm_countdown/widgets/bottom_arrow_widget.dart';
import 'package:spm_countdown/widgets/countdown_header_widget.dart';
import 'package:spm_countdown/widgets/days_countdown_widget.dart';
import 'package:spm_countdown/widgets/days_text_widget.dart';
import 'package:spm_countdown/widgets/detailed_countdown_widget.dart';
import 'package:spm_countdown/widgets/plant_screen_settings_button_widget.dart';
import 'package:spm_countdown/widgets/plant_hero_widget.dart';
import 'package:spm_countdown/widgets/plant_screen_button_widget.dart';
import 'package:spm_countdown/widgets/quote_widget.dart';

// App Version
String appVersion = '1.0.1 Rev 1';

// Globally Scoped Variables
Map<String, dynamic> quoteData;
Map<String, int> settings = {'tolerance': 4, 'strictMode': 0};
int lastTimestamp;
int plantState = 0;
int focusTime = 0;
int totalTime = 0;
bool plantDied = false;
bool plantDying = false;

final platform = MethodChannel('com.bryansoong.spm_countdown');

// App Entry Point
void main() => runApp(App());

// Main App
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPM Countdown',
      debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: NoOverflowBehaviour(),
            child: child,
          );
        },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Lato'
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.initialPage = 0}) : super(key: key);

  final int initialPage;

  @override
  HomeScreenState createState() => HomeScreenState(initialPage: initialPage);
}

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState({this.initialPage = 0});

  final int initialPage;
  static PageController pageController;

  void readPlantState() async {
    if (await fileExists(File().focusTimeMillis)) {
      focusTime = await readFile(File().focusTimeMillis);
      totalTime = await readFile(File().totalTimeMillis);
      settings['tolerance'] = await readFile(File().settingsTolerance);
      settings['strictMode'] = await readFile(File().settingsStrict);
      int plantStateTimestamp = await readFile(File().plantStateTimestamp);
      int lastPlantState = await readFile(File().lastPlantState);
      int lastFocusTimestamp = await readFile(File().lastFocusTimestamp);

      int daysSinceLastFocus = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch).inDays - Duration(milliseconds: lastFocusTimestamp).inDays;

      if (daysSinceLastFocus > 3) {
        totalTime = 0;
        focusTime = 0;
        lastFocusTimestamp = 0;
        plantStateTimestamp = 0;

        plantDied = true;
        plantState = 0;

        writeFile(File().focusTimeMillis, 0);
        writeFile(File().totalTimeMillis, 0);
        writeFile(File().plantStateTimestamp, 0);
        writeFile(File().lastPlantState, 0);
        writeFile(File().lastFocusTimestamp, DateTime.now().millisecondsSinceEpoch);

        return;
      }

      if (daysSinceLastFocus > 2) {
        plantDying = true;
      }

      if (Duration(milliseconds: plantStateTimestamp).inDays != Duration(milliseconds: DateTime.now().millisecondsSinceEpoch).inDays) {
        plantState = calculatePlantState(focusTime);
        writeFile(File().lastPlantState, plantState);
        writeFile(File().plantStateTimestamp, DateTime.now().millisecondsSinceEpoch);

      } else {
        plantState = lastPlantState;
      }

    } else {
      writeFile(File().focusTimeMillis, 0);
      writeFile(File().totalTimeMillis, 0);
      writeFile(File().plantStateTimestamp, 0);
      writeFile(File().lastPlantState, 0);
      writeFile(File().settingsTolerance, 3);
      writeFile(File().settingsStrict, 0);
      writeFile(File().lastFocusTimestamp, DateTime.now().millisecondsSinceEpoch);
    }

    if (await fileExists('sessionTicksMillis')) {
      removeFile('sessionTicksMillis');
    }
  }

  @override
  void initState() {
    pageController = PageController(initialPage: initialPage);
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Color.fromRGBO(40, 40, 40, 0.2)
      ));
    }
    readPlantState();

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 243, 246, 1),
        body: PageView(
          scrollDirection: Axis.vertical,
          controller: pageController,
          physics: CustomScrollPhysics(),
          children: <Widget>[
            Column(
              children: <Widget>[
                // Home Screen
                CountdownHeader(),
                DaysCountdownWidget(),
                DaysText(),
                DetailedCountdownWidget(),
                QuoteWidget(),
                BottomArrowWidget()
              ],
            ),
            Column(
              children: <Widget>[
                // Plant Screen
                PlantSettingsButton(),
                PlantHero(),
                FocusPlayButton()
              ],
            )
          ],
        )
    );
  }
}
