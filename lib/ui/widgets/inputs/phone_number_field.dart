import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/custom_colors.dart';

class CustomPhoneNumberField extends StatelessWidget {
  final String? initialValue;
  final Function(PhoneNumber)? onChanged;
  final TextEditingController controller;
  final Color? color;
  const CustomPhoneNumberField({
    super.key,
    this.onChanged,
    this.initialValue,
    required this.controller,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: IntlPhoneField(
        controller: controller,
        keyboardType: TextInputType.number,
        initialValue: initialValue,
        style: const TextStyle(fontSize: 24),
        dropdownTextStyle: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          counterText: "",
          hintStyle: TextStyle(
              color: Colors.grey.shade400, fontWeight: FontWeight.normal),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
          fillColor: Colors.white.withOpacity(0.6),
        ),
        initialCountryCode: 'GH',
        onChanged: onChanged,
        validator: (value) {
          if (value!.number.isEmpty) {
            return "Please enter your phone number";
          }
          if (!value.isValidNumber()) {
            return "Please enter a valid phone number";
          }
          return null;
        },
      ),
    );
  }
}
