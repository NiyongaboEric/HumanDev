/// To do
/// 
/// This is a Send SMS features 
/// 
/// In the mean time block remainder is used
/// It can be found here at lib\ui\screens\main\reminder\reminder_types\sms_reminder\send_sms.dart
/// 
/// Tomorrow 
/// Implement Send SMS block
/// Once API is ready we consider use code to build it properly

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_request.dart';
import 'package:seymo_pay_mobile_application/ui/screens/home/homepage.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/parent.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/reminder/blocs/reminder_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_area.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/pickers/date_picker.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/pickers/time_picker.dart';


class StudentsParentsTeachersSendSMS extends StatefulWidget {
  const StudentsParentsTeachersSendSMS({super.key, this.parentSection});

  final ParentSection? parentSection;
  @override
  State<StudentsParentsTeachersSendSMS> createState() => _SendSMSState();
}

class _SendSMSState extends State<StudentsParentsTeachersSendSMS> {
  TextEditingController messageController = TextEditingController();
  List<bool> isSelected = [true, false];
  DateTime date = DateTime.now();
  bool expandRecipients = false;
  TimeOfDay time = TimeOfDay.now();

  // Toggle Forms
  void toggleForm(int index) {
    setState(() {
      for (var i = 0; i < isSelected.length; i++) {
        if (i == index) {
          isSelected[i] = true;
        } else {
          isSelected[i] = false;
        }
      }
    });
  }

  // Log Reminder

  // Handle Reminder Change State
  void _handleReminderStateChange(BuildContext context, ReminderState state) {
    if (state.status == ReminderStateStatus.success) {
      GFToast.showToast(
        "Reminder ${isSelected[0] ? "successfully sent" : "will be sent on ${date.toString().split(" ")[0]}"} to \n${state.recipients!.length > 3 ? "${state.recipients!.getRange(0, 3).map((e) => e).join(", ")}..." : state.recipients!.map((e) => e).join(", ")}",
        context,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        toastBorderRadius: 12.0,
        toastDuration: 5,
        backgroundColor: Colors.green.shade700,
      );
      nextScreenAndRemoveAll(context: context, screen: const HomePage());
    }
    if (state.status == ReminderStateStatus.error) {
      logger.d(state.errorMessage ?? "Error");
      GFToast.showToast(
        state.errorMessage ?? "Error",
        context,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        toastBorderRadius: 12.0,
        toastDuration: 5,
        backgroundColor: Colors.red,
      );
    }
  }

  void _handleSendSMS(ReminderState state) {
    GFToast.showToast(
      "SMS ${isSelected[0] ? "successfully sent" : "will be sent on ${date.toString().split(" ")[0]}"} to \n${state.recipients!.length > 3 ? "${state.recipients!.getRange(0, 3).map((e) => e).join(", ")}..." : state.recipients!.map((e) => e).join(", ")}",
      context,
      toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
          ? GFToastPosition.TOP
          : GFToastPosition.BOTTOM,
      toastBorderRadius: 12.0,
      toastDuration: 5,
      backgroundColor: Colors.green.shade700,
    );
    nextScreenAndRemoveAll(context: context, screen: const HomePage());
  }

  // Update Date
  updateDate(DateTime date) {
    setState(() {
      this.date = date;
    });
  }

