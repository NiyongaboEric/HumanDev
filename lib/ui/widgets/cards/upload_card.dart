import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';

import '../../utilities/custom_colors.dart';

class UploadCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? borderColor;
  final Function() onPressed;
  const UploadCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        // Dashed Border
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          border: Border.all(
            color: borderColor?.withOpacity(0.5) ?? CustomColor.grey,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: borderColor,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: CustomFontSize.small,
                color: borderColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
