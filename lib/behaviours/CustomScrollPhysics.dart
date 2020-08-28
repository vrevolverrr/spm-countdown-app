import 'package:flutter/material.dart';

class CustomScrollPhysics extends PageScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  @override
  double get minFlingDistance => 35;

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) => CustomScrollPhysics(parent: buildParent(ancestor));
}