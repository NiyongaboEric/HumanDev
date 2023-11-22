import 'dart:convert';
import 'dart:math';

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_request.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/contacts/person_details.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/reminder/reminder_types/conversation/log_conversation.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/reminder/reminder_types/letter/log_letter%20reminder.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../data/auth/model/auth_request.dart';
import '../../../../data/auth/model/auth_response.dart';
import '../../../../data/constants/logger.dart';
import '../../../../data/constants/shared_prefs.dart';
import '../../../../data/person/model/person_model.dart';
import '../../../utilities/custom_colors.dart';
import '../../../utilities/font_sizes.dart';
import '../../../utilities/navigation.dart';
import '../../../widgets/inputs/text_field.dart';
import '../../auth/auth_bloc/auth_bloc.dart';
import '../../auth/login.dart';
import '../reminder/blocs/reminder_bloc.dart';
import '../reminder/reminder_types/sms_reminder/send_sms.dart';
import 'bloc/person_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/contacts/send_sms.dart';

var sl = GetIt.instance;

enum ParentSection { sms, letter, conversation, todo, family, sendSMS }

class Parents extends StatefulWidget {
  final ParentSection parentSection;
  const Parents({
    super.key,
    required this.parentSection,
  });

  @override
  State<Parents> createState() => _ParentsState();
}

class _ParentsState extends State<Parents> {
  bool logout = false;
  List<ChildRelation> selectedParents = <ChildRelation>[];
  List<PersonModel> students = <PersonModel>[];
  List<ChildRelation> relatives = <ChildRelation>[];
  List<PersonModel> parents = <PersonModel>[];
  List<PersonModel> teachers = <PersonModel>[];
  // PS => allPeople. [Students, Parents, Teachers]
  List<PersonModel> allPeople = <PersonModel>[];

  List<PersonModel> selectedAllPeopleSendSMS = <PersonModel>[];
  List<PersonModel> selectedStudentsSendSMS = <PersonModel>[];
  List<PersonModel> selectedParentsSendSMS = <PersonModel>[];
  List<PersonModel> selectedTeachersSendSMS = <PersonModel>[];

  var prefs = sl<SharedPreferences>();
  bool showResults = false;
  List<PersonModel> searchResults = <PersonModel>[];
  final searchController = TextEditingController();
  late List<AlphabetListViewItemGroup> alphabetView;
  late List<AlphabetListViewItemGroup> searchResultAlphabetView;
  DateTime date = DateTime.now();
  List<int> randomNumbers = [];
  bool isCurrentPage = false;
  Key parentData = const Key("parent-data");
  // PS => personSelection. PS[0] = All, PS[1] = Students, PS[2] = Parents, PS[3] = Teachers
  List<bool> personSelection = [true, false, false];

  List<bool> personSelectionSendSMS = [true, false, false, false];

  // Update Person Selection
  void updatePersonSelection(int index) {
    setState(() {
      for (int i = 0; i < personSelection.length; i++) {
        if (i == index) {
          personSelection[i] = true;
        } else {
          personSelection[i] = false;
        }
      }
    });
  }

  void updatePersonSelectionSendSMS(int index) {
    setState(() {
      for (int i = 0; i < personSelectionSendSMS.length; i++) {
        if (i == index) {
          personSelectionSendSMS[i] = true;
        } else {
          personSelectionSendSMS[i] = false;
        }
      }
    });
  }

