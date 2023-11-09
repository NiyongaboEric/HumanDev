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
import 'package:seymo_pay_mobile_application/ui/widgets/toggle_tags.dart';

import '../../../../../../data/constants/logger.dart';
import '../../../../../../data/reminders/model/reminder_request.dart';
import '../../../../../widgets/inputs/text_area.dart';
import '../../blocs/reminder_bloc.dart';

class LogConversation extends StatefulWidget {
  final PersonModel parent;

  const LogConversation({super.key, required this.parent});

  @override
  State<LogConversation> createState() => _LogConversationState();
}

class _LogConversationState extends State<LogConversation> {
  DateTime date = DateTime.now();
  final List<String> location = [
    "Office",
    "Parent's home",
    "In public",
    "Other"
  ];
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
    "Learning progress",
    "Attendance",
    "Health",
    "Behaviour",
    "Other"
  ];
  final List<ToggleTagComponents> atmosphere = [
    // "Friendly",
    // "Hostile",
    // "Owning it",
    // "Excuses",
    ToggleTagComponents(positive: "Friendly", negative: "Hostile"),
    ToggleTagComponents(positive: "Owning it", negative: "Excuses")
  ];
  final List<String> selectedLocation = [];
  final List<String> selectedFinancials = [];
  final List<String> selectedWarnings = [];
  final List<String> selectedKids = [];
  final List<String> selectedAtmosphere = [];

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
            ...selectedLocation.map((tag) => Tags(name: tag)),
            ...selectedFinancials.map((tag) => Tags(name: tag)),
            ...selectedWarnings.map((tag) => Tags(name: tag)),
            ...selectedKids.map((tag) => Tags(name: tag)),
            ...selectedAtmosphere.map((tag) => Tags(name: tag)),
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
      logger.e(state.errorMessage ?? "Error");
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
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(
              sectionTitle,
              style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: SecondaryColors.secondaryYellow,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ReminderTags(
          tags: tags,
          selectedTags: selectedTags,
          defaultColor: Colors.amber.shade50,
          btnColor: const Color(0xFFFAD215),
          textColor: SecondaryColors.secondaryYellow,
          unselectedTagBg: SecondaryColors.secondaryYellow.withOpacity(0.5),
          unselectedTextColor: SecondaryColors.secondaryYellow.withOpacity(0.5),
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

  Widget buildToggleTagSection(List<ToggleTagComponents> toggleTags,
      String sectionTitle, IconData icon, List<String> selectedTags) {
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
                color: SecondaryColors.secondaryYellow,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ToggleTags(
          tags: toggleTags,
          selectedTags: selectedTags,
          defaultColor: Colors.amber.shade50,
          btnColor: const Color(0xFFFAD215),
          textColor: SecondaryColors.secondaryYellow,
          unselectedTagBg: SecondaryColors.secondaryYellow.withOpacity(0.5),
          unselectedTextColor: SecondaryColors.secondaryYellow.withOpacity(0.5),
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
          backgroundColor: Colors.amber.shade50,
          appBar: AppBar(
            title: const Text('Log conversation'),
            centerTitle: true,
            backgroundColor: Colors.amber.shade100,
            iconTheme: IconThemeData(color: SecondaryColors.secondaryYellow),
            actions: [
              IconButton(
                  onPressed: !state.isLoading
                      ? () {
                          if (selectedLocation.isEmpty ||
                              selectedWarnings.isEmpty ||
                              selectedFinancials.isEmpty ||
                              selectedKids.isEmpty ||
                              selectedAtmosphere.isEmpty) {
                            // Error toast
                            GFToast.showToast(
                              "Please select at least one tag from  each section",
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
                  color: SecondaryColors.secondaryYellow,
                ),
              ),
              const SizedBox(height: 32),
              DatePicker(
                pickerTimeLime: PickerTimeLime.past,
                bgColor: Colors.white.withOpacity(0.3),
                date: date,
                onSelect: updateDate,
                borderColor: SecondaryColors.secondaryYellow,
                pickerColor: Colors.amber,
              ),
              const SizedBox(height: 32),
              buildTagSection(
                location,
                selectedLocation,
                "Location",
                Icons.location_on_sharp,
              ),
              const SizedBox(height: 32),
              Text("Things discussed",
                  style: TextStyle(
                    fontSize: CustomFontSize.large,
                    fontWeight: FontWeight.w500,
                    color: SecondaryColors.secondaryYellow,
                  )),
              const SizedBox(height: 10),
              buildTagSection(
                financials,
                selectedFinancials,
                "Financials",
                Icons.monetization_on_rounded,
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 32),
              buildTagSection(
                warnings,
                selectedWarnings,
                "Warnings",
                Icons.warning_rounded,
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 32),
              buildTagSection(
                kids,
                selectedKids,
                "Kids",
                Icons.child_care_rounded,
              ),
              const SizedBox(height: 32),
              const Divider(),
              buildToggleTagSection(
                atmosphere,
                "Atmosphere",
                Icons.scatter_plot_sharp,
                selectedAtmosphere,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Text("Add your note ",
                      style: TextStyle(
                        fontSize: CustomFontSize.medium,
                        fontWeight: FontWeight.w600,
                        color: SecondaryColors.secondaryYellow.withOpacity(0.7),
                      )),
                  Text("(optional)",
                      style: TextStyle(
                        fontSize: CustomFontSize.medium,
                        color: SecondaryColors.secondaryYellow.withOpacity(0.7),
                      )),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextArea(
                hintText: 'Notes',
                maxLines: 3,
                controller: noteController,
                color: SecondaryColors.secondaryYellow,
              ),
              const SizedBox(height: 32),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                FloatingActionButton.extended(
                  backgroundColor: SecondaryColors.secondaryYellow,
                  onPressed: !state.isLoading
                      ? () {
                        if (selectedLocation.isEmpty ||
                              selectedWarnings.isEmpty ||
                              selectedFinancials.isEmpty ||
                              selectedKids.isEmpty ||
                              selectedAtmosphere.isEmpty) {
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

class ToggleTagComponents {
  final String positive;
  final String negative;

  ToggleTagComponents({
    required this.positive,
    required this.negative,
  });

  factory ToggleTagComponents.fromJson(Map<String, dynamic> json) {
    return ToggleTagComponents(
      positive: json["positive"],
      negative: json["negative"],
    );
  }
}
