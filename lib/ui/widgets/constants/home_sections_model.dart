import 'package:flutter/material.dart';

class HomeSection {
  final String title;
  final Widget icon;
  final Color color;
  final Function() onPressed;

  HomeSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
  });
}
