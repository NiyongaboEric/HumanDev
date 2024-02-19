
import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/parent.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';

import '../../../../../utilities/navigation.dart';
import 'student_list_reminder.dart';

class SMSReminder extends StatefulWidget {
  const SMSReminder({super.key});

  @override
  State<SMSReminder> createState() => _SMSReminderState();
}

class _SMSReminderState extends State<SMSReminder> {
  @override
  Widget build(BuildContext context) {
    List<SMSReminderModel> smsReminders = [
      SMSReminderModel(
        title: "Manually select",
        icon: Image.asset("assets/icons/select.png"),
        action: () {
          nextScreen(
              context: context,
              screen: const SMSReminderStudentListScreen());
        },
      ),
      SMSReminderModel(
        title: "Behind payment schedule",
        icon: Image.asset("assets/icons/schedule.png"),
        action: () {
          nextScreen(
              context: context,
              screen: const SMSReminderStudentListScreen());
        },
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: Text("SMS Reminder",
            style: TextStyle(color: SecondaryColors.secondaryOrange)),
        centerTitle: true,
        backgroundColor: Colors.orange.shade100,
      ),
      body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          const SizedBox(height: 30),
          ...smsReminders.map(
            (smsReminder) => Column(
              children: [
                InkWell(
                  onTap: smsReminder.action,
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange.shade100,
                      // Shadow
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 5), // changes position of shadow
                        ),
                      ]
                    ),
                    child: Center(
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            smsReminder.icon,
                            const SizedBox(width: 10),
                          ],
                        ),
                        title: Text(
                          smsReminder.title,
                          style: TextStyle(
                            fontSize: CustomFontSize.medium,
                            color: SecondaryColors.secondaryOrange,
                          ),
                        ),
                      ),
                    )
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SMSReminderModel {
  final String title;
  final Widget icon;
  final Function() action;

  SMSReminderModel({
    required this.title,
    required this.icon,
    required this.action,
  });
}
