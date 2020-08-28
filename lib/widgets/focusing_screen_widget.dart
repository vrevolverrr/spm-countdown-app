import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spm_countdown/main.dart';
import 'package:spm_countdown/methods/io.dart';
import 'package:spm_countdown/methods/filenames.dart';

bool _timerActive = false;

class FocusingScreen extends StatefulWidget {

  @override
  FocusingScreenState createState() => FocusingScreenState();
}

class FocusingScreenState extends State<FocusingScreen> with WidgetsBindingObserver {

  Future<bool> onPop() async {
    return false;
  }

  Future<bool> _getScreenLockedState() async {
    bool result;

    try {
      result = await platform.invokeMethod('getScreenLockedState');

    } on PlatformException {
      // TODO
    }

    return result;
  }

  @override
  void initState() {
    _timerActive = true;
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final bool lockedState = await _getScreenLockedState();

    if (state == AppLifecycleState.paused) {

      if (!lockedState) {
        if (settings['strictMode'] == 1) {
          _timerActive = false;
        }
      }
    } else if (state == AppLifecycleState.resumed) {
      if (!_timerActive) {
        Future.delayed(Duration(seconds: 3));
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(initialPage: 1)));
      }
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onPop,
      child: Scaffold(
          backgroundColor: Color.fromRGBO(242, 243, 246, 1),
          body: Hero(
              tag: 'plantWidgetHero',
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  top: 30,
                  left: 30,
                  right: 30,
                  bottom: 25,
                ),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(242, 243, 246, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color.fromRGBO(5, 5, 5, 0.05),
                          blurRadius: 20,
                          spreadRadius: 3,
                          offset: Offset(10, 10)
                      ),
                      BoxShadow(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                          blurRadius: 20,
                          spreadRadius: 3,
                          offset: Offset(-10, -10)
                      )
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _TimerWidget(),
                    _StopButton(),
                    Transform.translate(
                      offset: Offset(0, 3),
                      child: Container(
                        child: Image.asset(
                          'assets/plants/$plantState.png',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 30
                      ),
                      child: Image.asset(
                        'assets/plants/pot.png',
                      ),
                    )
                  ],
                ),
              )
          )
      )
    );
  }
}

class _StopButton extends StatefulWidget {

  @override
  _StopButtonState createState() => _StopButtonState();
}

class _StopButtonState extends State<_StopButton> {

  bool _stopButtonDown = false;
  double _stopButtonProgress = 0.0;

  void updatePlayButtonProgress() async {
    while (_stopButtonDown) {
      setState(() { _stopButtonProgress += 0.008; });

      if (_stopButtonProgress >= 1.1) {
        setState(() { _stopButtonProgress = 0; });
        _timerActive = false;
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(initialPage: 1)));
      }

      await Future.delayed(Duration(milliseconds: 1));
    }
    _stopButtonProgress = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
          alignment: Alignment.topCenter,
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(-2, -2),
                child: SizedBox(
                  width: 85,
                  height: 85,
                  child: CircularProgressIndicator(
                    value: _stopButtonProgress,
                  ),
                ),
              ),
              GestureDetector(
                  onTapDown: (details) {
                    _stopButtonDown = true;
                    updatePlayButtonProgress();
                  },

                  onTapUp: (details) {
                    _stopButtonDown = false;
                    setState(() { _stopButtonProgress = 0; });
                  },

                  onTapCancel: () {
                    _stopButtonDown = false;
                    setState(() {  _stopButtonProgress = 0; });
                  },

                  child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 161, 140, 1),
                          borderRadius: BorderRadius.circular(1000),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Color.fromRGBO(5, 5, 5, 0.15),
                                blurRadius: 15,
                                spreadRadius: 1,
                                offset: Offset(4, 4)
                            ),
                            BoxShadow(
                                color: Color.fromRGBO(255, 255, 255, 0.8),
                                blurRadius: 15,
                                spreadRadius: 1,
                                offset: Offset(-4, -4)
                            )
                          ]
                      ),
                      child: Icon(Icons.pause)
                  )
              )
            ],
          )
      ),
    );
  }
}

class _TimerWidget extends StatefulWidget {

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<_TimerWidget> {

  List<String> _countTimer = ['00', '00'];
  int _trackTimeInSeconds = 0;
  int timeNow = 0;
  int lastTrackedTime = 0;
  Timer _timer;

  void update() async {
    int timeNow = new DateTime.now().millisecondsSinceEpoch;

    if (timeNow - lastTrackedTime < 1000) { return; }

    _trackTimeInSeconds += Duration(milliseconds: timeNow - lastTrackedTime).inSeconds;

    if (_trackTimeInSeconds < 14400) {
      focusTime += timeNow - lastTrackedTime;

    } else {
      focusTime += (timeNow - lastTrackedTime) ~/ 10;
    }

    totalTime += timeNow - lastTrackedTime;
    lastTrackedTime = timeNow;

    setState(() => updateCountTimer());

    writeFile(File().focusTimeMillis, focusTime);
    writeFile(File().totalTimeMillis, totalTime);

  }

  @override
  void initState() {
    lastTrackedTime = new DateTime.now().millisecondsSinceEpoch;
    _timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      if (!_timerActive) { _timer.cancel(); _trackTimeInSeconds = 0; lastTrackedTime = 0; return; }
      update();
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  void updateCountTimer() {
    if (_trackTimeInSeconds > 3600) {
      int hours = Duration(seconds: _trackTimeInSeconds).inHours;
      int minutes = _trackTimeInSeconds % 3600;

      if (hours < 10) { _countTimer[0] = '0' + hours.toString(); }
      else { _countTimer[0] = hours.toString(); }

      if (minutes < 10) { _countTimer[0] = '0' + minutes.toString(); }
      else { _countTimer[1] = minutes.toString(); }

    } else {
      int minutes = Duration(seconds: _trackTimeInSeconds).inMinutes;
      int seconds = _trackTimeInSeconds % 60;

      if (minutes < 10) { _countTimer[0] = '0' + minutes.toString(); }
      else { _countTimer[0] = minutes.toString(); }

      if (seconds < 10) { _countTimer[1] = '0' + seconds.toString(); }
      else { _countTimer[1] = seconds.toString(); }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(
                left: 20,
                right: 20
            ),
            child: Text(
              '${_countTimer[0]}:${_countTimer[1]}',
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.none,
                height: 1.8,
                fontFamily: 'Lato',
                fontSize: 80,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
                letterSpacing: 1.8,
              ),
            ),
          )
      ),
    );
  }
}