  // Search Function
  search(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        showResults = false;
      });
    } else {
      //
      if (personSelection[0]) {
        setState(() {
          showResults = true;
          searchResults = students
              .toSet()
              .toList()
              .where((student) =>
                  (student.firstName ?? "").toLowerCase().contains(query) ||
                  (student.middleName ?? "").toLowerCase().contains(query) ||
                  (student.lastName1 ?? "").toLowerCase().contains(query) ||
                  (student.lastName2 ?? "").toLowerCase().contains(query))
              .toList();
        });
      }
      //
      if (personSelection[1]) {
        setState(() {
          showResults = true;
          searchResults = parents
              .toSet()
              .toList()
              .where((parent) =>
                  (parent.firstName ?? "").toLowerCase().contains(query) ||
                  (parent.middleName ?? "").toLowerCase().contains(query) ||
                  (parent.lastName1 ?? "").toLowerCase().contains(query) ||
                  (parent.lastName2 ?? "").toLowerCase().contains(query))
              .toList();
        });
      }
      //
      if (personSelection[2]) {
        setState(() {
          showResults = true;
          searchResults = teachers
              .toSet()
              .toList()
              .where((teacher) =>
                  (teacher.firstName ?? "").toLowerCase().contains(query) ||
                  (teacher.middleName ?? "").toLowerCase().contains(query) ||
                  (teacher.lastName1 ?? "").toLowerCase().contains(query) ||
                  (teacher.lastName2 ?? "").toLowerCase().contains(query))
              .toList();
        });
      }
      // setState(() {
      //   showResults = true;
      //   searchResults = students
      //       .toSet()
      //       .toList()
      //       .where((student) =>
      //           student.firstName.toLowerCase().contains(query) ||
      //           (student.middleName ?? "").toLowerCase().contains(query) ||
      //           student.lastName1.toLowerCase().contains(query) ||
      //           (student.lastName2 ?? "").toLowerCase().contains(query))
      //       .toList();
      // });
    }
  }

  searchSendSMS(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        showResults = false;
      });
    } else {
      //
      if (personSelectionSendSMS[0]) {
        setState(() {
          showResults = true;
          searchResults = allPeople
              .toSet()
              .toList()
              .where((studentsParentsTeachers) =>
                  (studentsParentsTeachers.firstName ?? "")
                      .toLowerCase()
                      .contains(query) ||
                  (studentsParentsTeachers.middleName ?? "")
                      .toLowerCase()
                      .contains(query) ||
                  (studentsParentsTeachers.lastName1 ?? "")
                      .toLowerCase()
                      .contains(query) ||
                  (studentsParentsTeachers.lastName2 ?? "")
                      .toLowerCase()
                      .contains(query))
              .toList();
        });
      }
      if (personSelectionSendSMS[1]) {
        setState(() {
          showResults = true;
          searchResults = students
              .toSet()
              .toList()
              .where((student) =>
                  (student.firstName ?? "").toLowerCase().contains(query) ||
                  (student.middleName ?? "").toLowerCase().contains(query) ||
                  (student.lastName1 ?? "").toLowerCase().contains(query) ||
                  (student.lastName2 ?? "").toLowerCase().contains(query))
              .toList();
        });
      }
      //
      if (personSelectionSendSMS[2]) {
        setState(() {
          showResults = true;
          searchResults = parents
              .toSet()
              .toList()
              .where((parent) =>
                  (parent.firstName ?? "").toLowerCase().contains(query) ||
                  (parent.middleName ?? "").toLowerCase().contains(query) ||
                  (parent.lastName1 ?? "").toLowerCase().contains(query) ||
                  (parent.lastName2 ?? "").toLowerCase().contains(query))
              .toList();
        });
      }
      //
      if (personSelectionSendSMS[3]) {
        setState(() {
          showResults = true;
          searchResults = teachers
              .toSet()
              .toList()
              .where((teacher) =>
                  (teacher.firstName ?? "").toLowerCase().contains(query) ||
                  (teacher.middleName ?? "").toLowerCase().contains(query) ||
                  (teacher.lastName1 ?? "").toLowerCase().contains(query) ||
                  (teacher.lastName2 ?? "").toLowerCase().contains(query))
              .toList();
        });
      }
      // setState(() {
      //   showResults = true;
      //   searchResults = students
      //       .toSet()
      //       .toList()
      //       .where((student) =>
      //           student.firstName.toLowerCase().contains(query) ||
      //           (student.middleName ?? "").toLowerCase().contains(query) ||
      //           student.lastName1.toLowerCase().contains(query) ||
      //           (student.lastName2 ?? "").toLowerCase().contains(query))
      //       .toList();
      // });
    }
  }

  void addParent(ChildRelation parents) {
    setState(() {
      selectedParents.add(parents);
    });
  }

  void removeParent(ChildRelation parents) {
    setState(() {
      // for (var parent in parents) {
      //   selectedParents.remove(parent);
      // }
      selectedParents.remove(parents);
    });
  }

  void addAllPeopleSendSMS(PersonModel allPeople) {
    setState(() {
      selectedAllPeopleSendSMS.add(allPeople);
    });
  }

  void removeAllPeopleSendSMS(PersonModel allPeople) {
    setState(() {
      selectedAllPeopleSendSMS.remove(allPeople);
    });
  }

  void addStudentsSendSMS(PersonModel student) {
    setState(() {
      selectedStudentsSendSMS.add(student);
    });
  }

  void removeStudentsSendSMS(PersonModel student) {
    setState(() {
      selectedStudentsSendSMS.remove(student);
    });
  }

  void addParentsSendSMS(PersonModel parent) {
    setState(() {
      selectedParentsSendSMS.add(parent);
    });
  }

  void removeParentsSendSMS(PersonModel parent) {
    setState(() {
      selectedParentsSendSMS.remove(parent);
    });
  }

  void addTeachersSendSMS(PersonModel teacher) {
    setState(() {
      selectedTeachersSendSMS.add(teacher);
    });
  }

  void removeTeachersSendSMS(PersonModel teacher) {
    setState(() {
      selectedTeachersSendSMS.remove(teacher);
    });
  }

  // Section Color Picker
  Color secondaryColorSelection(ParentSection parentSection) {
    switch (parentSection) {
      case ParentSection.sms:
        return SecondaryColors.secondaryOrange;
      case ParentSection.letter:
        return SecondaryColors.secondaryBlue;
      case ParentSection.conversation:
        return SecondaryColors.secondaryYellow;
      case ParentSection.todo:
        return Colors.brown;
      case ParentSection.family:
        return SecondaryColors.secondaryPink;
      case ParentSection.sendSMS:
        return SMSRecipientColors.primaryColor;
      default:
        return Colors.white;
    }
  }

  MaterialColor primaryColorSelection(ParentSection parentSection) {
    switch (parentSection) {
      case ParentSection.sms:
        return Colors.orange;
      case ParentSection.letter:
        return Colors.blue;
      case ParentSection.conversation:
        return Colors.amber;
      case ParentSection.todo:
        return Colors.brown;
      case ParentSection.family:
        return Colors.pink;
      case ParentSection.sendSMS:
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }

  // Destination Routes
  Widget destinationRoutes(ParentSection parentSection,
      {PersonModel? personData}) {
    switch (parentSection) {
      case ParentSection.sms:
        return const SendSMS();
      case ParentSection.letter:
        return LogLetterReminder(
          parent: personData!,
        );
      case ParentSection.conversation:
        return LogConversation(
          parent: personData!,
        );
      case ParentSection.todo:
        return const SendSMS();
      case ParentSection.family:
        return PersonDetails(
          screenFunction: ScreenFunction.edit,
          person: personData,
        );
      case ParentSection.sendSMS:
        return const StudentsParentsTeachersSendSMS(
          parentSection: ParentSection.sendSMS,
        );
      default:
        return const SendSMS();
    }
  }

  // Reminder Type
  String reminderType(ParentSection parentSection) {
    switch (parentSection) {
      case ParentSection.sms:
        return "SENT_SMS";
      case ParentSection.letter:
        return "Letter";
      case ParentSection.conversation:
        return "F2F";
      case ParentSection.todo:
        return "Todo";
      default:
        return "SMS";
    }
  }

  // Refresh Tokens
  void _refreshTokens() {
    var prefs = sl<SharedPreferenceModule>();
    TokenResponse? token = prefs.getToken();
    logger.d(token?.refreshToken);
    if (token != null) {
      context.read<AuthBloc>().add(
            AuthEventRefresh(
              RefreshRequest(refresh: token.refreshToken),
            ),
          );
    }
  }

  // Get all student
  getAllStudents() {
    context.read<PersonBloc>().add(const GetAllPersonEvent());
  }

  // Get Relative
  getRelatives(String studentId) {
    context.read<PersonBloc>().add(GetRelativesEvent(studentId));
  }

  // Logout
  void _logout() {
    context.read<AuthBloc>().add(const AuthEventLogout());
  }

  // Handle Person State Change
  _handlePersonStateChange(BuildContext context, PersonState state) {
    if (state.status == PersonStatus.success) {
      setState(() {
        students.clear();
        parents.clear();
        teachers.clear();
        allPeople.clear();
      });
      for (var person in state.persons) {
        if (person.role == Role.Student.name) {
          if (!students.contains(person)) {
            students.add(person);
            if (person.childRelations != null) {
              relatives.addAll(person.childRelations!);
            }
            randomNumbers.add((50 + Random().nextInt(150 - 50)));
          }
        }
        if (person.role == Role.Relative.name) {
          if (!parents.contains(person)) {
            parents.add(person);
          }
        }
        if (person.role == Role.Teacher.name) {
          if (!teachers.contains(person)) {
            teachers.add(person);
          }
        }

        students = students.toSet().toList();
      }

      allPeople = [...state.persons];

      var offlineRelatives = json.encode(students);
      prefs.setString("relatives", offlineRelatives);
    }
    if (state.status == PersonStatus.error) {
      if (state.errorMessage == "Unauthorized" ||
          state.errorMessage == "Exception: Unauthorized") {
        logger.e(state.errorMessage);
        _refreshTokens();
      } else {
        GFToast.showToast(
          state.errorMessage,
          context,
          toastBorderRadius: 8.0,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
          toastDuration: 6,
        );
      }
    }
  }

  // Save Data
  saveData() {
    ReminderRequest reminderRequest = ReminderRequest(
      type: reminderType(widget.parentSection),
      attendeePersonIds: selectedParents.map((parent) => parent.id).toList(),
      expandRelations: false,
    );

    List<String> recipients =
        selectedParents.map((e) => "${e.firstName} ${e.lastName1}").toList();
    context.read<ReminderBloc>().add(
          SaveDataReminderState(
            reminderRequest,
            recipients,
          ),
        );
  }

  saveDataSendSMS() {
    ReminderRequest reminderRequest = ReminderRequest(
      type: reminderType(widget.parentSection),
      attendeePersonIds: selectedParents.map((parent) => parent.id).toList(),
      expandRelations: false,
    );

    List<String> recipients = [
      ...selectedAllPeopleSendSMS,
      ...selectedStudentsSendSMS,
      ...selectedParentsSendSMS,
      ...selectedTeachersSendSMS
    ].map((e) => "${e.firstName} ${e.lastName1}").toList();
    context.read<ReminderBloc>().add(
          SaveDataReminderState(
            reminderRequest,
            recipients,
          ),
        );
  }

  void navigate(BuildContext context) {
    List<PersonModel> studentsWithoutParentNumber =
        findStudentsWithoutParentNumber();

    if (studentsWithoutParentNumber.isNotEmpty) {
      showPhoneNumberErrorDialog(context, studentsWithoutParentNumber);
    } else {
      nextScreen(
          context: context, screen: destinationRoutes(widget.parentSection));
    }
  }

  List<PersonModel> findStudentsWithoutParentNumber() {
    List<PersonModel> result = [];

    for (var element in selectedParents) {
      if (element.phoneNumber == null) {
        logger.d(element.id);
        // Find
        // var studentsWithoutNumber = students.where((student) {
        //   return student.relatedPersons?.every((relatedPerson) =>
        //           relatedPerson.id == element.id) ??
        //       false;
        // }).toList();
        // result.addAll(studentsWithoutNumber);
      }
    }

    return result;
  }

  void showPhoneNumberErrorDialog(
      BuildContext context, List<PersonModel> studentsWithoutParentNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: Colors.orange.shade50,
        icon: const Icon(
          Icons.info_rounded,
          color: Colors.red,
          size: 56,
        ),
        content: Text(
          "No phone number found for parents of: \n ${studentsWithoutParentNumber.map((element) {
            return "${element.firstName}${element.middleName != null && element.middleName!.isNotEmpty ? ' ' : ''}${element.middleName ?? ''} ${element.lastName1}";
          }).join(", ")}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: CustomFontSize.medium,
            color: secondaryColorSelection(widget.parentSection),
          ),
        ),
        actions: [
          SizedBox(
            width: 100,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.orange.shade100,
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text(
                "OK",
                style: TextStyle(
                  fontSize: CustomFontSize.medium,
                  color: SecondaryColors.secondaryOrange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handle Reminder State Change
  _handleReminderStateChange(BuildContext context, ReminderState state) {
    if (state.status == ReminderStateStatus.success) {
      navigate(context);
    }

    if (state.status == ReminderStateStatus.error) {
      logger.d(state.errorMessage ?? "Error");
    }
  }

  // Handle Refresh State Change
  _handleRefreshStateChange(BuildContext context, AuthState state) {
    logger.i(logout);
    if (logout) {
      return;
    }
    if (state.status == AuthStateStatus.authenticated) {
      return getAllStudents();
    }
    if (state.status == AuthStateStatus.unauthenticated) {
      if (state.refreshFailure != null &&
              state.refreshFailure == "Invalid refresh token." ||
          state.refreshFailure == "Exception: Invalid refresh token.") {
        logger.e(state.refreshFailure);
        setState(() {
          logout = true;
        });
        return _logout();
      } else {
        logger.w(state.refreshFailure);
        GFToast.showToast(
          state.refreshFailure,
          context,
          toastBorderRadius: 8.0,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
          toastDuration: 6,
        );
      }
    }
  }

  // Handle Logout State Change
  void _handleLogoutStateChange(BuildContext context, AuthState state) {
    if (!logout) {
      return;
    }
    if (state.logoutMessage != null) {
      nextScreenAndRemoveAll(context: context, screen: const LoginScreen());
    }
    if (state.logoutFailure != null) {
      var prefs = sl<SharedPreferenceModule>();
      prefs.clear();
      nextScreenAndRemoveAll(context: context, screen: const LoginScreen());
      // GFToast.showToast(
      //   state.logoutFailure,
      //   context,
      //   toastBorderRadius: 8.0,
      //   toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0
      // ? GFToastPosition.TOP
      // : GFToastPosition.BOTTOM,
      //   backgroundColor: CustomColor.red,
      //   toastDuration: 6,
      // );
    }
  }

  @override
  void initState() {
    String? value = prefs.getString("relatives");
    if (value != null) {
      List<dynamic> relativeData = json.decode(value);
      List<PersonModel> relativeList = relativeData.map((data) {
        return PersonModel.fromJson(data);
      }).toList();
      logger.d(relativeList);
      students.addAll(relativeList);
    }
    getAllStudents();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ParentSection parentSection = widget.parentSection;
    var toggleOptions = [
      SizedBox(
        width: (MediaQuery.of(context).size.width - 20) / 3,
        child: const Center(child: Text("Students")),
      ),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 20) / 3,
        child: const Center(child: Text("Parents")),
      ),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 20) / 3,
        child: const Center(child: Text("Teachers")),
      ),
    ];

    var toggleOptionsSendSMS = [
      SizedBox(
        width: (MediaQuery.of(context).size.width - 20) / 4,
        child: const Center(child: Text("All")),
      ),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 20) / 4,
        child: const Center(child: Text("Students")),
      ),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 20) / 4,
        child: const Center(child: Text("Parents")),
      ),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 20) / 4,
        child: const Center(child: Text("Teachers")),
      ),
    ];

    // Get the list of first characters from students list
    List<String> firstCharacters = students.map((student) {
      return student.firstName!.substring(0, 1);
    }).toList();

    alphabetView = firstCharacters.map(
      (alphabet) {
        setState(() {});
        // Change Alphabet View Based on Selected Person
        List<PersonModel> _selectedPersonState() {
          // SendSMS
          if (parentSection == ParentSection.sendSMS) {
            if (personSelectionSendSMS[0]) {
              return allPeople;
            } else if (personSelectionSendSMS[1]) {
              return students;
            } else if (personSelectionSendSMS[2]) {
              return parents;
            } else {
              return teachers;
            }
          } else {
            // SMS
            if (personSelection[0]) {
              return students;
            } else if (personSelection[1]) {
              return parents;
            } else {
              return teachers;
            }
          }
        }

        _selectedPersonState()
            .sort((a, b) => a.firstName!.compareTo(b.firstName!));
        return AlphabetListViewItemGroup(
            tag: alphabet,
            children: _selectedPersonState().map((person) {
              if (person.firstName!.startsWith(alphabet)) {
                var fullName =
                    "${person.firstName} ${person.middleName ?? ""} ${person.lastName1}";
                return Column(
                  children: [
                    ListTile(
                      onTap: parentSection != ParentSection.sms &&
                              parentSection != ParentSection.sendSMS
                          ? () {
                              nextScreen(
                                context: context,
                                screen: destinationRoutes(parentSection,
                                    personData: person),
                              );
                            }
                          : null,
                      // leading: CircleAvatar(
                      //   child: Icon(
                      //     Icons.person_rounded,
                      //     color: SecondaryColors.secondaryYellow.withOpacity(0.7),
                      //   ),
                      // ),
                      title: Row(
                        children: [
                          Text(
                              fullName.length > 24
                                  ? '${fullName.substring(0, 11)}...'
                                  : fullName,
                              style: TextStyle(
                                color: secondaryColorSelection(parentSection),
                                fontSize: CustomFontSize.medium,
                              )),
                          const SizedBox(width: 10),
                          person.phoneNumber == null &&
                                  parentSection == ParentSection.sendSMS
                              ? Image.asset(
                                  "assets/icons/null_number.png",
                                  width: 20,
                                  height: 20,
                                  color: Colors.red,
                                )
                              : Container()
                        ],
                      ),
                      subtitle: parentSection == ParentSection.sms
                          ? Row(
                              children: [
                                Text(
                                    "${DateFormat('dd MMM yy').format(date)} - Due: GHS ${50 + Random().nextInt(150 - 50)}",
                                    style: TextStyle(
                                      fontSize: CustomFontSize.small,
                                      color:
                                          secondaryColorSelection(parentSection)
                                              .withOpacity(0.7),
                                    )),
                                const SizedBox(width: 10),
                                (person.childRelations == null ||
                                        person.childRelations!.isEmpty ||
                                        person.childRelations!.any((element) =>
                                            element.phoneNumber != null &&
                                            element.phoneNumber!.isNotEmpty))
                                    ? const SizedBox()
                                    : Image.asset(
                                        "assets/icons/null_number.png",
                                        width: 25,
                                        height: 25,
                                        color: Colors.red,
                                      )
                              ],
                            )
                          : null,
                      trailing: parentSection == ParentSection.sms ||
                              parentSection == ParentSection.sendSMS
                          ? Checkbox(
                              side: widget.parentSection ==
                                      ParentSection.sendSMS
                                  ? (person.phoneNumber == null ||
                                          person.phoneNumber!.isEmpty)
                                      ? BorderSide(
                                          color: Colors.black.withOpacity(0.2))
                                      : const BorderSide(color: Colors.black)
                                  : const BorderSide(color: Colors.black),
                              activeColor:
                                  widget.parentSection == ParentSection.sendSMS
                                      ? SMSRecipientColors.thirdColor
                                      : primaryColorSelection(parentSection),
                              value: parentSection == ParentSection.sms
                                  ? selectedParents.any((selectedParent) {
                                      return person.childRelations
                                              ?.contains(selectedParent) ??
                                          false;
                                    })
                                  :
                                  // All
                                  personSelectionSendSMS[0] == true
                                      ? selectedAllPeopleSendSMS
                                          .any((selectedAllPeople) {
                                          return person.id ==
                                                  selectedAllPeople.id
                                              ? true
                                              : false;
                                        })
                                      // Students
                                      : personSelectionSendSMS[1] == true
                                          ? selectedStudentsSendSMS
                                              .any((selectedAllPeople) {
                                              return person.id ==
                                                      selectedAllPeople.id
                                                  ? true
                                                  : false;
                                            })
                                          // Parents
                                          : personSelectionSendSMS[2] == true
                                              ? selectedParentsSendSMS
                                                  .any((selectedAllPeople) {
                                                  return person.id ==
                                                          selectedAllPeople.id
                                                      ? true
                                                      : false;
                                                })
                                              // Teachers
                                              : selectedTeachersSendSMS
                                                  .any((selectedAllPeople) {
                                                  return person.id ==
                                                          selectedAllPeople.id
                                                      ? true
                                                      : false;
                                                }),
                              onChanged: (value) {
                                // SMS
                                if (parentSection == ParentSection.sms) {
                                  if (person.childRelations != null) {
                                    if (value!) {
                                      for (var relatedPerson
                                          in person.childRelations!) {
                                        if (relatedPerson.phoneNumber != null ||
                                            relatedPerson
                                                .phoneNumber!.isNotEmpty) {
                                          addParent(relatedPerson);
                                        }
                                      }
                                    } else {
                                      for (var relatedPerson
                                          in person.childRelations!) {
                                        if (relatedPerson.phoneNumber != null ||
                                            relatedPerson
                                                .phoneNumber!.isNotEmpty) {
                                          removeParent(relatedPerson);
                                        }
                                      }
                                    }
                                    // if (person.relatedPersons != null && person.relatedPersons!.every((element) =>
                                    //     element.phoneNumber == null ||
                                    //     element.phoneNumber!.isEmpty)) {
                                    //   GFToast.showToast(
                                    //     "There is no number for either parent of ${person.firstName} ${person.middleName ?? ""} ${person.lastName1}",
                                    //     context,
                                    //     toastPosition: GFToastPosition.BOTTOM,
                                    //     backgroundColor: Colors.red,
                                    //     toastDuration: 6,
                                    //   );
                                    // }
                                  }
                                }

                                // Send SMS
                                if (parentSection == ParentSection.sendSMS) {
                                  if (value!) {
                                    if (person.phoneNumber != null ||
                                        person.phoneNumber!.isNotEmpty) {
                                      // All
                                      if (personSelectionSendSMS[0]) {
                                        addAllPeopleSendSMS(person);
                                      }
                                      // Students
                                      if (personSelectionSendSMS[1]) {
                                        addStudentsSendSMS(person);
                                      }
                                      // Parents
                                      if (personSelectionSendSMS[2]) {
                                        addParentsSendSMS(person);
                                      }
                                      // Teachers
                                      if (personSelectionSendSMS[3]) {
                                        addTeachersSendSMS(person);
                                      }
                                    }
                                  } else {
                                    if (person.phoneNumber != null ||
                                        person.phoneNumber!.isNotEmpty) {
                                      // All
                                      if (personSelectionSendSMS[0]) {
                                        removeAllPeopleSendSMS(person);
                                      }
                                      // Students
                                      if (personSelectionSendSMS[1]) {
                                        removeStudentsSendSMS(person);
                                      }
                                      // Parents
                                      if (personSelectionSendSMS[2]) {
                                        removeParentsSendSMS(person);
                                      }
                                      // Teachers
                                      if (personSelectionSendSMS[3]) {
                                        removeTeachersSendSMS(person);
                                      }
                                    }
                                  }
                                }
                              },
                            )
                          : null,
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                    )
                  ],
                );
              }
              return const SizedBox();
            }));
      },
    ).toList();

    // Get the list of first characters from searchResults list
    List<String> searchResultsFirstCharacters = searchResults.map((student) {
      return student.firstName!.substring(0, 1);
    }).toList();

    searchResultAlphabetView = searchResultsFirstCharacters.map(
      (alphabet) {
        searchResults.sort((a, b) => a.firstName!.compareTo(b.firstName!));
        return AlphabetListViewItemGroup(
            tag: alphabet,
            children: searchResults.map((relative) {
              if (relative.firstName!.startsWith(alphabet)) {
                var fullName =
                    "${relative.firstName} ${relative.middleName ?? ""} ${relative.lastName1}";
                return Column(
                  children: [
                    ListTile(
                      onTap: parentSection != ParentSection.sms
                          ? () {
                              nextScreen(
                                context: context,
                                screen: destinationRoutes(parentSection,
                                    personData: relative),
                              );
                            }
                          : null,
                      title: Row(
                        children: [
                          Text(
                              fullName.length > 24
                                  ? '${fullName.substring(0, 11)}...'
                                  : fullName,
                              style: TextStyle(
                                color: secondaryColorSelection(parentSection),
                                fontSize: CustomFontSize.medium,
                              )),
                          const SizedBox(width: 10),
                          relative.phoneNumber == null &&
                                  parentSection == ParentSection.sendSMS
                              ? Image.asset(
                                  "assets/icons/null_number.png",
                                  width: 20,
                                  height: 20,
                                  color: Colors.red,
                                )
                              : Container()
                        ],
                      ),
                      subtitle: parentSection == ParentSection.sms
                          ? Row(
                              children: [
                                Text(
                                    "${DateFormat('dd MMM yy').format(date)} - Due: GHS ${50 + Random().nextInt(150 - 50)}",
                                    style: TextStyle(
                                      fontSize: CustomFontSize.small,
                                      color:
                                          secondaryColorSelection(parentSection)
                                              .withOpacity(0.7),
                                    )),
                                const SizedBox(width: 10),
                                (relative.childRelations == null ||
                                        relative.childRelations!.isEmpty ||
                                        relative.childRelations!.any(
                                            (element) =>
                                                element.phoneNumber != null &&
                                                element
                                                    .phoneNumber!.isNotEmpty))
                                    ? const SizedBox()
                                    : Image.asset(
                                        "assets/icons/null_number.png",
                                        width: 25,
                                        height: 25,
                                        color: Colors.red,
                                      )
                              ],
                            )
                          : null,
                      trailing: parentSection == ParentSection.sms ||
                              parentSection == ParentSection.sendSMS
                          ? Checkbox(
                              side: widget.parentSection ==
                                      ParentSection.sendSMS
                                  ? (relative.phoneNumber == null ||
                                          relative.phoneNumber!.isEmpty)
                                      ? BorderSide(
                                          color: Colors.black.withOpacity(0.2))
                                      : const BorderSide(color: Colors.black)
                                  : const BorderSide(color: Colors.black),
                              activeColor:
                                  widget.parentSection == ParentSection.sendSMS
                                      ? SMSRecipientColors.thirdColor
                                      : primaryColorSelection(parentSection),
                              /**
                               * This was value used before I replaced it by using 
                               * new value used in alphabetView 
                               * 
                               * value: selectedParents
                               * .contains(relative.childRelations?.first),
                              */

                              value: parentSection == ParentSection.sms
                                  ? selectedParents.any((selectedParent) {
                                      return relative.childRelations
                                              ?.contains(selectedParent) ??
                                          false;
                                    })
                                  :
                                  // All
                                  personSelectionSendSMS[0] == true
                                      ? selectedAllPeopleSendSMS
                                          .any((selectedAllPeople) {
                                          return relative.id ==
                                                  selectedAllPeople.id
                                              ? true
                                              : false;
                                        })
                                      // Students
                                      : personSelectionSendSMS[1] == true
                                          ? selectedStudentsSendSMS
                                              .any((selectedAllPeople) {
                                              return relative.id ==
                                                      selectedAllPeople.id
                                                  ? true
                                                  : false;
                                            })
                                          // Parents
                                          : personSelectionSendSMS[2] == true
                                              ? selectedParentsSendSMS
                                                  .any((selectedAllPeople) {
                                                  return relative.id ==
                                                          selectedAllPeople.id
                                                      ? true
                                                      : false;
                                                })
                                              // Teachers
                                              : selectedTeachersSendSMS
                                                  .any((selectedAllPeople) {
                                                  return relative.id ==
                                                          selectedAllPeople.id
                                                      ? true
                                                      : false;
                                                }),
                              onChanged: (value) {
                                // SMS
                                if (parentSection == ParentSection.sms) {
                                  if (relative.childRelations != null) {
                                    if (value!) {
                                      for (var relatedPerson
                                          in relative.childRelations!) {
                                        if (relatedPerson.phoneNumber != null ||
                                            relatedPerson
                                                .phoneNumber!.isNotEmpty) {
                                          addParent(relatedPerson);
                                        }
                                      }
                                      // addParent(relative.childRelations!);
                                    } else {
                                      for (var relatedPerson
                                          in relative.childRelations!) {
                                        if (relatedPerson.phoneNumber != null ||
                                            relatedPerson
                                                .phoneNumber!.isNotEmpty) {
                                          removeParent(relatedPerson);
                                        }
                                      }
                                      // removeParent(relative.childRelations!);
                                    }
                                  }
                                }

                                // Send SMS
                                if (parentSection == ParentSection.sendSMS) {
                                  if (value!) {
                                    if (relative.phoneNumber != null ||
                                        relative.phoneNumber!.isNotEmpty) {
                                      // All
                                      if (personSelectionSendSMS[0]) {
                                        addAllPeopleSendSMS(relative);
                                      }
                                      // Students
                                      if (personSelectionSendSMS[1]) {
                                        addStudentsSendSMS(relative);
                                      }
                                      // Parents
                                      if (personSelectionSendSMS[2]) {
                                        addParentsSendSMS(relative);
                                      }
                                      // Teachers
                                      if (personSelectionSendSMS[3]) {
                                        addTeachersSendSMS(relative);
                                      }
                                    }
                                  } else {
                                    if (relative.phoneNumber != null ||
                                        relative.phoneNumber!.isNotEmpty) {
                                      // All
                                      if (personSelectionSendSMS[0]) {
                                        removeAllPeopleSendSMS(relative);
                                      }
                                      // Students
                                      if (personSelectionSendSMS[1]) {
                                        removeStudentsSendSMS(relative);
                                      }
                                      // Parents
                                      if (personSelectionSendSMS[2]) {
                                        removeParentsSendSMS(relative);
                                      }
                                      // Teachers
                                      if (personSelectionSendSMS[3]) {
                                        removeTeachersSendSMS(relative);
                                      }
                                    }
                                  }
                                }
                              },
                            )
                          : null,
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                    )
                  ],
                );
              }
              return const SizedBox();
            }));
      },
    ).toList();

    final AlphabetListViewOptions options = AlphabetListViewOptions(
        listOptions: ListOptions(
          listHeaderBuilder: (context, symbol) => Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: widget.parentSection == ParentSection.sendSMS
                        ? SMSRecipientColors.thirdColor
                        : primaryColorSelection(parentSection).shade200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                      child: Text(symbol,
                          style: TextStyle(
                              color: secondaryColorSelection(parentSection),
                              fontSize: CustomFontSize.small))),
                ),
              ),
            ],
          ),
        ),
        scrollbarOptions: ScrollbarOptions(
          backgroundColor: primaryColorSelection(parentSection).shade50,
        ),
        overlayOptions: OverlayOptions(
          showOverlay: true,
          overlayBuilder: (context, symbol) {
            return Container(
              height: 150,
              width: 150,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: primaryColorSelection(parentSection).withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(symbol,
                    style: const TextStyle(
                      fontSize: 63,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            );
          },
        ));

    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        searchResults.clear();
        for (var student in students) {
          if (student.firstName!
              .toLowerCase()
              .contains(searchController.text)) {
            searchResults.add(student);
          }
        }
      } else {
        searchResults.clear();
        for (var student in students) {
          searchResults.add(student);
        }
      }
    });

    return VisibilityDetector(
      key: parentData,
      onVisibilityChanged: (visibilityInfo) {
        if (mounted) {
          if (visibilityInfo.visibleFraction == 1.0) {
            setState(() {
              isCurrentPage = true;
            });
          } else {
            setState(() {
              isCurrentPage = false;
            });
          }
        }
      },
      child: BlocConsumer<PersonBloc, PersonState>(
        listener: (context, state) {
          // TODO: implement listener
          if (isCurrentPage) {
            _handlePersonStateChange(context, state);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: primaryColorSelection(parentSection).shade50,
            appBar: AppBar(
              title: widget.parentSection == ParentSection.sendSMS
                  ? Text(
                      "Select recipient",
                      style: TextStyle(
                        color: SMSRecipientColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    )
                  : Text(
                      "Select students",
                      style: TextStyle(
                        color: secondaryColorSelection(parentSection),
                      ),
                    ),
              iconTheme: IconThemeData(
                color: secondaryColorSelection(parentSection),
              ),
              centerTitle: true,
              backgroundColor: widget.parentSection == ParentSection.sendSMS
                  ? SMSRecipientColors.secondaryColor.withOpacity(.3)
                  : primaryColorSelection(parentSection).shade100,
              actions: [
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (isCurrentPage) {
                      _handleRefreshStateChange(context, state);
                      _handleLogoutStateChange(context, state);
                    }
                  },
                  child: Container(),
                ),
                BlocListener<ReminderBloc, ReminderState>(
                  listener: (context, state) {
                    if (isCurrentPage) {
                      _handleReminderStateChange(context, state);
                    }
                  },
                  child: Container(),
                ),
                widget.parentSection == ParentSection.family
                    ? IconButton(
                        onPressed: () {
                          nextScreen(
                            context: context,
                            screen: const PersonDetails(
                                screenFunction: ScreenFunction.add),
                          );
                        },
                        icon: const Icon(Icons.add_rounded))
                    : Container()
              ],
              bottom: PreferredSize(
                preferredSize: widget.parentSection == ParentSection.sendSMS
                    ? const Size(double.infinity, 160)
                    : Size(
                        double.infinity,
                        widget.parentSection == ParentSection.family ? 150 : 80,
                      ),
                child: Padding(
                  padding: widget.parentSection == ParentSection.sendSMS
                      ? const EdgeInsets.only(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                        )
                      : const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ParentSelection Family
                      widget.parentSection == ParentSection.family
                          ? ToggleButtons(
                              selectedColor: Colors.white,
                              fillColor:
                                  primaryColorSelection(parentSection).shade300,
                              borderRadius: BorderRadius.circular(50),
                              isSelected: personSelection,
                              onPressed: updatePersonSelection,
                              children: toggleOptions,
                            )
                          : Container(),
                      widget.parentSection == ParentSection.family
                          ? const SizedBox(
                              height: 10,
                            )
                          : Container(),

                      widget.parentSection != ParentSection.sendSMS
                          ? CustomTextField(
                              color: secondaryColorSelection(parentSection),
                              hintText: "Search...",
                              controller: searchController,
                              onChanged: search,
                            )
                          : Container(),

                      // ParentSelection Send SMS
                      widget.parentSection == ParentSection.sendSMS
                          ? Center(
                              child: ToggleButtons(
                                borderWidth: 1.3,
                                renderBorder: true,
                                selectedColor: Colors.white,
                                fillColor: SMSRecipientColors.primaryColor,
                                borderRadius: BorderRadius.circular(50),
                                selectedBorderColor:
                                    SMSRecipientColors.primaryColor,
                                borderColor: SMSRecipientColors.primaryColor,
                                color: SMSRecipientColors.primaryColor,
                                constraints: const BoxConstraints.expand(
                                  width: 400 / 4.3,
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                isSelected: personSelectionSendSMS,
                                onPressed: updatePersonSelectionSendSMS,
                                children: toggleOptionsSendSMS,
                              ),
                            )
                          : Container(),
                      widget.parentSection == ParentSection.sendSMS
                          ? const SizedBox(
                              height: 15,
                            )
                          : Container(),
                      // Customize parentSelection Send SMS search
                      widget.parentSection == ParentSection.sendSMS
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 0,
                              ),
                              child: CustomTextField(
                                color: SMSRecipientColors.primaryColor,
                                fillColor: SMSRecipientColors.fifthColor,
                                hintTextSize: 22,
                                hintText: "Search...",
                                controller: searchController,
                                onChanged: searchSendSMS,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: parentSection == ParentSection.sms ||
                    parentSection == ParentSection.sendSMS
                ? Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: FloatingActionButton.extended(
                      backgroundColor: parentSection == ParentSection.sendSMS
                          ? [
                              ...selectedAllPeopleSendSMS,
                              ...selectedStudentsSendSMS,
                              ...selectedParentsSendSMS,
                              ...selectedTeachersSendSMS
                            ].isEmpty
                              ? primaryColorSelection(parentSection).shade200
                              : SMSRecipientColors.thirdColor
                          : parentSection == ParentSection.sms
                              ? selectedParents.isEmpty
                                  ? Colors.grey.shade300
                                  : Colors.orange.shade100
                              : selectedParents.isEmpty
                                  ? Colors.grey
                                  : Colors.red.shade100,
                      onPressed: parentSection == ParentSection.sendSMS
                          ? [
                              ...selectedAllPeopleSendSMS,
                              ...selectedStudentsSendSMS,
                              ...selectedParentsSendSMS,
                              ...selectedTeachersSendSMS
                            ].isEmpty
                              ? null
                              : () {
                                  saveDataSendSMS();
                                }
                          : selectedParents.isEmpty
                              ? null
                              : () {
                                  saveData();
                                },
                      label: SizedBox(
                        width: 80,
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                                fontSize: CustomFontSize.large,
                                color: parentSection == ParentSection.sendSMS
                                    ? [].isEmpty
                                        ? Colors.white
                                        : secondaryColorSelection(parentSection)
                                    : selectedParents.isEmpty
                                        ? Colors.grey
                                        : secondaryColorSelection(
                                            parentSection)),
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
            body: state.isLoading && students.isEmpty
                ? const Center(
                    child: GFLoader(type: GFLoaderType.ios),
                  )
                : showResults
                    ? searchResults.isEmpty
                        ? const Center(
                            child: Text("No results found"),
                          )
                        : AlphabetListView(
                            items: searchResultAlphabetView,
                            options: options,
                          )
                    : AlphabetListView(
                        items: alphabetView,
                        options: options,
                      ),
          );
        },
      ),
    );
  }
}
