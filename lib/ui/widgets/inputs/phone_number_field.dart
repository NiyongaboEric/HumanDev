import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/custom_colors.dart';

class CustomPhoneNumberField extends StatefulWidget {
  final String? initialValue;
  final Function(PhoneNumber)? onChanged;
  final void Function(dynamic)? onCountryChanged;
  final TextEditingController controller;
  final Color? color;
  final Color? fillColor;
  final double? fontSize;
  final bool? isDense;
  final double? heightSize;

  const CustomPhoneNumberField({
    super.key,
    this.onChanged,
    this.initialValue,
    required this.controller,
    this.color,
    this.fillColor,
    this.fontSize,
    this.isDense,
    this.heightSize,
    this.onCountryChanged,
  });

  @override
  State<CustomPhoneNumberField> createState() => _CustomPhoneNumberFieldState();
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  PhoneNumber? number;

  @override
  void initState() {
    // TODO: implement initState
    // if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
    //   number =
    //       PhoneNumber.fromCompleteNumber(completeNumber: widget.initialValue!);
    //   widget.controller.text = number!.number;
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
    //   number =
    //       PhoneNumber.fromCompleteNumber(completeNumber: widget.initialValue!);
    //   widget.controller.text = number!.number;
    // }
    return SizedBox(
      // height: widget.heightSize ?? 80,
      child: IntlPhoneField(
        // controller: widget.controller,
        keyboardType: TextInputType.number,
        initialValue: widget.initialValue,
        style: const TextStyle(fontSize: 24),
        dropdownTextStyle: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          counterText: "",
          hintStyle: TextStyle(
              color: Colors.grey.shade400, fontWeight: FontWeight.normal),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color ?? CustomColor.primaryDark,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color ?? CustomColor.primaryDark,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color ?? CustomColor.primaryDark,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color ?? CustomColor.primaryDark,
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color ?? CustomColor.primaryDark,
            ),
          ),
          filled: true,
          isDense: widget.isDense,
          fillColor: widget.fillColor ?? Colors.white.withOpacity(0.6),
        ),
        initialCountryCode: number?.countryISOCode ?? 'GH',
        onChanged: widget.onChanged,
        validator: (value) {
          if (value!.number.isEmpty) {
            return "Please enter your phone number";
          }
          if (!value.isValidNumber()) {
            return "Please enter a valid phone number";
          }
          // Invalidate if contains letters, spaces or special characters
          if (value.number.contains(RegExp(r'[a-zA-Z]')) ||
              value.number.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ||
              value.number.contains(RegExp(r'\s+'))) {
            return "Please enter a valid phone number";
          }
          return null;
        },
        onCountryChanged: widget.onCountryChanged,
      ),
    );
  }
}

class GenericPhoneNumberField extends StatefulWidget {
  final String? initialValue;
  final Function(PhoneNumber)? onChanged;
  final void Function(dynamic)? onCountryChanged;
  final Color? color;
  final Color? fillColor;
  final double? fontSize;
  final bool? isDense;
  final double? heightSize;

  const GenericPhoneNumberField({
    super.key,
    this.onChanged,
    this.initialValue,
    this.color,
    this.fillColor,
    this.fontSize,
    this.isDense,
    this.heightSize,
    this.onCountryChanged,
  });

  @override
  State<GenericPhoneNumberField> createState() =>
      _GenericPhoneNumberFieldState();
}

class _GenericPhoneNumberFieldState extends State<GenericPhoneNumberField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IntlPhoneField(
        keyboardType: TextInputType.number,
        initialValue: widget.initialValue,
        style: const TextStyle(fontSize: 24),
        dropdownTextStyle: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          counterText: "",
          hintStyle: TextStyle(
              color: Colors.grey.shade400, fontWeight: FontWeight.normal),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color ?? CustomColor.primaryDark,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color ?? CustomColor.primaryDark,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color ?? CustomColor.primaryDark,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color ?? CustomColor.primaryDark,
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color ?? CustomColor.primaryDark,
            ),
          ),
          filled: true,
          isDense: widget.isDense,
          fillColor: widget.fillColor ?? Colors.white.withOpacity(0.6),
        ),
        onChanged: widget.onChanged,
        onCountryChanged: widget.onCountryChanged,
      ),
    );
  }
}
