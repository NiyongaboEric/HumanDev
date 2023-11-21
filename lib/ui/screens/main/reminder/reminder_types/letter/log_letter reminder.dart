import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/home/homepage.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/pickers/date_picker.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/reminder_tags.dart';

import '../../../../../../data/constants/logger.dart';
import '../../../../../../data/reminders/model/reminder_request.dart';
import '../../../../../widgets/inputs/text_area.dart';
import '../../blocs/reminder_bloc.dart';

class LogLetterReminder extends StatefulWidget {
  final PersonModel parent;

  const LogLetterReminder({super.key, required this.parent});

  @override
  State<LogLetterReminder> createState() => _LogLetterReminderState();
}

class _LogLetterReminderState extends State<LogLetterReminder> {
  DateTime date = DateTime.now();
  final List<String> financials = [
    "Financial situation of parents",
    "New payment schedule"
  ];
  final List<String> warnings = [
    "Exam",
    "Police",
    "Suspension",
    "Sacking",
    "Other",
  ];
  final List<String> kids = [
    "Learning Progress",
    "Attendance",
    "Health",
    "Behaviour",
    "Other"
  ];
  final List<String> selectedFinancials = [];
  final List<String> selectedWarnings = [];
  final List<String> selectedKids = [];

  final TextEditingController noteController = TextEditingController();

  // Log Reminder
  void _logReminder() {
    // TODO: implement logReminder
    BlocProvider.of<ReminderBloc>(context).add(
      AddNewReminderEvent(
        ReminderRequest(
          type: "F2F",
          note: noteController.text,
          attendeePersonIds: [widget.parent.id],
          scheduledTime: date.toIso8601String(),
          tags: [
            ...selectedFinancials.map((tag) => Tags(name: tag)),
            ...selectedWarnings.map((tag) => Tags(name: tag)),
            ...selectedKids.map((tag) => Tags(name: tag)),
          ],
          expandRelations: true,
        ),
      ),
    );
  }

  // Handle Reminder State Change
  void _handleReminderStateChange(BuildContext context, ReminderState state) {
    if (state.status == ReminderStateStatus.success) {
      GFToast.showToast(
        "Reminder successfully logged",
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

  // Update date
  void updateDate(DateTime date) {
    setState(() {
      this.date = date;
    });
  }

  Widget buildTagSection(List<String> tags, List<String> selectedTags,
      String sectionTitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(
              sectionTitle,
              style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: SecondaryColors.secondaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ReminderTags(
          tags: tags,
          selectedTags: selectedTags,
          defaultColor: Colors.blue.shade50,
          btnColor: const Color(0xFF00ADEF),
          textColor: SecondaryColors.secondaryBlue,
          unselectedTagBg: SecondaryColors.secondaryBlue.withOpacity(0.5),
          unselectedTextColor: SecondaryColors.secondaryBlue.withOpacity(0.5),
          addTag: (value) {
            setState(() {
              selectedTags.add(value);
            });
          },
          removeTag: (value) {
            setState(() {
              selectedTags.remove(value);
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReminderBloc, ReminderState>(
      listener: (context, state) {
        // TODO: implement listener
        _handleReminderStateChange(context, state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.blue.shade50,
          appBar: AppBar(
            title: const Text('Log letter'),
            centerTitle: true,
            backgroundColor: Colors.blue.shade100,
            iconTheme: IconThemeData(color: SecondaryColors.secondaryBlue),
            actions: [
              IconButton(
                  onPressed: !state.isLoading
                      ? () {
                          if (selectedWarnings.isEmpty ||
                              selectedFinancials.isEmpty ||
                              selectedKids.isEmpty) {
                            // Error toast
                            GFToast.showToast(
                              "Please select at least one tag from each section",
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
                            _logReminder();
                          }
                        }
                      : null,
                  icon: const Icon(Icons.check))
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              const SizedBox(height: 20),
              Text(
                "with: ${widget.parent.firstName} ${widget.parent.lastName1}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: CustomFontSize.large,
                  color: SecondaryColors.secondaryBlue,
                ),
              ),
              const SizedBox(height: 32),
              DatePicker(
                pickerTimeLime: PickerTimeLime.past,
                bgColor: Colors.white.withOpacity(0.3),
                date: date,
                onSelect: updateDate,
                borderColor: SecondaryColors.secondaryBlue,
                pickerColor: Colors.blue,
              ),
              const SizedBox(height: 32),
              Text(
                "Things mentioned",
                style: TextStyle(
                  fontSize: CustomFontSize.large,
                  fontWeight: FontWeight.w500,
                  color: SecondaryColors.secondaryBlue,
                ),
              ),
              buildTagSection(
                financials,
                selectedFinancials,
                "Financials",
                Icons.monetization_on_rounded,
              ),
              const SizedBox(height: 32),
              Divider(
                color: SecondaryColors.secondaryBlue.withOpacity(0.3),
              ),
              buildTagSection(
                warnings,
                selectedWarnings,
                "Warnings",
                Icons.warning_rounded,
              ),
              const SizedBox(height: 32),
              Divider(
                color: SecondaryColors.secondaryBlue.withOpacity(0.3),
              ),
              buildTagSection(
                kids,
                selectedKids,
                "Kids",
                Icons.child_care_rounded,
              ),
              const SizedBox(height: 32),
              Divider(
                color: SecondaryColors.secondaryBlue.withOpacity(0.3),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Text("Add your note ",
                      style: TextStyle(
                        fontSize: CustomFontSize.medium,
                        fontWeight: FontWeight.w600,
                        color: SecondaryColors.secondaryBlue.withOpacity(0.7),
                      )),
                  Text("(optional)",
                      style: TextStyle(
                        fontSize: CustomFontSize.medium,
                        color: SecondaryColors.secondaryBlue.withOpacity(0.7),
                      )),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextArea(
                hintText: 'Notes',
                maxLines: 3,
                controller: noteController,
                color: SecondaryColors.secondaryBlue,
              ),
              const SizedBox(height: 32),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                FloatingActionButton.extended(
                  backgroundColor: SecondaryColors.secondaryBlue,
                  onPressed: !state.isLoading
                      ? () {
                          if (selectedWarnings.isEmpty ||
                              selectedFinancials.isEmpty ||
                              selectedKids.isEmpty) {
                            // Error toast
                            GFToast.showToast(
                              "Please select at least one tag from each section",
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
                            _logReminder();
                          }
                        }
                      : null,
                  label: !state.isLoading
                      ? const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: CustomFontSize.large,
                            color: Colors.white,
                          ),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                ),
              ]),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
