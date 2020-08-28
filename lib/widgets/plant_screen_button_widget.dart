import 'package:flutter/material.dart';
import 'package:spm_countdown/methods/filenames.dart';
import 'package:spm_countdown/methods/io.dart';
import 'package:spm_countdown/widgets/focusing_screen_widget.dart';

class FocusPlayButton extends StatefulWidget {

  @override
  FocusPlayButtonState createState() => FocusPlayButtonState();
}

class FocusPlayButtonState extends State<FocusPlayButton> {

  bool _playButtonDown = false;
  double _playButtonProgress = 0.0;

  void updatePlayButtonProgress() async {
    while (_playButtonDown) {
      setState(() { _playButtonProgress += 0.008; });

      if (_playButtonProgress >= 1.1) {
        setState(() { _playButtonProgress = 0; });
        writeFile(File().lastFocusTimestamp, DateTime.now().millisecondsSinceEpoch);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FocusingScreen()));
      }

      await Future.delayed(Duration(milliseconds: 1));
    }
    _playButtonProgress = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(-2, -2),
          child: SizedBox(
            width: 85,
            height: 85,
            child: CircularProgressIndicator(
              value: _playButtonProgress,
            ),
          ),
        ),
        GestureDetector(
            onTapDown: (details) {
              _playButtonDown = true;
              updatePlayButtonProgress();
            },

            onTapUp: (details) {
              _playButtonDown = false;
              setState(() { _playButtonProgress = 0; });
            },

            onTapCancel: () {
              _playButtonDown = false;
              setState(() {  _playButtonProgress = 0; });
            },

            child: Container(
                margin: EdgeInsets.only(
                    bottom: 30
                ),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(186, 247, 207, 1),
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
                child: Icon(Icons.play_arrow)
            )
        )
      ],
    );
  }
}