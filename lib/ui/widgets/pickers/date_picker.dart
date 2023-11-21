import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';

import '../../utilities/custom_colors.dart';

enum PickerTimeLime { past, future, both }

class DatePicker extends StatefulWidget {
  final DateTime date;
  final Color bgColor;
  final Color borderColor;
  final MaterialColor pickerColor;
  final Function(DateTime) onSelect;
  final Color? color;
  final PickerTimeLime pickerTimeLime;
  const DatePicker({
    super.key,
    required this.onSelect,
    required this.date,
    this.color,
    required this.bgColor,
    required this.borderColor,
    required this.pickerColor,
    required this.pickerTimeLime,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  // String date = "Select Date";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
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
            }).then((value) => {
              setState(() {
                // if (value != null) {
                //   var date = value;
                //   widget.onSelect(date);
                // }
                // Allow only past, future or both dates based on pickerTimeLine
                if (value != null) {
                  if (widget.pickerTimeLime == PickerTimeLime.past) {
                    if (value.isBefore(DateTime.now())) {
                      widget.onSelect(value); 
                    } else {
                      widget.onSelect(DateTime.now());
                      // GFToast Error
                      GFToast.showToast(
                        "Date cannot be set in the future",
                        context,
                        toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
                        toastDuration: 5,
                        toastBorderRadius: 12.0,
                        backgroundColor: CustomColor.red,
                      );
                    }
                  }
                  if (widget.pickerTimeLime == PickerTimeLime.future) {
                    if (value.isAfter(DateTime.now())) {
                      widget.onSelect(value); 
                    } else {
                      widget.onSelect(DateTime.now());
                      // GFToast Error
                      GFToast.showToast(
                        "Date cannot be set in the past",
                        context,
                        toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
                        toastDuration: 5,
                        toastBorderRadius: 12.0,
                        backgroundColor: CustomColor.red,
                      );
                    }
                  }
                  if (widget.pickerTimeLime == PickerTimeLime.both) {
                    widget.onSelect(value);
                  }
                }
              })
            });
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
              DateFormat('dd MMM yyyy').format(widget.date),
              style: TextStyle(
                fontSize: CustomFontSize.large,
                color: widget.borderColor,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Icon(
              Icons.date_range_rounded,
              color: widget.borderColor,
            )
          ],
        ),
      ),
    );
  }
}
