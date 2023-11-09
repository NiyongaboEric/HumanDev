// import 'dart:convert';
// import 'dart:math';

// import 'package:alphabet_list_view/alphabet_list_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
// import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
// import 'package:seymo_pay_mobile_application/ui/screens/auth/auth_bloc/auth_bloc.dart';
// import 'package:seymo_pay_mobile_application/ui/screens/main/person/bloc/person_bloc.dart';
// import 'package:seymo_pay_mobile_application/ui/screens/main/reminder/blocs/sms_reminder_bloc/sms_reminder_bloc.dart';
// import 'package:seymo_pay_mobile_application/ui/screens/main/reminder/reminder_types/sms_reminder/send_sms.dart';
// import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../../../data/auth/model/auth_request.dart';
// import '../../../../../../data/auth/model/auth_response.dart';
// import '../../../../../../data/constants/shared_prefs.dart';
// import '../../../../../../data/reminders/model/reminder_model.dart';
// import '../../../../../utilities/colors.dart';
// import '../../../../../utilities/font_sizes.dart';
// import '../../../../../widgets/inputs/text_field.dart';

// var sl = GetIt.instance;

// enum ParentSection {
//   smsReminder,
//   sendSMS,
// }

// class SelectedParents extends StatefulWidget {
//   final ParentSection parentSection;
//   const SelectedParents({
//     super.key,
//     required this.parentSection,
//   });

//   @override
//   State<SelectedParents> createState() => _SelectedParentsState();
// }

// class _SelectedParentsState extends State<SelectedParents> {
//   List<RelatedPersons> selectedParents = <RelatedPersons>[];
//   List<PersonModel> students = <PersonModel>[];
//   List<RelatedPersons> relatives = <RelatedPersons>[];
//   var prefs = sl<SharedPreferences>();
//   bool showResults = false;
//   List<PersonModel> searchResults = <PersonModel>[];
//   final searchController = TextEditingController();
//   late List<AlphabetListViewItemGroup> alphabetView;
//   late List<AlphabetListViewItemGroup> searchResultAlphabetView;
//   String date = DateTime.now().toString().split(" ")[0];
//   // Select Random number from 100 to 500
//   List<int> randomNumbers = [];
//   int randomNumber = (100 + Random().nextInt(500 - 100));

//   // Search Function
//   search(String query) {
//     query = query.toLowerCase();
//     if (query.isEmpty) {
//       setState(() {
//         showResults = false;
//       });
//     } else {
//       setState(() {
//         showResults = true;
//         searchResults = students
//             .toSet()
//             .toList()
//             .where((student) =>
//                 student.firstName.toLowerCase().contains(query) ||
//                 (student.middleName ?? "").toLowerCase().contains(query) ||
//                 student.lastName1.toLowerCase().contains(query) ||
//                 (student.lastName2 ?? "").toLowerCase().contains(query))
//             .toList();
//       });
//     }
//   }

//   void addParent(List<RelatedPersons> parents) {
//     setState(() {
//       selectedParents.addAll(parents);
//     });
//   }

//   void removeParent(List<RelatedPersons> parents) {
//     setState(() {
//       for (var parent in parents) {
//         selectedParents.remove(parent);
//       }
//     });
//   }

//   // Refresh Tokens
//   void _refreshTokens() {
//     var prefs = sl<SharedPreferenceModule>();
//     TokenResponse? token = prefs.getToken();
//     if (token != null) {
//       context.read<AuthBloc>().add(
//             AuthEventRefresh(
//               RefreshRequest(refresh: token.refreshToken),
//             ),
//           );
//     }
//   }

//   // Get all student
//   getAllStudents() {
//     context.read<PersonBloc>().add(const GetAllPersonEvent());
//   }

//   // Get Relative
//   getRelatives(String studentId) {
//     context.read<PersonBloc>().add(GetRelativesEvent(studentId));
//   }

