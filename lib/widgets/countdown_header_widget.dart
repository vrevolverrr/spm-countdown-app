import 'package:flutter/material.dart';

class CountdownHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 70
      ),
      child: Text(
        'COUNTDOWN TO SPM',
        style: TextStyle(
            fontSize: 16,
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
            letterSpacing : 3
        ),
      ),
    );
  }
}