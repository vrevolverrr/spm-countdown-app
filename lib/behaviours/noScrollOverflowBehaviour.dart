import 'package:flutter/material.dart';

class NoOverflowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child,
      AxisDirection axisDirection) {

    return child;
  }
}