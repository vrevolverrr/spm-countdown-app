import 'package:flutter/material.dart';
import 'package:spm_countdown/main.dart';

class PlantHero extends StatefulWidget {

  @override
  _PlantHeroState createState() => _PlantHeroState();
}

class _PlantHeroState extends State<PlantHero> with SingleTickerProviderStateMixin {
  int _focusHours;
  int _focusMinutes;
  String _plantMotivationText;

  @override
  void initState() {
    _focusHours = Duration(milliseconds: totalTime).inHours;
    _focusMinutes = Duration(milliseconds: totalTime % 3600000).inMinutes;

    if (plantDied) {
      _plantMotivationText =
      'YOUR PLANT DIED DUE TO LACK\nOF CARE! TRY HARDER NEXT TIME!';
    } else if (totalTime == 0) {
      _plantMotivationText = 'PRESS AND HOLD THE PLAY\nBUTTON TO GET STARTED';

    } else if (plantDying){
      _plantMotivationText = 'YOUR PLANT IS GOING TO DIE!\nCARE FOR IT!';

    } else {
      _plantMotivationText = 'YOU\'RE DOING GREAT! KEEP IT UP!';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Hero(
            tag: 'plantWidgetHero',
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                  top: 20,
                  left: 30,
                  right: 30,
                  bottom: 20
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
                  Expanded(
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 25,
                              left: 20,
                              right: 20
                          ),
                          child: Text(
                            'YOUR PLANT HAS GROWN FOR A TOTAL OF $_focusHours HRS AND $_focusMinutes MINS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              height: 1.8,
                              fontFamily: 'Lato',
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.8,
                            ),
                          ),
                        )
                    ),
                  ),
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
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 30
                    ),
                    child: Text(
                      _plantMotivationText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                          height: 1.8,
                          fontFamily: 'Lato',
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.8
                      ),
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
}