//   // Handle Person State Change
//   handlePersonStateChange(BuildContext context, PersonState state) {
//     if (state.status == PersonStatus.success) {
//       setState(() {
//         students.clear();
//       });
//       for (var student in state.students) {
//         if (student.role.toLowerCase() == "student") {
//           if (!students.contains(student)) {
//             students.add(student);
//             if (student.relatedPersons != null) {
//               relatives.addAll(student.relatedPersons!);
//             }
//             randomNumbers.add((50 + Random().nextInt(150 - 50)));
//           }
//           // getRelatives(student.id.toString());
//         }
//         students = students.toSet().toList();
//       }
//       var offlineRelatives = json.encode(students);
//       prefs.setString("relatives", offlineRelatives);
//     }
//     if (state.status == PersonStatus.error) {
//       _refreshTokens();
//     }
//   }

//   // Save Data
//   saveData() {
//     List<ReminderModel> reminderRequest = selectedParents
//         .map((parent) => ReminderModel(
//               attendeePersonId: parent.id,
//               type: "LOGGED_SMS",
//               spaceId: 1,
//             ))
//         .toList();
//     List<String> recipients =
//         selectedParents.map((e) => "${e.firstName} ${e.lastName1}").toList();
//     context.read<SMSReminderBloc>().add(
//           SaveDataSMSReminderState(
//             reminderRequest,
//             recipients,
//           ),
//         );
//   }