  Future<void> _showMyDialog(String? textDialog) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: SMSRecipientColors.fourthColor,
        contentTextStyle: TextStyle(color: SMSRecipientColors.primaryColor, fontSize: 18),
        // surfaceTintColor: SMSRecipientColors.primaryColor,
        title: Text('Warning', style: TextStyle(color: SMSRecipientColors.primaryColor), ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("$textDialog", style: TextStyle(color: SMSRecipientColors.primaryColor),),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok', style: TextStyle(color: SMSRecipientColors.primaryColor, fontSize: 18)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    // Update Time
    updateTime(TimeOfDay selectedTime) {
      setState(() {
        time = selectedTime;
      });
    }

    List<Widget> sendOptions = [
      SizedBox(
          width: (MediaQuery.of(context).size.width - 30) / 2,
          child: const Center(
            child: Text("Send now",
                style: TextStyle(fontSize: CustomFontSize.medium)),
          )),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 30) / 2,
        child: const Center(
          child: Text(
            "Send later",
            style: TextStyle(fontSize: CustomFontSize.medium),
          ),
        ),
      ),
    ];

    return BlocConsumer<ReminderBloc, ReminderState>(
      listener: (context, state) {
        // TODO: implement listener
        _handleReminderStateChange(context, state);
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: widget.parentSection == ParentSection.sendSMS
              ? SMSRecipientColors.fourthColor
              : Colors.orange.shade50,
          appBar: AppBar(
            title: Text("Send SMS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.parentSection == ParentSection.sendSMS
                      ? SMSRecipientColors.primaryColor
                      : SecondaryColors.secondaryOrange,
                )),
            centerTitle: true,
            backgroundColor: widget.parentSection == ParentSection.sendSMS
                ? SMSRecipientColors.secondaryColor.withOpacity(.3)
                : Colors.orange.shade100,
            actions: [
              IconButton(
                  onPressed: () {
                    if (state.reminderRequest != null) {
                      if (messageController.text.isEmpty) {
                        _showMyDialog("Please type your message first!");
                      } else {
                        _handleSendSMS(state);
                      }
                    }
                  },
                  icon: const Icon(Icons.check))
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            children: [
              const SizedBox(height: 20),
              Text("Recipients: ",
                  style: TextStyle(
                    fontSize: CustomFontSize.small,
                    color: widget.parentSection == ParentSection.sendSMS
                        ? SMSRecipientColors.primaryColor
                        : SecondaryColors.secondaryOrange,
                  )),
                const SizedBox(height: 10,),
              Text(
                state.recipients?.join(", ") ?? "",
                maxLines: expandRecipients ? 100 : 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: CustomFontSize.small,
                  fontWeight: FontWeight.w500,
                  color: widget.parentSection == ParentSection.sendSMS
                      ? SMSRecipientColors.primaryColor
                      : SecondaryColors.secondaryOrange,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextArea(
                color: widget.parentSection == ParentSection.sendSMS
                    ? SMSRecipientColors.primaryColor
                    : SecondaryColors.secondaryOrange,
                hintText: "Message",
                controller: messageController,
                fillColor: widget.parentSection == ParentSection.sendSMS
                    ? SMSRecipientColors.fifthColor
                    : Colors.orange.shade100,
              ),
              const SizedBox(height: 30),
              ToggleButtons(
                isSelected: isSelected,
                onPressed: toggleForm,
                fillColor: widget.parentSection == ParentSection.sendSMS
                    ? const Color(0xFF1877F2)
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
                selectedBorderColor:
                    widget.parentSection == ParentSection.sendSMS
                        ? SMSRecipientColors.primaryColor
                        : Colors.orange.shade200,
                selectedColor: widget.parentSection == ParentSection.sendSMS
                    ? SMSRecipientColors.fifthColor
                    : SecondaryColors.secondaryOrange,
                color: widget.parentSection == ParentSection.sendSMS
                    ? SMSRecipientColors.primaryColor
                    : SecondaryColors.secondaryOrange.withOpacity(0.6),
                children: sendOptions,
              ),
              const SizedBox(height: 30),
              isSelected[1]
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            updateDate(date);
                          },
                          child: DatePicker(
                            pickerTimeLime: PickerTimeLime.future,
                            bgColor: Colors.white.withOpacity(0.3),
                            borderColor: SMSRecipientColors.primaryColor,
                            pickerColor: Colors.lightBlue,
                            date: date,
                            onSelect: updateDate,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            updateTime(time);
                          },
                          child: TimePicker(
                            bgColor: Colors.white.withOpacity(0.3),
                            borderColor: SMSRecipientColors.primaryColor,
                            pickerColor: Colors.lightBlue,
                            time: time.format(context).toString(),
                            onSelect: updateTime,
                          ),
                        )
                      ],
                    )
                  : Container(),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                    backgroundColor:
                        widget.parentSection == ParentSection.sendSMS
                            ? const Color(0xFF1877F2)
                            : Colors.orange.shade100,
                    onPressed: !state.isLoading
                        ? () {
                            // TODO: implement logReminder
                            if (state.reminderRequest != null) {
                              if (messageController.text.isEmpty) {
                                _showMyDialog("Please type your message first!");
                              } else {
                                _handleSendSMS(state);
                              }
                            }
                          }
                        : null,
                    label: Container(
                      constraints: const BoxConstraints(minWidth: 80),
                      child: Center(
                        child: !state.isLoading
                            ? Text(
                                "Send SMS",
                                style: TextStyle(
                                  fontSize: CustomFontSize.large,
                                  color: widget.parentSection ==
                                          ParentSection.sendSMS
                                      ? Colors.white
                                      : SecondaryColors.secondaryOrange,
                                ),
                              )
                            : CircularProgressIndicator(
                                color: SecondaryColors.secondaryOrange,
                              ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
