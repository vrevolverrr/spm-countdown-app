import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spm_countdown/main.dart';

class DetailedCountdownWidget extends StatefulWidget {

  @override
  DetailedCountdownWidgetState createState() => DetailedCountdownWidgetState();
}

class DetailedCountdownWidgetState extends State<DetailedCountdownWidget> {

  static int unixTimeInMillis;

  Duration _detailedCountdownDuration;
  Timer _timer;

  final List<int> _detailedCountdown = [0, 0, 0];

  void updateDetailedCountdown() {
    _detailedCountdownDuration = Duration(milliseconds: DateTime(2021, 1, 6).difference(DateTime.fromMillisecondsSinceEpoch(unixTimeInMillis)).inMilliseconds % 86400000);
    setState(() {
      _detailedCountdown[0] = _detailedCountdownDuration.inHours;
      _detailedCountdownDuration -= Duration(hours: _detailedCountdown[0]);
      _detailedCountdown[1] = _detailedCountdownDuration.inMinutes;
      _detailedCountdownDuration -= Duration(minutes: _detailedCountdown[1]);
      _detailedCountdown[2] = _detailedCountdownDuration.inSeconds;
    });
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (unixTimeInMillis != null) {

        if (lastTimestamp != null) { unixTimeInMillis += new DateTime.now().millisecondsSinceEpoch - lastTimestamp; lastTimestamp = null;}
        unixTimeInMillis += 1000;
        updateDetailedCountdown();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    lastTimestamp = new DateTime.now().millisecondsSinceEpoch;
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            top: 50
        ),
        child: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w400,
                      shadows: <Shadow>[
                        Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Color.fromRGBO(0, 0, 0, 0.3)
                        )
                      ]
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: (_detailedCountdown[0].toString().length == 2) ?
                        '${_detailedCountdown[0].toString()} H ' : '0${_detailedCountdown[0].toString()} H '
                    ),
                    TextSpan(
                        text: (_detailedCountdown[1].toString().length == 2) ?
                        '${_detailedCountdown[1].toString()} M ' : '0${_detailedCountdown[1].toString()} M '
                    ),
                    TextSpan(
                        text: (_detailedCountdown[2].toString().length == 2) ?
                        '${_detailedCountdown[2].toString()} S' : '0${_detailedCountdown[2].toString()} S'
                    ),
                  ]
              ),
            ),
          ],
        )
    );
  }
}