// import 'package:flutter/material.dart';
// import 'package:seymo_pay_mobile_application/ui/widgets/tag_buttons.dart';

// enum ReminderType { sms, call, f2f }

// class DefaultReminders extends StatefulWidget {
//   final TextEditingController amountController;
//   final TextEditingController paymentMeansController;
//   final TextEditingController consequenceController;
//   final Function(String) updateDate;
//   const DefaultReminders(
//       {super.key,
//       required this.amountController,
//       required this.updateDate,
//       required this.paymentMeansController,
//       required this.consequenceController});

//   @override
//   State<DefaultReminders> createState() => _DefaultRemindersState();
// }

// class _DefaultRemindersState extends State<DefaultReminders> {
//   List<String> selectedPaymentsMethods = [];

//   // Payment Methods
//   List<String> paymentMethods = ["Cash", "Mobile Money", "Other"];

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController amountController = widget.amountController;
//     Function(String) updateDate = widget.updateDate;
//     TextEditingController paymentMeansController =
//         widget.paymentMeansController;
//     TextEditingController consequenceController = widget.consequenceController;
//     return const Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TagToggleButtons(tags: [
//           "Amount",
//           "Deadline",
//           "Name",
//           "Payment Means",
//           "Moral Appeal",
//           "Call to Action",
//           "Consequences",
//           "Invite to Office"
//         ]),
//         SizedBox(height: 20),
//         Divider(),
//       ],
//     );
//   }
// }
