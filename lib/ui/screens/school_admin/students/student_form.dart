// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/phone_number.dart';
// import 'package:seymo_pay_mobile_application/data/student/model/student_model.dart';

// import '../../../widgets/buttons/filled_btn.dart';
// import '../../../widgets/inputs/phone_number_field.dart';
// import '../../../widgets/inputs/text_field.dart';

// class StudentForm extends StatefulWidget {
//   final Student? student;
//   const StudentForm({super.key, this.student});

//   @override
//   State<StudentForm> createState() => _StudentFormState();
// }

// class _StudentFormState extends State<StudentForm> {
//   final GlobalKey<FormState> _formKey = GlobalKey<
//       FormState>(); // Form key to validate the data entered in text fields and to save the data in the text fields
//   bool loading = false;
//   // Parent Number
//   PhoneNumber? phoneNumber;

//   // Update Phone Number
//   void _updatePhoneNumber(PhoneNumber phoneNum) {
//     setState(() {
//       phoneNumber = phoneNum;
//     });
//     print(phoneNumber);
//   }

//   // Text Editing Controllers
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController classController = TextEditingController();
//   final TextEditingController parentNameController = TextEditingController();
//   final TextEditingController parentNumberController = TextEditingController();
//   final TextEditingController parentEmailController = TextEditingController();

//   @override
//   void initState() {
//     // TODO: implement initState
//     // Edit existing User
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.student != null) {
//         setState(() {
//           // nameController.text = widget.student!.name;
//           // classController.text = widget.student!.className;
//           parentNameController.text = widget.student!.parentName ?? "";
//           parentEmailController.text = widget.student!.parentEmail ?? "";
//           phoneNumber = PhoneNumber.fromCompleteNumber(
//               completeNumber: widget.student!.parentNumber ?? "");
//         });
//           print(nameController.text);
//       }
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     nameController.dispose();
//     classController.dispose();
//     parentNameController.dispose();
//     parentEmailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add New Student"),
//         centerTitle: true,
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           // Student Form
//           children: [
//             // Name
//             CustomTextField(
//                 hintText: "Name",
//                 controller: nameController,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter a name";
//                   }
//                   return null;
//                 }),
//             const SizedBox(height: 10),
//             // Class
//             CustomTextField(
//                 hintText: "Class",
//                 controller: classController,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter a class";
//                   }
//                   return null;
//                 }),
//             const SizedBox(height: 10),
//             // Parent Name
//             CustomTextField(
//                 hintText: "Parent Name",
//                 controller: parentNameController,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter a name";
//                   }
//                   return null;
//                 }),
//             const SizedBox(height: 10),
//             // Parent Number
//             CustomPhoneNumberField(
//             controller: parentNumberController,
//               onChanged: _updatePhoneNumber,
//               initialValue: phoneNumber != null ? phoneNumber!.completeNumber : "",
//             ),
//             const SizedBox(height: 10),
//             // Parent Email
//             CustomTextField(
//               hintText: "Parent Email",
//               controller: parentEmailController,
//             ),
//             const SizedBox(height: 20),
//             // Submit Button
//             FilledBtn(
//                 loading: loading,
//                 text: "Submit",
//                 btnVariant: BtnVariant.primary,
//                 onPressed: () {
//                   if (_formKey.currentState!.validate() &&
//                       phoneNumber != null &&
//                       phoneNumber!.isValidNumber()) {
//                     // Validate returns true if the form is valid, or false otherwise.
//                     Student newStudent = Student(
//                       id: "",
//                       className: classController.text,
//                       // name: nameController.text,
//                       parentName: parentNameController.text,
//                       parentNumber: phoneNumber!.completeNumber,
//                       parentEmail: parentEmailController.text,
//                     );
//                   }
//                 })
//           ],
//         ),
//       ),
//     );
//   }
// }
