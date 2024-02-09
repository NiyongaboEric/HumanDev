import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/invoice/invoice_list/invoice_list.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/invoice/student_invoice/people_list.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/students.dart';

import '../../screens/main/person/parent.dart';
import '../../screens/main/reminder/reminder_types/sms_reminder/sms_reminder.dart';
import '../../screens/main/transaction_records/paid_money/payment.dart';
import '../../screens/main/transaction_records/recieved_money/received_money.dart';
import '../../utilities/navigation.dart';

class HomeButton {
  final String title;
  final Widget icon;
  // final AssetImage? image;
  final Color color;
  final Function() onPressed;

  HomeButton({
    required this.title,
    required this.icon,
    // this.image,
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
      title: "Received",
      color: const Color(0xFF0BBA74),
      icon: const Icon(
        CupertinoIcons.down_arrow,
        color: Colors.white,
        size: 50,
      ),
      onPressed: () {
        nextScreen(context: context, screen: const ReceivedMoney());
      },
    ),
    HomeButton(
      title: "Paid",
      color: const Color(0xFFF56359),
      icon: const Icon(
        CupertinoIcons.arrow_up,
        color: Colors.white,
        size: 50,
      ),
      onPressed: () {
        nextScreen(context: context, screen: const Payment());
      },
    ),
    HomeButton(
      title: "Dashboard",
      color: const Color(0XFF68D5FF),
      // icon: const Icon(
      //   Icons.monetization_on,
      //   color: Colors.white,
      //   size: 50,
      // ),
      icon: Padding(
        padding: const EdgeInsets.all(20),
        child: SvgPicture.asset(
          "assets/icons/dashboard.svg",
          color: Colors.white,
        ),
      ),
      onPressed: () {},
    )
  ];

  List<HomeButton> reminders = [
    HomeButton(
      title: "Letter",
      color: const Color(0xFF00ADEF),
      icon: const Icon(
        CupertinoIcons.mail_solid,
        color: Colors.white,
        size: 65,
      ),
      onPressed: () {
        nextScreen(
          context: context,
          screen: const Parents(
            parentSection: ParentSection.letter,
          ),
        );
      },
    ),
    HomeButton(
      title: "Conversation",
      color: const Color(0xFFFAD215),
      icon: const Icon(
        CupertinoIcons.bubble_left_bubble_right_fill,
        color: Colors.white,
        size: 54,
      ),
      onPressed: () {
        nextScreen(
          context: context,
          screen: const Parents(
            parentSection: ParentSection.conversation,
          ),
        );
      },
    ),
    HomeButton(
      title: "SMS reminder",
      color: const Color(0xFFFF8D3A),
      // icon: const Icon(
      //   CupertinoIcons.ch,
      //   color: Colors.white,
      //   size: 54,
      // ),
      icon: Padding(
        padding: const EdgeInsets.all(20),
        child: SvgPicture.asset(
          "assets/icons/SMS_reminder.svg",
          color: Colors.white,
        ),
      ),
      onPressed: () {
        nextScreen(
          context: context, 
          screen: const SMSReminder()
        );
      },
    ),
    // HomeButton(
    //   title: "To-Do",
    //   color: const Color(0xFFF9977E),
    //   icon: Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: Image.asset(
    //       "assets/icons/todo.png",
    //       color: Colors.white,
    //     ),
    //   ),
    //   onPressed: () {},
    // )
  ];

  List<HomeButton> contacts = [
    HomeButton(
      title: "Students",
      color: const Color(0xFFF09EC5),
      // icon: const Icon(
      //   Icons.s,
      //   color: Colors.white,
      //   size: 54,
      // ),
      icon: Padding(
        padding: const EdgeInsets.all(20),
        child: SvgPicture.asset(
          "assets/icons/students.svg",
          color: Colors.white,
        ),
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
      title: "All contacts",
      color: const Color(0xFF2ECC28),
      // icon: const Icon(
      //   Icons.groups_rounded,
      //   color: Colors.white,
      //   size: 54,
      // ),
      icon: Padding(
        padding: const EdgeInsets.all(20),
        child: SvgPicture.asset(
          "assets/icons/all_contacts.svg",
          color: Colors.white,
        ),
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
      onPressed: () {
        nextScreen(
          context: context,
          screen: const Parents(
            parentSection: ParentSection.sendSMS,
          ),
        );
      },
    ),
  ];

  List<HomeButton> reports = [
    HomeButton(
      title: "Transactions",
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

  List<HomeButton> invoices = [
    HomeButton(
      title: "Invoices",
      color: const Color(0xFF9747FF),
      icon: Padding(
        padding: const EdgeInsets.all(20),
        child: 
        SvgPicture.asset(
          "assets/icons/invoice_x.svg",
          color: Colors.white,
        ),
      ),

      // icon: const Icon(
      //   Icon.d,
      //   color: Colors.white,
      //   size: 54,
      // ),

      //   // AssetImage("assets/images/dropbox.png"),
      // image: AssetImage("assets/images/invoices_1.svg.png"),

      // ),
      onPressed: () {
        nextScreen(context: context, screen: const InvoiceList());
      },
    ),
    HomeButton(
      title: "Create invoice",
      color: const Color(0xFF9747FF),
      // icon: const Icon(
      //   Icons.compare_arrows_rounded,
      //   color: Colors.white,
      //   size: 54,
      // ),
      icon: Padding(
        padding: const EdgeInsets.all(20),
        child: 
        SvgPicture.asset(
          "assets/icons/invoice_y.svg",
          color: Colors.white,
        ),
      ),
      onPressed: () {},
    ),
    HomeButton(
      title: "Transactions",
      color: const Color(0xFFA2A4A0),
      // icon: const Icon(
      //   Icons.,
      //   color: Colors.white,
      //   size: 54,
      // ),
      icon: Padding(
        padding: const EdgeInsets.all(20),
        child: SvgPicture.asset(
          "assets/icons/transaction.svg",
          color: Colors.white,
        ),
      ),
      // 
      onPressed: () {},
    ),

    // HomeButton(
    //   title: "Student Invoice",
    //   color: const Color(0xFF9747FF),
    //   icon: Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: SvgPicture.asset(
    //       "assets/icons/student_invoice.svg",
    //       color: Colors.white,
    //     ),
    //   ),
    //   onPressed: () {
    //     nextScreen(
    //       context: context,
    //       screen: const PeopleListInvoice(personType: PersonType.STUDENT),
    //     );
    //   },
    // ),
    // HomeButton(
    //   title: "Third Party Invoice",
    //   color: const Color(0xFF9747FF),
    //   icon: Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: SvgPicture.asset(
    //       "assets/icons/third_party_invoice.svg",
    //       color: Colors.white,
    //     ),
    //   ),
    //   onPressed: () {
    //     nextScreen(
    //       context: context,
    //       screen: const PeopleListInvoice(personType: PersonType.THIRD_PARTY),
    //     );
    //   },
    // ),
  ];

  return [
    HomeSection(
      title: "Money",
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
    // HomeSection(
    //   title: "Reports",
    //   buttons: reports,
    //   textColor: const Color(0xFF9747FF),
    // ),
    HomeSection(
      title: "Accounting",
      buttons: invoices,
      textColor: const Color(0xFF9747FF),
    ),
  ];
}
