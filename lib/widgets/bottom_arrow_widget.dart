import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:spm_countdown/main.dart';

class BottomArrowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(
                bottom: 10
            ),
            child: GestureDetector(
                onTap: () { HomeScreenState.pageController.animateToPage(1, duration: Duration(milliseconds: 600), curve: Curves.easeInOut); },
                child: FlareActor(
                  'assets/arrow_up_black.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: 'move',
                )
            )
        ),
      ),
    );
  }

}