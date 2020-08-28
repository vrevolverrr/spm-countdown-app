import 'package:flutter/material.dart';
import 'package:spm_countdown/widgets/detailed_countdown_widget.dart';
import 'package:spm_countdown/methods/get_current_time.dart';

class DaysCountdownWidget extends StatefulWidget {

  @override
  DaysCountdownWidgetState createState() => DaysCountdownWidgetState();
}

class DaysCountdownWidgetState extends State<DaysCountdownWidget> with SingleTickerProviderStateMixin {

  int _unixTimeInMillis;
  AnimationController _daysAnimController;
  Animation _daysAnim;
  Future<int> _unixTimeFuture;

  bool initialised = false;
  String _daysCountdown = '0';
  double _daysToSPM = 0;

  @override
  void initState() {
    _daysAnimController = AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    _unixTimeFuture = fetchSPMDate();
    super.initState();
  }

  @override
  void dispose() {
    _daysAnimController.dispose();
    super.dispose();
  }

  /*

  Unix time is fetched from the API every time the widget is just built ( initState is called )
  The unix time obtained is converted to milliseconds and the value is set to the detailed countdown widget's property
  so that the detailed countdown widget can be updated preventing multiple calls of the API.

  The initialised flag is set to prevent multiple calls of the API when rebuilding the widget as it is being animated

   */

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: _unixTimeFuture,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (!initialised && snapshot.hasData) {
            _unixTimeInMillis = (snapshot.data + 28800) * 1000;
            DetailedCountdownWidgetState.unixTimeInMillis = _unixTimeInMillis;

            _daysToSPM = DateTime(2021, 1, 6).difference(DateTime.fromMillisecondsSinceEpoch(_unixTimeInMillis)).inDays.toDouble();
            _daysAnim = Tween<double>(begin: 0.0, end: _daysToSPM).animate(_daysAnimController);
            _daysAnim.addListener(() {
              setState(() {
                _daysCountdown = _daysAnim.value.toStringAsFixed(0);
              });
            });

            _daysAnimController.forward();
            initialised = true;
          }

          return Transform.translate(
            offset: Offset(-5, 0),
            child: Container(
              margin: EdgeInsets.only(
                  top: 10
              ),
              child: Text(
                _daysCountdown,
                style: TextStyle(
                  fontSize: 120,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.w300,
                  shadows: <Shadow>[
                    Shadow(
                        offset: Offset(2, 1),
                        blurRadius: 3,
                        color: Color.fromARGB(155, 0, 0, 0)
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}