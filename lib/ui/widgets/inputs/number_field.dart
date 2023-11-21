import 'package:flutter/material.dart';

class CustomNumberField extends StatefulWidget {
  final String hintText;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Color color;
  const CustomNumberField({
    super.key,
    this.obscureText,
    required this.hintText,
    required this.controller,
    this.validator,
    required this.color,
  });

  @override
  State<CustomNumberField> createState() => _CustomNumberFieldState();
}

class _CustomNumberFieldState extends State<CustomNumberField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: widget.controller,
        style: const TextStyle(fontSize: 24),
        cursorColor: widget.color,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: Colors.grey.shade400, fontWeight: FontWeight.normal),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color.withOpacity(0.5),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color.withOpacity(0.5),
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color.withOpacity(0.5),
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color.withOpacity(0.5),
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color.withOpacity(0.5),
            ),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.6),
        ),
        validator: widget.validator,
      ),
    );
  }
}
