// import 'package:flutter/material.dart';
// import 'package:seymo_pay_mobile_application/ui/screens/school_admin/students/student_form.dart';
// import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
// import 'package:seymo_pay_mobile_application/ui/widgets/list_card.dart';

// import '../../../../data/student/model/student_model.dart';

// class StudentsScreen extends StatefulWidget {
//   const StudentsScreen({super.key});

//   @override
//   State<StudentsScreen> createState() => _StudentsScreenState();
// }

// class _StudentsScreenState extends State<StudentsScreen> {
//   List<Student> students = [
//     const Student(
//       id: "1",
//       name: "Chadwick Boseman",
//       className: "1st Grade",
//       debt: 50,
//       parentName: "Mr. Boseman",
//       parentEmail: "boseman@gmail.com",
//     ),
//     const Student(
//       id: "2",
//       name: "Michael B Jordan",
//       className: "1st Grade",
//       debt: 0,
//       parentName: "Mr. Jordan",
//       parentEmail: "jordan@gmail.com",
//     ),
//     const Student(
//       id: "3",
//       name: "Nick Cage",
//       className: "1st Grade",
//       debt: 0,
//       parentName: "Mr. Cage",
//       parentEmail: "cage@gmail.com",
//     ),
//     const Student(
//       id: "4",
//       name: "Leonardo DiCaprio",
//       className: "3rd Grade",
//       debt: 70,
//       parentName: "Mr. DiCaprio",
//       parentEmail: "dicaprio@gmail.com",
//     ),
//     const Student(
//       id: "5",
//       name: "Bobby Red",
//       className: "3rd Grade",
//       debt: 0,
//       parentName: "Mr. Red",
//       parentEmail: "red@gmail.com",
//     ),
//     const Student(
//       id: "6",
//       name: "John Cena",
//       className: "3rd Grade",
//       debt: 0,
//       parentName: "Mr. Cena",
//       parentEmail: "cena@gmail.com",
//     ),
//     const Student(
//       id: "7",
//       name: "Kurt Cobain",
//       className: "5th Grade",
//       debt: 60,
//       parentName: "Mr. Cobain",
//       parentEmail: "cobain@gmail.com",
//     ),
//     const Student(
//       id: "8",
//       name: "Michael Jordan",
//       className: "5th Grade",
//       debt: 50,
//       parentName: "Mr. Jordan",
//       parentEmail: "jordan@gmail.com",
//     ),
//     const Student(
//       id: "9",
//       name: "Snoop Dogg",
//       className: "5th Grade",
//       debt: 0,
//       parentName: "Mr. Snoop",
//       parentEmail: "snoop@gmail.com",
//     ),
//     const Student(
//       id: "10",
//       name: "Dwayne Johnson",
//       className: "5th Grade",
//       debt: 0,
//       parentName: "Mr. Johnson",
//       parentEmail: "johnson@gmail.com",
//     ),
//     const Student(
//       id: "11",
//       name: "Eminem",
//       className: "5th Grade",
//       debt: 50,
//       parentName: "Mr. Eminem",
//       parentEmail: "eminem@gmail.com",
//     )
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Students"),
//         centerTitle: true,
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           nextScreen(context: context, screen: StudentForm());
//         },
//         label: Text("Add New Student",
//           style: TextStyle(
//             fontSize: 13
//           )
//         ),
//         icon: Icon(Icons.add,
//           size: 20
//         ),
//       ),
//       body: ListView(
//         children: [
//           SizedBox(
//             height: 25,
//           ),
//           ListView.builder(
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             itemCount: students.length,
//             itemBuilder: (context, index) {
//               // Name abbreviation
//               // String name = students[index].name;
//               String initials = "";
//               // var fullName = name.split(" ");
//               for (int i = 0; i < fullName.length; i++) {
//                 initials += fullName[i].substring(0, 1);
//               }
//               return ListCard(
//                 // title: students[index].name,
//                 subtitle: students[index].className,
//                 badge:
//                     students[index].debt! < 1 ? BadgeCard.paid : BadgeCard.debt,
//                 image: CircleAvatar(
//                   child: Text(initials),
//                 ),
//                 action: IconButton(
//                   onPressed: () {
//                     nextScreen(
//                       context: context,
//                       screen: StudentForm(
//                         student: students[index],
//                       ),
//                     );
//                   },
//                   icon: const Icon(
//                     Icons.edit_document,
//                   ),
//                 ),
//               );
//             },
//           ),
//           SizedBox(
//             height: 75,
//           )
//         ],
//       ),
//     );
//   }
// }
