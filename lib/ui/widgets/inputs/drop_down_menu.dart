import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String value;
  final List options;
  final Color color;
  final Function(dynamic)? onChanged;
  const CustomDropDownMenu({
    super.key,
    required this.options,
    this.onChanged,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: DropdownButtonFormField(
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
        iconSize: 24,
        borderRadius: BorderRadius.circular(12),
        onChanged: onChanged,
        value: value,
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
          hintStyle: TextStyle(color: Colors.red),
          filled: true,
          fillColor: color.withOpacity(0.08),
        ),
      ),
    );
  }
}

class CustomDropDownMenuItem extends StatelessWidget {
  const CustomDropDownMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
