import 'package:flutter/services.dart';
import 'package:spm_countdown/main.dart';

Future<dynamic> writeFile(String filename, int data) async {
  try {
    await platform.invokeMethod('writeFile', {'filename': filename, 'data': data});

  } on PlatformException {
    // TODO
  }
}

Future<dynamic> readFile(String filename) async {
  dynamic result;

  try {
    result = await platform.invokeMethod('readFile', {'filename': filename});

  } on PlatformException {
    // TODO
  }

  return result;
}

Future<bool> fileExists(String filename) async {
  bool result;

  try {
    result = await platform.invokeMethod('fileExists', {'filename': filename});

  } on PlatformException {
    // TODO
  }

  return result;
}

Future<void> removeFile(String filename) async {
  await platform.invokeMethod('removeFile', {'filename': filename});
}