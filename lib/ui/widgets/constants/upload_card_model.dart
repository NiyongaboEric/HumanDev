import 'package:flutter/material.dart';

class UploadCardModel {
  String title;
  IconData icon;
  Function() onPressed;

  UploadCardModel({
    required this.title,
    required this.icon,
    required this.onPressed,
  });
}
