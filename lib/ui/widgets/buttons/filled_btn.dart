import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/custom_colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';

enum BtnVariant { primary, secondary, danger }

enum BtnSize { sm, md, lg, xl }

class FilledBtn extends StatefulWidget {
  final String text;
  final bool loading;
  final Function()? onPressed;
  final BtnVariant? btnVariant;
  final BtnSize? btnSize;
  final Color? color;
  final Color? textColor;
  const FilledBtn({
    super.key,
    this.color,
    this.btnSize,
    this.textColor,
    this.onPressed,
    required this.text,
    required this.loading,
    this.btnVariant,
  });

  @override
  State<FilledBtn> createState() => _FilledBtnState();
}

class _FilledBtnState extends State<FilledBtn> {
  @override
  void initState() {
    // TODO: implement initState
    logger.d(widget.color);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String text = widget.text;
    bool loading = widget.loading;
    Function()? onPressed = widget.onPressed;
    BtnVariant? btnVariant = widget.btnVariant;
    BtnSize? btnSize = widget.btnSize;
    Color? textColor = widget.textColor;
    // Color? color = Colors.black.withOpacity(0.65);
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        backgroundColor: widget.color ?? CustomColor.primaryDark,
        elevation: 5,
        // maximumSize:
        //     getSize(btnSize) ?? const Size(double.infinity, double.infinity),
      ),
      // btnVariant == BtnVariant.primary
      //     ? CustomColor.primaryDark
      //     : btnVariant == BtnVariant.secondary
      //         ? CustomColor.secondaryDark
      //         : CustomColor.red),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Container(),
          loading
              ? const SizedBox(
                  width: 20,
                )
              : Container(),
          Text(
            text,
            style: TextStyle(
                fontSize: CustomFontSize.large,
                color: widget.textColor ?? Colors.white
                // Colors.black.withOpacity(0.65),
                ),
          ),
        ],
      ),
    );
  }

  // Button Size
  Size getSize(BtnSize? btnSize) {
    switch (btnSize) {
      case BtnSize.sm:
        return const Size(75, 40); // Normalize the constraints
      case BtnSize.md:
        return const Size(100, 55); // Normalize the constraints
      case BtnSize.lg:
        return const Size(125, 70); // Normalize the constraints
      case BtnSize.xl:
        return const Size(150, 75); // Normalize the constraints
      default:
        return const Size(double.infinity, double.infinity);
    }
  }

// Font Size Based on Button Size
  double getFontSize(BtnSize? btnSize) {
    switch (btnSize) {
      case BtnSize.sm:
        return 14;
      case BtnSize.md:
        return 24;
      case BtnSize.lg:
        return 24;
      case BtnSize.xl:
        return 24;
      default:
        return 16;
    }
  }
}
