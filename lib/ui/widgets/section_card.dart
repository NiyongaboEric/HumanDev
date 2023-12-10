import 'package:flutter/material.dart';

import '../utilities/custom_colors.dart';
import '../utilities/font_sizes.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final Color? bgColor;
  final Color? textColor;
  final Function() onPressed;
  const SectionCard({
    super.key,
    this.bgColor,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: bgColor,
                      // border: Border.all(color: CustomColor.grey),
                      borderRadius: BorderRadius.circular(20),
                      // Shadow
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 6), // changes position of shadow
                        )
                      ]),
                  child: icon,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: CustomFontSize.small,
                color: textColor ?? CustomColor.primaryLight,
              ))
        ],
      ),
    );
  }
}
