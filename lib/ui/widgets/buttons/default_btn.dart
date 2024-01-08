import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';

class DefaultBtn extends StatefulWidget {
  final Function()? onPressed;
  final String? text;
  final IconData? icon;
  final Color? btnColor;
  final Color? textColor;
  final bool? isLoading;
  const DefaultBtn({
    super.key,
    this.onPressed,
    this.text,
    this.icon,
    this.btnColor,
    this.textColor,
    this.isLoading,
  });

  @override
  State<DefaultBtn> createState() => _DefaultBtnState();
}

class _DefaultBtnState extends State<DefaultBtn> {
  @override
  Widget build(BuildContext context) {
    String text = widget.text ?? "";
    IconData? icon = widget.icon;
    Color? btnColor = widget.btnColor;
    Color textColor = widget.textColor ?? Colors.white;
    bool isLoading = widget.isLoading ?? false;
    Function()? onPressed = widget.onPressed ?? () {};

    return FloatingActionButton.extended(
      backgroundColor: btnColor,
      heroTag: text.split(" ").join("_").toLowerCase(),
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, color: textColor) : null,
      label: isLoading
          ? CircularProgressIndicator(color: textColor)
          : Text(
              text,
              style: TextStyle(
                fontSize: CustomFontSize.large,
                color: textColor,
              ),
            ),
    );
  }
}
