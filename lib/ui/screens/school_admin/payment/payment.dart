// import 'package:flutter/material.dart';
// import 'package:seymo_pay_mobile_application/ui/widgets/inputs/number_field.dart';

// class Payment extends StatefulWidget {
//   const Payment({super.key});

//   @override
//   State<Payment> createState() => _PaymentState();
// }

// class _PaymentState extends State<Payment> {
//   @override
//   Widget build(BuildContext context) {
//     final formKey = GlobalKey<FormState>();
//     TextEditingController amountController = TextEditingController();
//     List<String> options = ['MOMO', 'Cash', 'Other'];
//     String? selectedOption;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Form(
//           key: formKey,
//           child: ListView(
//             children: [
//               const SizedBox(height: 10),
//               const Text("Amount"),
//               const SizedBox(height: 10),
//               CustomNumberField(
//                 hintText: "Amount",
//                 controller: amountController,
//               ),
//               const SizedBox(height: 20),
//               // Radio Buttons
//               RadioListTile(
//                 value: 'MOMO',
//                 groupValue: selectedOption,
//                 title: const Text('MOMO'),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedOption = value;
//                   });
//                 },
//               ),
              
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
