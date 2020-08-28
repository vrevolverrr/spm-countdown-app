import 'package:flutter/material.dart';

Widget customAlertDialog({String title, String content}) {
  assert (title != null);
  assert (content != null);

  return AlertDialog(
    title: Text(title),
    content: Text(content),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}

Widget customWidgetAlertDialog({String title, Widget content}) {
  assert (title != null);
  assert (content != null);

  return AlertDialog(
    titlePadding: EdgeInsets.only(
      top: 20,
        bottom: 0,
      left: 25,
        right: 0
    ),
    contentPadding: EdgeInsets.only(
        top: 8,
        bottom: 20,
        left: 25,
        right: 0
    ),
    title: Text(title),
    content: content,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}