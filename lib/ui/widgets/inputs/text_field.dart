import 'package:flutter/material.dart';

import '../../utilities/custom_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool? obscureText;
  final Color color;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final TextInputType? inputType;
  final Color? fillColor;
  final double? hintTextSize;
 
  const CustomTextField({
    super.key,
    this.obscureText,
    required this.hintText,
    required this.controller,
    this.validator,
    this.inputType,
    this.onChanged,
    required this.color,
    this.fillColor,
    this.hintTextSize
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool? textVisibility;
  // Handle text visibility
  handleTextVisibility() {
    if (textVisibility == null) {
      setState(() {
        textVisibility = widget.obscureText;
      });
    }
    setState(() {
      textVisibility = !textVisibility!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    textVisibility = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: widget.controller,
        obscureText: textVisibility ?? false,
        keyboardType: widget.inputType ?? TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: widget.color,
        style: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: Colors.grey.shade400, fontWeight: FontWeight.normal, fontSize: widget.hintTextSize),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color.withOpacity(0.5),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
              color: widget.color.withOpacity(0.5),
            ),),
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
              color: widget.color.withOpacity(0.5),
            ),),
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
              color: widget.color.withOpacity(0.5),
            ),),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
              color: widget.color.withOpacity(0.5),
            ),),
          filled: true,
          fillColor:  widget.fillColor ?? Colors.white.withOpacity(0.6),
          suffixIcon: textVisibility != null
              ? IconButton(
                  onPressed: handleTextVisibility,
                  icon: Icon(
                    textVisibility!
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                        color: widget.color ?? CustomColor.primaryDark,
                  ),
                )
              : null,
        ),
        validator: widget.validator,
        onChanged: widget.onChanged,
      ),
    );
  }
}
