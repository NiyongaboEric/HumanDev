import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/custom_colors.dart';

class CustomPhoneNumberField extends StatelessWidget {
  final String? initialValue;
  final String? countryCode;
  final Function(PhoneNumber)? onChanged;
  final void Function(Country)? onCountryChanged;
  final TextEditingController controller;
  final Color? color;
  final Color? fillColor;
  final double? fontSize;
  final bool? isDense;
  final double? heightSize;

  CustomPhoneNumberField({
    super.key,
    this.onChanged,
    this.initialValue,
    this.countryCode,
    required this.controller,
    this.color,
    this.fillColor,
    this.fontSize,
    this.isDense,
    this.heightSize,
    this.onCountryChanged,
  });

  PhoneNumber? number;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: widget.heightSize ?? 80,
      child: Column(
        children: [
          IntlPhoneField(
            controller: controller,
            keyboardType: TextInputType.phone,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: initialValue,
            style: const TextStyle(fontSize: 24),
            dropdownTextStyle: const TextStyle(fontSize: 24),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: "",
              hintStyle: TextStyle(
                  color: Colors.grey.shade400, fontWeight: FontWeight.normal),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: color ?? CustomColor.primaryDark,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: color ?? CustomColor.primaryDark,
                ),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: color ?? CustomColor.primaryDark,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: color ?? CustomColor.primaryDark,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: color ?? CustomColor.primaryDark,
                ),
              ),
              filled: true,
              isDense: isDense,
              fillColor: fillColor ?? Colors.white.withOpacity(0.6),
            ),
            initialCountryCode: "GH",
            onChanged: onChanged,
            validator: (value) {
              if (value != null && value.number.isEmpty) {
                logger.e("Please enter your phone number");
                return "Please enter your phone number";
              }
              if (value != null && !value.isValidNumber()) {
                logger.e("Please enter a valid phone number");
                return "Please enter a valid phone number";
              }
              if (value is NumberTooShortException) {
                logger.e("Please enter a valid phone number");
                return "Please enter a valid phone number";
              }
              return null;
            },
            onCountryChanged: onCountryChanged,
          ),
        ],
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