//   navigate(BuildContext context) {
//     List<PersonModel> studentsWithoutParentNumber = [];
//     for (var element in selectedParents) {
//       if (element.phoneNumber == null) {
//         // Find student with this parent data
//         var student = students.firstWhere(
//           (student) => student.relatedPersons?.first.id == element.id,
//         );
//         studentsWithoutParentNumber.add(student);
//       }
//     }
//     if (studentsWithoutParentNumber.isNotEmpty) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           actionsAlignment: MainAxisAlignment.center,
//           backgroundColor: Colors.orange.shade50,
//           icon: const Icon(
//             Icons.info_rounded,
//             color: Colors.red,
//             size: 56,
//           ),
//           content: Text(
//               "No phone number found for parents of: \n ${studentsWithoutParentNumber.map((element) {
//                 return "${element.firstName}${element.middleName != null && element.middleName!.isNotEmpty ? ' ' : ''}${element.middleName ?? ''} ${element.lastName1}";
//               }).join(", ")}",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: CustomFontSize.medium,
//                 color: SecondaryColors.secondaryOrange,
//               )),
//           actions: [
//             SizedBox(
//                 width: 100,
//                 child: FloatingActionButton.extended(
//                     backgroundColor: Colors.orange.shade100,
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     label: Text(
//                       "OK",
//                       style: TextStyle(
//                         fontSize: CustomFontSize.medium,
//                         color: SecondaryColors.secondaryOrange,
//                       ),
//                     )))
//           ],
//         ),
//       );
//     } else {
//       logger.d(selectedParents.
//           map((e) => "${e.firstName} ${e.lastName1}").toList());
//       nextScreen(context: context, screen: const SendSMS());
//     }
//   }

//   // Handle SMS Reminder State Change
//   handleSMSReminderStateChange(BuildContext context, SMSReminderState state) {
//     if (state.status == ReminderStateStatus.success) {
//       navigate(context);
//     }

//     if (state.status == ReminderStateStatus.error) {
//       logger.d(state.errorMessage ?? "Error");
//     }
//   }

//   // Handle Refresh State Change
//   handleRefreshStateChange(BuildContext context, AuthState state) {
//     if (state.refreshFailure == null) {
//       getAllStudents();
//     }
//     if (state.refreshFailure != null) {
//       print(state.refreshFailure);
//     }
//   }

//   @override
//   void initState() {
//     String? value = prefs.getString("relatives");
//     if (value != null) {
//       List<dynamic> relativeData = json.decode(value);
//       List<PersonModel> relativeList = relativeData.map((data) {
//         return PersonModel.fromJson(data);
//       }).toList();
//       logger.d(relativeList);
//       students.addAll(relativeList);
//     }
//     getAllStudents();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ParentSection parentSection = widget.parentSection;

//     // Get the list of first characters from students list
//     List<String> firstCharacters = students.map((student) {
//       return student.firstName.substring(0, 1);
//     }).toList();

//     alphabetView = firstCharacters.map(
//       (alphabet) {
//         students.sort((a, b) => a.firstName.compareTo(b.firstName));
//         return AlphabetListViewItemGroup(
//             tag: alphabet,
//             children: students.map((relative) {
//               if (relative.firstName.startsWith(alphabet)) {
//                 return Column(
//                   children: [
//                     ListTile(
//                       title: Text(
//                           "${relative.firstName} ${relative.middleName ?? ""} ${relative.lastName1}",
//                           style: TextStyle(
//                             color: SecondaryColors.secondaryOrange,
//                             fontSize: CustomFontSize.medium,
//                           )),
//                       subtitle: Row(
//                         children: [
//                           Text(
//                               "$date - GHS ${randomNumbers.isNotEmpty ? randomNumbers[students.indexOf(relative)] : 50}",
//                               style: TextStyle(
//                                 fontSize: CustomFontSize.small,
//                                 color: SecondaryColors.secondaryOrange
//                                     .withOpacity(0.7),
//                               )),
//                           const SizedBox(width: 10),
//                           relative.relatedPersons == null ||
//                                   relative.relatedPersons!.isEmpty ||
//                                   relative.relatedPersons!.first.phoneNumber ==
//                                       null ||
//                                   relative.relatedPersons!.first.phoneNumber!
//                                       .isEmpty
//                               ? Image.asset(
//                                   "assets/icons/null_number.png",
//                                   width: 25,
//                                   height: 25,
//                                   color: Colors.red,
//                                 )
//                               : const SizedBox()
//                         ],
//                       ),
//                       trailing: Checkbox(
//                         activeColor: Colors.orange,
//                         value: selectedParents
//                             .contains(relative.relatedPersons?.first),
//                         onChanged: (value) {
//                           if (relative.relatedPersons != null) {
//                             if (value!) {
//                               addParent(relative.relatedPersons!);
//                             } else {
//                               removeParent(relative.relatedPersons!);
//                             }
//                           }
//                         },
//                       ),
//                     ),
//                     Divider(
//                       color: Colors.grey.shade300,
//                     )
//                   ],
//                 );
//               }
//               return const SizedBox();
//             }));
//       },
//     ).toList();

//     // Get the list of first characters from searchResults list
//     List<String> searchResultsFirstCharacters = searchResults.map((student) {
//       return student.firstName.substring(0, 1);
//     }).toList();

//     searchResultAlphabetView = searchResultsFirstCharacters.map(
//       (alphabet) {
//         searchResults.sort((a, b) => a.firstName.compareTo(b.firstName));
//         return AlphabetListViewItemGroup(
//             tag: alphabet,
//             children: searchResults.map((relative) {
//               if (relative.firstName.startsWith(alphabet)) {
//                 return Column(
//                   children: [
//                     ListTile(
//                       title: Text(
//                           "${relative.firstName} ${relative.middleName ?? ""} ${relative.lastName1}",
//                           style: TextStyle(
//                             color: SecondaryColors.secondaryOrange,
//                             fontSize: CustomFontSize.medium,
//                           )),
//                       subtitle: Row(
//                         children: [
//                           Text("$date - GHS ${50 + Random().nextInt(150 - 50)}",
//                               style: TextStyle(
//                                 fontSize: CustomFontSize.small,
//                                 color: SecondaryColors.secondaryOrange
//                                     .withOpacity(0.7),
//                               )),
//                           const SizedBox(width: 10),
//                           relative.relatedPersons == null ||
//                                   relative.relatedPersons!.isEmpty ||
//                                   relative.relatedPersons!.first.phoneNumber ==
//                                       null ||
//                                   relative.relatedPersons!.first.phoneNumber!
//                                       .isEmpty
//                               ? Image.asset(
//                                   "assets/icons/null_number.png",
//                                   width: 25,
//                                   height: 25,
//                                   color: Colors.red,
//                                 )
//                               : const SizedBox()
//                         ],
//                       ),
//                       trailing: Checkbox(
//                         activeColor: Colors.orange,
//                         value: selectedParents
//                             .contains(relative.relatedPersons?.first),
//                         onChanged: (value) {
//                           if (relative.relatedPersons != null) {
//                             if (value!) {
//                               addParent(relative.relatedPersons!);
//                             } else {
//                               removeParent(relative.relatedPersons!);
//                             }
//                           }
//                         },
//                       ),
//                     ),
//                     Divider(
//                       color: Colors.grey.shade300,
//                     )
//                   ],
//                 );
//               }
//               return const SizedBox();
//             }));
//       },
//     ).toList();

//     final AlphabetListViewOptions options = AlphabetListViewOptions(
//         listOptions: ListOptions(
//           listHeaderBuilder: (context, symbol) => Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   padding: const EdgeInsets.all(8.0),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.shade200,
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: Center(
//                       child: Text(symbol,
//                           style: TextStyle(
//                               color: SecondaryColors.secondaryOrange,
//                               fontSize: CustomFontSize.small))),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         scrollbarOptions: ScrollbarOptions(
//           backgroundColor: Colors.orange.shade50,
//         ),
//         overlayOptions: OverlayOptions(
//           showOverlay: true,
//           overlayBuilder: (context, symbol) {
//             return Container(
//               height: 150,
//               width: 150,
//               padding: const EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                 color: Colors.orange.shade300.withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Center(
//                 child: Text(symbol,
//                     style: TextStyle(
//                       fontSize: 63,
//                       fontWeight: FontWeight.bold,
//                     )),
//               ),
//             );
//           },
//         ));

//     searchController.addListener(() {
//       if (searchController.text.isNotEmpty) {
//         searchResults.clear();
//         students.forEach((student) {
//           if (student.firstName.toLowerCase().contains(searchController.text)) {
//             searchResults.add(student);
//           }
//         });
//       } else {
//         searchResults.clear();
//         students.forEach((student) {
//           searchResults.add(student);
//         });
//       }
//     });

//     return BlocConsumer<PersonBloc,PersonState>(
//       listener: (context, state) {
//         handlePersonStateChange(context, state);
//       },
//       builder: (context, state) {
//         return Scaffold(
//           resizeToAvoidBottomInset: false,
//           backgroundColor: parentSection == ParentSection.sendSMS
//               ? Colors.orange.shade50
//               : Colors.red.shade50,
//           appBar: AppBar(
//             title: Text("Select students",
//                 style: TextStyle(
//                   color: SecondaryColors.secondaryOrange,
//                 )),
//             centerTitle: true,
//             backgroundColor: parentSection == ParentSection.sendSMS
//                 ? Colors.orange.shade100
//                 : Colors.red.shade100,
//             actions: [
//               BlocListener<AuthBloc, AuthState>(
//                 listener: (context, state) {
//                   handleRefreshStateChange(context, state);
//                 },
//                 child: Container(),
//               ),
//               BlocListener<SMSReminderBloc, SMSReminderState>(
//                 listener: (context, state) {
//                   handleSMSReminderStateChange(context, state);
//                 },
//                 child: Container(),
//               ),
//             ],
//             bottom: PreferredSize(
//               preferredSize: Size(double.infinity, 80),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: CustomTextField(
//                   color: SecondaryColors.secondaryOrange,
//                   hintText: "Search...",
//                   controller: searchController,
//                   onChanged: search,
//                 ),
//               ),
//             ),
//           ),
//           floatingActionButton: Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: FloatingActionButton.extended(
//               backgroundColor: parentSection == ParentSection.sendSMS
//                   ? selectedParents.isEmpty
//                       ? Colors.grey.shade300
//                       : Colors.orange.shade100
//                   : selectedParents.isEmpty
//                       ? Colors.grey
//                       : Colors.red.shade100,
//               onPressed: selectedParents.isEmpty
//                   ? null
//                   : () {
//                       saveData();
//                     },
//               label: SizedBox(
//                 width: 80,
//                 child: Center(
//                   child: Text(
//                     "Next",
//                     style: TextStyle(
//                         fontSize: CustomFontSize.large,
//                         color: selectedParents.isEmpty
//                             ? Colors.grey
//                             : SecondaryColors.secondaryOrange),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           body: state.isLoading && students.isEmpty
//               ? const Center(
//                   child: GFLoader(type: GFLoaderType.ios),
//                 )
//               : showResults
//                   ? searchResults.isEmpty
//                       ? const Center(
//                           child: Text("No results found"),
//                         )
//                       : AlphabetListView(
//                           items: searchResultAlphabetView,
//                           options: options,
//                         )
//                   : AlphabetListView(
//                       items: alphabetView,
//                       options: options,
//                     ),
//         );
//       },
//     );
//   }
// }
