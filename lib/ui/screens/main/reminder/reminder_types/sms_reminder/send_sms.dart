import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_request.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_area.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/pickers/date_picker.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/pickers/time_picker.dart';

import '../../../../../../data/constants/logger.dart';
import '../../../../../utilities/colors.dart';
import '../../../../../utilities/navigation.dart';
import '../../../../home/homepage.dart';
import '../../blocs/reminder_bloc.dart';

class SendSMS extends StatefulWidget {
  const SendSMS({super.key});

  @override
  State<SendSMS> createState() => _SendSMSState();
}

class _SendSMSState extends State<SendSMS> {
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
  void _logReminder(ReminderRequest reminderRequest) {
    context.read<ReminderBloc>().add(
          AddNewReminderEvent(ReminderRequest(
            type: reminderRequest.type,
            attendeePersonIds: reminderRequest.attendeePersonIds,
            message: messageController.text.isNotEmpty
                ? messageController.text
                : null,
            scheduledTime: isSelected[1]
                ? DateTime(
                        date.year, date.month, date.day, time.hour, time.minute)
                    .toString()
                : DateTime.now().toString(),
            expandRelations: false,
          )),
        );
  }

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

  // Update Date
  updateDate(DateTime date) {
    setState(() {
      this.date = date;
    });
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
          backgroundColor: Colors.orange.shade50,
          appBar: AppBar(
            title: Text("Send SMS",
                style: TextStyle(
                  color: SecondaryColors.secondaryOrange,
                )),
            centerTitle: true,
            backgroundColor: Colors.orange.shade100,
            actions: [
              IconButton(
                  onPressed: () {
                    if (state.reminderRequest != null) {
                      if (messageController.text.isEmpty) {
                        GFToast.showToast(
                          "Please enter a message",
                          context,
                          toastPosition:
                              MediaQuery.of(context).viewInsets.bottom != 0
                                  ? GFToastPosition.TOP
                                  : GFToastPosition.BOTTOM,
                          toastBorderRadius: 12.0,
                          toastDuration: 5,
                          backgroundColor: Colors.red,
                        );
                      } else {
                        _logReminder(state.reminderRequest!);
                      }
                    }
                  },
                  icon: const Icon(Icons.check))
            ],
          ),
          // floatingActionButton: ,
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              const SizedBox(height: 10),
              Text("Recipients (parents): ",
                  style: TextStyle(
                    fontSize: CustomFontSize.small,
                    color: SecondaryColors.secondaryOrange,
                  )),
              Text(
                state.recipients?.join(", ") ?? "",
                maxLines: expandRecipients ? 100 : 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: CustomFontSize.medium,
                  fontWeight: FontWeight.w500,
                  color: SecondaryColors.secondaryOrange,
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         setState(() {
              //           expandRecipients = !expandRecipients;
              //         });
              //       },
              //       child: Text(
              //         expandRecipients ? "see less" : "see more",
              //         // Underline text
              //         style: TextStyle(
              //           decoration: TextDecoration.underline,
              //           fontSize: CustomFontSize.extraSmall,
              //           color:
              //               SecondaryColors.secondaryOrange.withOpacity(0.65),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              const SizedBox(height: 30),
              CustomTextArea(
                color: SecondaryColors.secondaryOrange,
                hintText: "Message",
                controller: messageController,
              ),
              const SizedBox(height: 30),
              ToggleButtons(
                isSelected: isSelected,
                onPressed: toggleForm,
                fillColor: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
                selectedBorderColor: Colors.orange.shade200,
                selectedColor: SecondaryColors.secondaryOrange,
                color: SecondaryColors.secondaryOrange.withOpacity(0.6),
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
                            borderColor: SecondaryColors.secondaryOrange,
                            pickerColor: Colors.orange,
                            date: date,
                            onSelect: updateDate,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            // FocusScope.of(context).unfocus();
                            updateTime(time);
                          },
                          child: TimePicker(
                            bgColor: Colors.white.withOpacity(0.3),
                            borderColor: SecondaryColors.secondaryOrange,
                            pickerColor: Colors.orange,
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
                    backgroundColor: Colors.orange.shade100,
                    onPressed: !state.isLoading
                        ? () {
                            // TODO: implement logReminder
                            if (state.reminderRequest != null) {
                              if (messageController.text.isEmpty) {
                                GFToast.showToast(
                                  "Please enter a message",
                                  context,
                                  toastPosition: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom !=
                                          0
                                      ? GFToastPosition.TOP
                                      : GFToastPosition.BOTTOM,
                                  toastBorderRadius: 12.0,
                                  toastDuration: 5,
                                  backgroundColor: Colors.red,
                                );
                              } else {
                                _logReminder(state.reminderRequest!);
                              }
                            }
                            // if (messageController.text.isEmpty) {
                            //   GFToast.showToast(
                            //     "Please enter a message",
                            //     context,
                            //     toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0
                            // ? GFToastPosition.TOP
                            // : GFToastPosition.BOTTOM,
                            //     toastBorderRadius: 12.0,
                            //     toastDuration: 5,
                            //     backgroundColor: Colors.red,
                            //   );
                            //   return;
                            // }
                            // GFToast.showToast(
                            //   "SMS successfully sent",
                            //   context,
                            //   toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0
                            // ? GFToastPosition.TOP
                            // : GFToastPosition.BOTTOM,
                            //   toastBorderRadius: 12.0,
                            //   toastDuration: 5,
                            //   backgroundColor: Colors.green.shade700,
                            // );
                            // nextScreenAndRemoveAll(
                            //     context: context, screen: HomePage());
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
                                  color: SecondaryColors.secondaryOrange,
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
