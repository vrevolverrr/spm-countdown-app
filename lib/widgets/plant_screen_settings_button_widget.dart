import 'package:flutter/material.dart';
import 'package:spm_countdown/widgets/settings_screen_widget.dart';

class PlantSettingsButton extends StatefulWidget {

  _PlantSettingsButton createState() => _PlantSettingsButton();
}

class _PlantSettingsButton extends State<PlantSettingsButton> {

  bool _tapDown = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(
            top: 20,
            right: 20
        ),
        child: GestureDetector(
          onTapDown: (_) { setState(() { _tapDown = true; }); },
          onTapUp: (_) { setState(() { _tapDown = false; });},
          onTapCancel: () { setState(() { _tapDown = false; }); },
          onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen())); },
          child: Icon(
              Icons.settings,
              color: (_tapDown) ? Colors.grey[600] : Colors.grey[800]
          ),
        )
      ),
    );
  }
}