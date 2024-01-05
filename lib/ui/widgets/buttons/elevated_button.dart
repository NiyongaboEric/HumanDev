import 'package:flutter/material.dart';

class ElevatedBtn extends StatelessWidget {
  ElevatedBtn({
    super.key,
    required this.handleButton,
    required this.textName,
    this.buttonStyle,
    this.textStyle,
  });

  void Function() handleButton;
  final String textName;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: handleButton,
      child: Text(
        textName,
        style: textStyle,
      ),
    );
  }
}
