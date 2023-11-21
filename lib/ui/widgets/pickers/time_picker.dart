import 'package:flutter/material.dart';

import '../../utilities/font_sizes.dart';

class TimePicker extends StatefulWidget {
  final String time;
  final Color bgColor;
  final Color borderColor;
  final MaterialColor pickerColor;
  final Function(TimeOfDay) onSelect;
  const TimePicker({
    super.key,
    required this.onSelect,
    required this.time,
    required this.bgColor,
    required this.borderColor,
    required this.pickerColor,
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: widget.pickerColor,
                ),
                useMaterial3: true,
                textTheme: Theme.of(context).textTheme,
              ),
              child: child!,
            );
          },
        ).then(
          (value) => {
            setState(() {
              if (value != null) {
                var time = value;
                widget.onSelect(time);
              }
            })
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 65,
        decoration: BoxDecoration(
          color: widget.bgColor,
          border: Border.all(
            color: widget.borderColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.time,
              style: TextStyle(
                fontSize: CustomFontSize.large,
                color: widget.borderColor,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Icon(
              Icons.access_time_rounded,
              color: widget.borderColor,
            )
          ],
        ),
      ),
    );
  }
}
