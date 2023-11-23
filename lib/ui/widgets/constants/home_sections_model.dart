import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/students.dart';

import '../../screens/main/person/parent.dart';
import '../../screens/main/reminder/reminder_types/sms_reminder/sms_reminder.dart';
import '../../screens/main/transaction_records/paid_money/payment.dart';
import '../../screens/main/transaction_records/recieved_money/received_money.dart';
import '../../utilities/navigation.dart';

class HomeButton {
  final String title;
  final Widget icon;
  final Color color;
  final Function() onPressed;

  HomeButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
  });
}

class HomeSection {
  final String title;
  final List<HomeButton> buttons;
  final Color textColor;

  HomeSection({
    required this.title,
    required this.buttons,
    required this.textColor,
  });
}

List<HomeSection> homeSections(BuildContext context) {
  List<HomeButton> logTransactions = [
    HomeButton(
      title: "Received money",
      color: const Color(0xFF0BBA74),
      icon: const Icon(
        Icons.file_download_outlined,
        color: Colors.white,
        size: 54,
      ),
      onPressed: () {
        nextScreen(context: context, screen: const ReceivedMoney());
      },
    ),
    HomeButton(
      title: "Paid money",
      color: const Color(0xFFF56359),
      icon: const Icon(
        Icons.file_upload_outlined,
        color: Colors.white,
        size: 54,
      ),
      onPressed: () {
        nextScreen(context: context, screen: const Payment());
      },
    )
  ];

  List<HomeButton> reminders = [
    HomeButton(
      title: "SMS",
      color: const Color(0xFFFF8D3A),
      icon: const Icon(
        CupertinoIcons.text_bubble_fill,
        color: Colors.white,
        size: 54,
      ),
      onPressed: () {
        nextScreen(context: context, screen: const SMSReminder());
      },
    ),
    HomeButton(
      title: "Letter",
      color: const Color(0xFF00ADEF),
      icon: const Icon(
        CupertinoIcons.mail_solid,
        color: Colors.white,
        size: 54,
      ),
      onPressed: () {
        nextScreen(
            context: context,
            screen: const Parents(
              parentSection: ParentSection.letter,
            ));
      },
    ),
    HomeButton(
      title: "Conversation",
      color: const Color(0xFFFAD215),
      icon: const Icon(
        CupertinoIcons.person_2_alt,
        color: Colors.white,
        size: 54,
      ),
      onPressed: () {
        nextScreen(
            context: context,
            screen: const Parents(
              parentSection: ParentSection.conversation,
            ));
      },
    ),
    HomeButton(
      title: "To-Do",
      color: const Color(0xFFF9977E),
      icon: Padding(
        padding: const EdgeInsets.all(20),
        child: Image.asset(
          "assets/icons/todo.png",
          color: Colors.white,
        ),
      ),
      onPressed: () {},
    )
  ];

  List<HomeButton> contacts = [
    HomeButton(
      title: "Students",
      color: const Color(0xFFF09EC5),
      icon: const Icon(
        Icons.school_rounded,
        color: Colors.white,
        size: 54,
      ),
      onPressed: () {
        nextScreen(
          context: context,
          screen: const Students(
            select: false,
            option: StudentOption.studentContact,
          ),
        );
      },
    ),
    HomeButton(
      title: "Contacts",
      color: const Color(0xFF2ECC28),
      icon: const Icon(
        Icons.groups_rounded,
        color: Colors.white,
        size: 54,
      ),
      onPressed: () {
        nextScreen(
            context: context,
            screen: const Parents(
              parentSection: ParentSection.contacts,
            ));
      },
    ),
    HomeButton(
      title: "Send SMS",
      color: const Color(0xFF1877F2),
      icon: const Icon(
        // Icons.telegram_outlined,
        CupertinoIcons.paperplane_fill,
        color: Colors.white,
        size: 54,
      ),
      onPressed: () {},
    ),
  ];

  List<HomeButton> reports = [
    HomeButton(
      title: "Transaction log",
      color: const Color(0xFF9747FF),
      icon: const Icon(
        Icons.compare_arrows_rounded,
        color: Colors.white,
        size: 54,
      ),
      onPressed: () {},
    ),
    HomeButton(
      title: "Fee status",
      color: const Color(0xFF0D9252),
      icon: const Icon(
        Icons.checklist_rounded,
        color: Colors.white,
        size: 54,
      ),
      onPressed: () {},
    )
  ];

  return [
    HomeSection(
      title: "Log transactions",
      buttons: logTransactions,
      textColor: const Color(0xFF0BBA74),
    ),
    HomeSection(
      title: "Reminders",
      buttons: reminders,
      textColor: const Color(0xFFFF8D3A),
    ),
    HomeSection(
      title: "Contacts",
      buttons: contacts,
      textColor: const Color(0xFF1877F2),
    ),
    HomeSection(
      title: "Reports",
      buttons: reports,
      textColor: const Color(0xFF9747FF),
    ),
  ];
}
