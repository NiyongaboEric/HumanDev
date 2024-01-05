import 'package:flutter/material.dart';

class ContactDropDownOptions extends StatelessWidget {
  final String value;
  final List options;
  final Color color;
  final Function(dynamic)? onChanged;
  const ContactDropDownOptions({
    super.key,
    required this.value,
    required this.options,
    required this.color,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: DropdownButtonFormField(
        value: value,
        items: options
            .map(
              (option) => DropdownMenuItem(
                value: option,
                enabled: option != options[0],
                child: Text(
                  option,
                  style: TextStyle(
                    color: option != options[0] ? color : Colors.grey,
                  ),
                ),
              ),
            )
            .toList(),  
        onChanged: onChanged,
        iconSize: 24,
        borderRadius: BorderRadius.circular(12),
        style: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 24, color: color),
        decoration: InputDecoration(
          counterText: '',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color.withOpacity(0.5)),
          ),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: color.withOpacity(0.5))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: color.withOpacity(0.5), width: 2)),
          errorBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.red)),
          hintStyle: const TextStyle(color: Colors.red),
          filled: true,
          fillColor: color.withOpacity(0.08),
        ),      
      )
    );
  }
}
