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
