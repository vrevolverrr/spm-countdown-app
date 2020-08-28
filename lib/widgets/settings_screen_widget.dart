import 'package:flutter/material.dart';
import 'package:spm_countdown/main.dart';
import 'package:spm_countdown/methods/io.dart';
import 'package:spm_countdown/methods/filenames.dart';
import 'package:spm_countdown/widgets/alert_dialog_widget.dart';

class SettingsScreen extends StatefulWidget {

  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double sliderRating = 0;
  bool switchValue = true;
  bool _snackbarActive = false;
  bool _backButtonDown = false;

  void showApplySettingsSnackbar(context) {
    if (!_snackbarActive) {
      Scaffold.of(context).showSnackBar(
          SnackBar(
            duration: Duration(days: 99),
            content: Text('You have unsaved changes'),
            action: SnackBarAction(
              label: 'Apply',
              onPressed: () {
                settings['tolerance'] = sliderRating.toInt();
                settings['strictMode'] = (switchValue) ? 1 : 0;
                writeFile(File().settingsTolerance, settings['tolerance'].toInt());
                writeFile(File().settingsStrict, settings['strictMode'].toInt());

                hideApplySettingsSnackbar(context);
              },
            ),
          )
      );
      _snackbarActive = true;
    }
  }

  void hideApplySettingsSnackbar(context) {
    if (_snackbarActive) {
      Scaffold.of(context).hideCurrentSnackBar();
      _snackbarActive = false;
    }
  }

  @override
  void initState() {
    sliderRating = settings['tolerance'].toDouble();
    switchValue = (settings['strictMode'] == 1) ? true : false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 243, 246, 1),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: 30,
                left: 20
            ),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.arrow_back_ios, color: (_backButtonDown) ? Colors.grey[500] : Colors.grey[700]),
                  onTapDown: (details) { setState(() => _backButtonDown = true); },
                  onTapUp: (details) { setState(() => _backButtonDown = false); },
                  onTapCancel: () { setState(() => _backButtonDown = false); },
                  onTap: () => Navigator.pop(context),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 20
                  ),
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                      letterSpacing: 1.3,
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                top: 25,
                left: 20
              ),
              child: Text(
                'Preferences',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 1.3,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 25,
                left: 20
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.favorite, size: 15, color: Colors.grey[500],),
                Container(
                  margin: EdgeInsets.only(
                      left: 20
                  ),
                  child: Text(
                    'Inconsistency Tolerance',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 8
                  ),
                  child: Tooltip(
                    padding: EdgeInsets.all(12),
                    message: (totalTime == 0) ? 'The number of consecutive days without\nfocusing before the plant wilts' : 'This setting is only available if your\nplant has not started growing',
                    textStyle: TextStyle(
                        height: 1.4,
                      color: Colors.white,
                      fontFamily: 'Lato'
                    ),
                    child: Icon(Icons.info_outline, size: 16),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 10
            ),
            child: AbsorbPointer(
              absorbing: (totalTime == 0) ? false : true,
              child: Builder(
                builder: (BuildContext context) {
                  return Slider(
                    activeColor: (totalTime == 0) ? Colors.lightBlueAccent : Colors.grey[400],
                    inactiveColor: (totalTime == 0) ? Colors.lightBlue[100] : Colors.grey[300],
                    value: sliderRating,
                    onChanged: (newRating) {
                      showApplySettingsSnackbar(context);
                      setState(() => sliderRating = newRating);
                    },
                    divisions: 6,
                    label: (sliderRating == 0) ? '${sliderRating.toInt()} day' : '${sliderRating.toInt()} days',
                    min: 1.0,
                    max: 7.0,
                  );
                },
              )
            )
          ),
          Container(
            margin: EdgeInsets.only(
                top: 10,
                left: 20
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.lock, size: 15, color: Colors.grey[500],),
                Container(
                  margin: EdgeInsets.only(
                      left: 20
                  ),
                  child: Text(
                    'Strict Mode',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 8
                  ),
                  child: Tooltip(
                    padding: EdgeInsets.all(12),
                    message: 'Whether or not the timer stops\nwhen you exit the app',
                    textStyle: TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontFamily: 'Lato'
                    ),
                    child: Icon(Icons.info_outline, size: 16),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 20
                      ),
                      child: Builder(
                        builder: (BuildContext context) {
                          return Switch(
                            activeColor: Colors.lightBlue,
                            activeTrackColor: Colors.lightBlueAccent,
                            value: switchValue,
                            onChanged: (newValue) {
                              showApplySettingsSnackbar(context);
                              setState(() => switchValue = newValue);
                            },
                          );
                        },
                      )
                    )
                  )
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                  top: 25,
                  left: 20
              ),
              child: Text(
                'About',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 1.3,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 10
            ),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => customWidgetAlertDialog(
                        title: 'SPM Countdown',
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                'Version 1.0.1 (Test Build)',
                              style: TextStyle(
                                fontSize: 12
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 15,
                                bottom: 5
                              ),
                              child: Text(
                                  'Copyright © 2020 Bryan Soong\nInspired by Benjamin Ooi',
                                style: TextStyle(
                                  height: 1.6
                                ),
                              ),
                            ),
                          ],
                        )
                    )
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: 20
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.info, size: 15, color: Colors.grey[500],),
                    Container(
                      padding: EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          left: 20
                      ),
                      child: Text(
                        'More Info',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}