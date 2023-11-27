import 'package:flutter/material.dart';

class CustomTextArea extends StatefulWidget {
  final Color color;
  final String hintText;
  final bool? obscureText;
  final int? maxLines;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final TextInputType? inputType;
  final Color? fillColor;

  const CustomTextArea({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.inputType,
    this.obscureText,
    required this.color,
    this.onChanged,
    this.maxLines,
    this.fillColor
  });

  @override
  State<CustomTextArea> createState() => _CustomTextAreaState();
}

class _CustomTextAreaState extends State<CustomTextArea> {
  bool? textVisibility;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines ?? 8,
      keyboardType: widget.inputType ?? TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: widget.color,
      style: TextStyle(fontSize: 24, color: widget.color),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: Colors.grey.shade400, fontWeight: FontWeight.normal),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
        fillColor: widget.fillColor ?? Colors.white.withOpacity(0.5),
      ),
      validator: widget.validator,
    );
  }
}
