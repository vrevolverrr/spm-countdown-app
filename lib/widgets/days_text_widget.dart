import 'package:flutter/material.dart';

class DaysText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'DAYS',
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.w300,
          shadows: <Shadow>[
            Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Color.fromARGB(155, 0, 0, 0)
            )
          ],
        ),
      ),
    );
  }
}