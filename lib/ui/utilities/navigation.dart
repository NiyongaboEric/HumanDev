// Navigation Utilities

import 'package:flutter/material.dart';

nextScreen({required BuildContext context, required Widget screen}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

previousScreen({required BuildContext context}) {
  Navigator.pop(context);
}

nextScreenAndReplace({required BuildContext context, required Widget screen}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}

nextScreenAndRemoveAll(
    {required BuildContext context, required Widget screen}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => screen),
    (Route<dynamic> route) => false,
  );
}

// Navigate to previous screen and return data
Future<dynamic> previousScreenWithData(
    {required BuildContext context, required dynamic data}) async {
  return Navigator.pop(context, data);
}

// Navigate to next screen and get data
Future<dynamic> nextScreenAndGethData(
    {required BuildContext context, required Widget screen}) async {
  var data = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => screen));
  return data;
}
