import 'dart:math';

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_request.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/contacts/contact_type.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/contacts/person_details.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/contacts/send_sms.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/reminder/reminder_types/conversation/log_conversation.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/reminder/reminder_types/letter/log_letter%20reminder.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/constants.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/drop_down_menu.dart';
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
import '../../../screens/main/contacts/sms/bloc/sms_bloc.dart';

var sl = GetIt.instance;

enum ParentSection {
  sms,
  letter,
  conversation,
  todo,
  contacts,
  sendSMS,
  students
}

// List<String> selectedGroups = <String>[
//   'All groups', 'Parents', 'Relative', 'Student',
//   'Supplier', 'Supplier administrator', 'Teacher'
// ];

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
  List<PersonModel> selectedStudents = <PersonModel>[];
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

  String selectedContactType = 'All people';
  void _updateSelectedContactType(value) {
    setState(() {
      selectedContactType = value;
    });
  }

  var prefs = sl<SharedPreferences>();
  var preferences = sl<SharedPreferenceModule>();
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

  String selectedGroupDropdownValue = Constants.selectedGroups.first; //selectedGroups.first;

  // Update Groups
  void _updateGroups(value) {
    setState(() {
      selectedGroupDropdownValue = value!;
    });
  }

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
      List<PersonModel> searchList = [];
      if (widget.parentSection == ParentSection.sendSMS) {
        if (personSelection[0]) {
          searchList = students;
        } else if (personSelection[1]) {
          searchList = parents;
        } else if (personSelection[2]) {
          searchList = teachers;
        }
      }
      if (widget.parentSection == ParentSection.students) {
        searchList = parents;
      }
      if (widget.parentSection == ParentSection.contacts) {
        if (selectedContactType == 'All people') {
          searchList = allPeople;
        } else if (selectedContactType == 'Student') {
          searchList = students;
        } else if (selectedContactType == 'Parent') {
          searchList = parents;
        } else {
          searchList = teachers;
        }
      }
      if (widget.parentSection == ParentSection.sms ||
          widget.parentSection == ParentSection.conversation ||
          widget.parentSection == ParentSection.letter) {
        searchList = students;
      }

      setState(() {
        showResults = true;
        searchResults = searchList
            .toSet()
            .toList()
            .where((item) =>
                (item.firstName ?? "").toLowerCase().contains(query) ||
                (item.middleName ?? "").toLowerCase().contains(query) ||
                (item.lastName1 ?? "").toLowerCase().contains(query) ||
                (item.lastName2 ?? "").toLowerCase().contains(query))
            .toList();
      });
    }
  }

  searchSendSMS(String query) {
    query = query.toLowerCase();
    setState(() {
      showResults = query.isNotEmpty;
      searchResults = [];

      if (personSelectionSendSMS[0]) {
        searchResults.addAll(searchInPeople(allPeople, query));
      }

      if (personSelectionSendSMS[1]) {
        searchResults.addAll(searchInStudents(students, query));
      }

      if (personSelectionSendSMS[2]) {
        searchResults.addAll(searchInParents(parents, query));
      }

      if (personSelectionSendSMS[3]) {
        searchResults.addAll(searchInTeachers(teachers, query));
      }
    });
  }

  List<PersonModel> searchInPeople(List<PersonModel> people, String query) {
    return people
        .where((person) =>
            (person.firstName ?? "").toLowerCase().contains(query) ||
            (person.middleName ?? "").toLowerCase().contains(query) ||
            (person.lastName1 ?? "").toLowerCase().contains(query) ||
            (person.lastName2 ?? "").toLowerCase().contains(query))
        .toList();
  }

  List<PersonModel> searchInStudents(List<PersonModel> students, String query) {
    return students
        .where((student) =>
            (student.firstName ?? "").toLowerCase().contains(query) ||
            (student.middleName ?? "").toLowerCase().contains(query) ||
            (student.lastName1 ?? "").toLowerCase().contains(query) ||
            (student.lastName2 ?? "").toLowerCase().contains(query))
        .toList();
  }

  List<PersonModel> searchInParents(List<PersonModel> parents, String query) {
    return parents
        .where((parent) =>
            (parent.firstName ?? "").toLowerCase().contains(query) ||
            (parent.middleName ?? "").toLowerCase().contains(query) ||
            (parent.lastName1 ?? "").toLowerCase().contains(query) ||
            (parent.lastName2 ?? "").toLowerCase().contains(query))
        .toList();
  }

  List<PersonModel> searchInTeachers(List<PersonModel> teachers, String query) {
    return teachers
        .where((teacher) =>
            (teacher.firstName ?? "").toLowerCase().contains(query) ||
            (teacher.middleName ?? "").toLowerCase().contains(query) ||
            (teacher.lastName1 ?? "").toLowerCase().contains(query) ||
            (teacher.lastName2 ?? "").toLowerCase().contains(query))
        .toList();
  }

  void addParent(ChildRelation parents) {
    setState(() {
      selectedParents.add(parents);
    });
  }

  void removeParent(ChildRelation parents) {
    setState(() {
      selectedParents.remove(parents);
    });
  }

  void addStudent(PersonModel student) {
    setState(() {
      selectedStudents.add(student);
    });
  }

  void removeStudent(PersonModel student) {
    setState(() {
      selectedStudents.remove(student);
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
      case ParentSection.students:
        return SecondaryColors.secondaryPink;
      case ParentSection.sendSMS:
        return SecondaryColors.secondaryDarkBlue;
      case ParentSection.contacts:
        return SecondaryColors.secondaryLightGreen;
      default:
        return Colors.white;
    }
  }

  Color primaryColorSelection(ParentSection parentSection) {
    switch (parentSection) {
      case ParentSection.sms:
        return PrimaryColors.primaryOrange;
      case ParentSection.letter:
        return PrimaryColors.primaryBlue;
      case ParentSection.conversation:
        return PrimaryColors.primaryYellow;
      case ParentSection.todo:
        return Colors.brown;
      case ParentSection.students:
        return PrimaryColors.primaryPink;
      case ParentSection.sendSMS:
        return PrimaryColors.primaryDarkBlue;
      case ParentSection.contacts:
        return PrimaryColors.primaryLightGreen;
      default:
        return PrimaryColors.primaryBlue;
    }
  }

  Color tertiaryColorSelection(ParentSection parentSection) {
    switch (parentSection) {
      case ParentSection.sms:
        return TertiaryColors.tertiaryOrange;
      case ParentSection.letter:
        return TertiaryColors.tertiaryBlue;
      case ParentSection.conversation:
        return TertiaryColors.tertiaryYellow;
      case ParentSection.todo:
        return Colors.brown;
      case ParentSection.students:
        return TertiaryColors.tertiaryPink;
      case ParentSection.sendSMS:
        return TertiaryColors.tertiaryDarkBlue;
      case ParentSection.contacts:
        return TertiaryColors.tertiaryLightGreen;
      default:
        return TertiaryColors.tertiaryBlue;
    }
  }

  Color bgColorSelection(ParentSection parentSection) {
    switch (parentSection) {
      case ParentSection.sms:
        return BackgroundColors.bgOrange;
      case ParentSection.letter:
        return BackgroundColors.bgBlue;
      case ParentSection.conversation:
        return BackgroundColors.bgYellow;
      case ParentSection.todo:
        return Colors.brown;
      case ParentSection.students:
        return BackgroundColors.bgPink;
      case ParentSection.sendSMS:
        return BackgroundColors.bgBlue;
      case ParentSection.contacts:
        return BackgroundColors.bgLightGreen;
      default:
        return BackgroundColors.bgBlue;
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
      case ParentSection.students:
        return PersonDetails(
          screenFunction: ScreenFunction.edit,
          contactVariant: ContactVariant.student,
          person: personData,
        );
      case ParentSection.sendSMS:
        return const StudentsParentsTeachersSendSMS(
          parentSection: ParentSection.sendSMS,
        );
      case ParentSection.contacts:
        return PersonDetails(
          screenFunction: ScreenFunction.edit,
          contactVariant: ContactVariant.others,
          person: personData,
        );
      default:
        return const SendSMS();
    }
  }

  // Reminder Type
  ReminderType reminderType(ParentSection parentSection) {
    switch (parentSection) {
      case ParentSection.sms:
        return ReminderType.SENT_SMS;
      case ParentSection.letter:
        return ReminderType.LETTER;
      case ParentSection.conversation:
        return ReminderType.F2F;
      case ParentSection.todo:
        return ReminderType.OTHER;
      default:
        return ReminderType.SENT_SMS;
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
      }

      allPeople = [...state.persons];

      preferences.savePersons(allPeople);
      preferences.saveStudents(students);
      preferences.saveParents(parents);
      preferences.saveTeachers(teachers);
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
    List<ReminderRequest> reminderRequests = selectedParents.map((parent) {
      return ReminderRequest(
        type: reminderType(widget.parentSection),
        relativePersonId: parent.id,
        studentPersonId: students
            .firstWhere(
              (student) => student.childRelations!.any(
                (relative) => relative.id == parent.id,
              ),
            )
            .id,
        fullName: "${parent.firstName} ${parent.lastName1}",
        phoneNumber: parent.phoneNumber1,
      );
    }).toList();

    reminderRequests.forEach((element) {
      logger.d(element.fullName);
      logger.d(element.phoneNumber);
    });

    List<String> recipients =
        selectedParents.map((e) => "${e.firstName} ${e.lastName1}").toList();

    context.read<ReminderBloc>().add(
          SaveDataReminderState(
            reminderRequests,
            recipients,
          ),
        );
  }

  saveDataSendSMS() {

    List<Map<String, String>> recipientsWithNameAndNumbers = [
      ...selectedAllPeopleSendSMS,
      ...selectedStudentsSendSMS,
      ...selectedParentsSendSMS,
      ...selectedTeachersSendSMS
    ]
    .map((e) => {'${e.firstName} ${e.lastName1}': "${e.phoneNumber1}"})
    .toList();

    ReminderRequest reminderRequest = ReminderRequest(
      type: reminderType(widget.parentSection),
      // attendeePersonIds: selectedParents.map((parent) => parent.id).toList(),
      // expandRelations: false,
      recipientsNameWithNumbers: recipientsWithNameAndNumbers
    );

    List<String> recipients = [
      ...selectedAllPeopleSendSMS,
      ...selectedStudentsSendSMS,
      ...selectedParentsSendSMS,
      ...selectedTeachersSendSMS
    ].map((e) => "${e.firstName} ${e.lastName1}").toList();

    context
      .read<SMSBloc>()
      .add(
        SaveDataSendSMSState(
          reminderRequest,
          recipients
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

    // for (var element in selectedParents) {
    //   if (element.phoneNumber == null) {
    //     logger.d(element.id);
    //     // Find
    //     // var studentsWithoutNumber = students.where((student) {
    //     //   return student.relatedPersons?.every((relatedPerson) =>
    //     //           relatedPerson.id == element.id) ??
    //     //       false;
    //     // }).toList();
    //     // result.addAll(studentsWithoutNumber);
    //   }
    // }

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

  // Handle SMS State Change
  _handleSMSStateChange(BuildContext context, SMSState state) {
    if (state.status == SMSStateStatus.success) {
      navigate(context);
    }

    if (state.status == SMSStateStatus.error) {
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
    }
  }

  @override
  void initState() {
    var studentList = preferences.getStudents();
    students.addAll(studentList);
    var parentList = preferences.getParents();
    parents.addAll(parentList);
    var teacherList = preferences.getTeachers();
    teachers.addAll(teacherList);
    var allPeopleList = preferences.getPersons();
    allPeople.addAll(allPeopleList);
    getAllStudents();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleChangeDropdownItem(value) {
    setState(() {
      print(".....value:   $value");
    });
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
        width: (MediaQuery.of(context).size.width - 24) / 4,
        child: const Center(child: Text("All")),
      ),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 24) / 4,
        child: const Center(child: Text("Students")),
      ),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 24) / 4,
        child: const Center(child: Text("Parents")),
      ),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 24) / 4,
        child: const Center(child: Text("Teachers")),
      ),
    ];

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

    var buildAlphabetListView = _buildAlphabetView();
    var buildSearchResultsAlphabetView = _buildSearchResultAlphabetView();
    var buildAlphabetListViewOptions = _buildAlphabetListViewOptions();
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
            // resizeToAvoidBottomInset: false,
            backgroundColor: bgColorSelection(parentSection),
            appBar: _buildAppBar(toggleOptions, toggleOptionsSendSMS),
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
                              ? primaryColorSelection(parentSection)
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
                            items: buildSearchResultsAlphabetView,
                            options: buildAlphabetListViewOptions,
                          )
                    : AlphabetListView(
                        items: buildAlphabetListView,
                        options: buildAlphabetListViewOptions,
                      ),
          );
        },
      ),
    );
  }

  List<String> getFirstCharacters(List<PersonModel> people) {
    return people.map((person) => person.firstName![0]).toList();
  }

  List<String> getResultsFirstCharacters(List<PersonModel> people) {
    return searchResults.map((person) => person.firstName![0]).toList();
  }

  List<PersonModel> getSelectedPersonState(ParentSection parentSection) {
    if (parentSection == ParentSection.sendSMS) {
      return getSelectedPeopleForSendSMS();
    } else if (parentSection == ParentSection.students) {
      return parents;
    } else if (parentSection == ParentSection.contacts) {
      return getSelectedPeopleForContacts();
    } else {
      return getSelectedPeople();
    }
  }

  List<PersonModel> getSelectedPeopleForSendSMS() {
    if (personSelectionSendSMS[0]) {
      return allPeople;
    } else if (personSelectionSendSMS[1]) {
      return students;
    } else if (personSelectionSendSMS[2]) {
      return parents;
    } else {
      return teachers;
    }
  }

  List<PersonModel> getSelectedPeopleForContacts() {
    if (selectedContactType == 'All people') {
      return allPeople;
    } else if (selectedContactType == 'Student') {
      return students;
    } else if (selectedContactType == 'Parent') {
      return parents;
    } else {
      return teachers;
    }
  }

  List<PersonModel> getSelectedPeople() {
    if (personSelection[0]) {
      return students;
    } else if (personSelection[1]) {
      return parents;
    } else {
      return teachers;
    }
  }

  List<AlphabetListViewItemGroup> _buildAlphabetView() {
    return getFirstCharacters(students).map((alphabet) {
      setState(() {});
      List<PersonModel> selectedPeople =
          getSelectedPersonState(widget.parentSection);
      selectedPeople.sort((a, b) => a.firstName!.compareTo(b.firstName!));

      return _buildAlphabetListViewItemGroup(alphabet, selectedPeople);
    }).toList();
  }

  List<AlphabetListViewItemGroup> _buildSearchResultAlphabetView() {
    return getResultsFirstCharacters(searchResults).map((alphabet) {
      searchResults.sort((a, b) => a.firstName!.compareTo(b.firstName!));
      return _buildAlphabetListViewItemGroup(alphabet, searchResults);
    }).toList();
  }

  AlphabetListViewItemGroup _buildAlphabetListViewItemGroup(
      String alphabet, List<PersonModel> people) {
    return AlphabetListViewItemGroup(
      tag: alphabet,
      children: people.map((person) {
        if (person.firstName!.startsWith(alphabet)) {
          return _buildPersonListTile(person);
        }
        return const SizedBox();
      }).toList(),
    );
  }

  AlphabetListViewOptions _buildAlphabetListViewOptions() {
    return AlphabetListViewOptions(
      listOptions: ListOptions(
        listHeaderBuilder: (context, symbol) => _buildListHeader(symbol),
      ),
      scrollbarOptions: _buildScrollbarOptions(),
      overlayOptions: _buildOverlayOptions(),
    );
  }

  Widget _buildListHeader(String symbol) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8.0),
            decoration: _buildListHeaderDecoration(),
            child: _buildListHeaderCenter(symbol),
          ),
        ),
      ],
    );
  }

  BoxDecoration _buildListHeaderDecoration() {
    return BoxDecoration(
      color: widget.parentSection == ParentSection.sendSMS
          ? SMSRecipientColors.thirdColor
          : primaryColorSelection(widget.parentSection),
      borderRadius: BorderRadius.circular(100),
    );
  }

  Center _buildListHeaderCenter(String symbol) {
    return Center(
      child: Text(
        symbol,
        style: TextStyle(
          color: secondaryColorSelection(widget.parentSection),
          fontSize: CustomFontSize.small,
        ),
      ),
    );
  }

  ScrollbarOptions _buildScrollbarOptions() {
    return ScrollbarOptions(
      backgroundColor: bgColorSelection(widget.parentSection),
    );
  }

  OverlayOptions _buildOverlayOptions() {
    return OverlayOptions(
      showOverlay: true,
      overlayBuilder: (context, symbol) => _buildOverlayContainer(symbol),
    );
  }

  Container _buildOverlayContainer(String symbol) {
    return Container(
      height: 150,
      width: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: _buildOverlayContainerDecoration(),
      child: _buildOverlayContainerCenter(symbol),
    );
  }

  BoxDecoration _buildOverlayContainerDecoration() {
    return BoxDecoration(
      color: primaryColorSelection(widget.parentSection).withOpacity(0.6),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Center _buildOverlayContainerCenter(String symbol) {
    return Center(
      child: Text(
        symbol,
        style: const TextStyle(
          fontSize: 63,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPersonListTile(PersonModel person) {
    var fullName =
        "${person.firstName} ${person.middleName ?? ""} ${person.lastName1}";

    return Column(
      children: [
        ListTile(
          onTap: getOnTapFunction(person),
          title: _buildTitleRow(fullName, person),
          subtitle: _buildSubtitleRow(person),
          trailing: _buildCheckbox(person),
        ),
        Divider(color: Colors.grey.shade300),
      ],
    );
  }

  Function()? getOnTapFunction(PersonModel person) =>
      (widget.parentSection != ParentSection.sms &&
              widget.parentSection != ParentSection.sendSMS)
          ? () {
              widget.parentSection == ParentSection.students
                  ? Navigator.pop(context, person)
                  : (nextScreen(
                      context: context,
                      screen: destinationRoutes(
                        widget.parentSection,
                        personData: person,
                      ),
                    ));
            }
          : null;

  Row _buildTitleRow(String fullName, PersonModel person) => Row(
        children: [
          Text(
            fullName.length > 24 ? '${fullName.substring(0, 11)}...' : fullName,
            style: TextStyle(
              color:
              widget.parentSection == ParentSection.sendSMS 
                ? SMSRecipientColors.primaryColor 
                : secondaryColorSelection(widget.parentSection),
                fontSize: CustomFontSize.medium),
          ),
          const SizedBox(width: 10),
          if (widget.parentSection == ParentSection.sendSMS)
            _buildNullNumberImage(person),
        ],
      );

  Widget _buildNullNumberImage(PersonModel person) {
    if (widget.parentSection == ParentSection.sms) {
      if (person.childRelations == null ||
          person.childRelations!.isEmpty ||
          person.childRelations!.any((element) =>
              element.phoneNumber1 == null && element.phoneNumber1!.isEmpty ||
              element.phoneNumber2 == null && element.phoneNumber2!.isEmpty ||
              element.phoneNumber3 == null && element.phoneNumber3!.isEmpty)) {
        return Image.asset("assets/icons/null_number.png",
            width: 20, height: 20, color: Colors.red);
      } else {
        return const SizedBox();
      }
    } else {
      if (person.phoneNumber1 == null &&
          person.phoneNumber2 == null &&
          person.phoneNumber3 == null) {
        return Image.asset("assets/icons/null_number.png",
            width: 20, height: 20, color: Colors.red);
      } else {
        return const SizedBox();
      }
    }
  }

  Row? _buildSubtitleRow(PersonModel person) =>
      widget.parentSection == ParentSection.sms
          ? Row(children: [
              _buildSubtitleText(person),
              const SizedBox(width: 10),
              _buildNullNumberImageForSubtitle(person)
            ])
          : null;

  Widget _buildSubtitleText(PersonModel person) => Text(
        "${DateFormat('dd MMM yy').format(date)} - Due: GHS ${50 + Random().nextInt(150 - 50)}",
        style: TextStyle(
            fontSize: CustomFontSize.small,
            color:
                secondaryColorSelection(widget.parentSection).withOpacity(0.7)),
      );

  Widget _buildNullNumberImageForSubtitle(PersonModel person) =>
      (person.childRelations == null ||
              person.childRelations!.isEmpty ||
              person.childRelations!.any((element) =>
                  element.phoneNumber1 != null &&
                      element.phoneNumber1!.isNotEmpty ||
                  element.phoneNumber2 != null &&
                      element.phoneNumber2!.isNotEmpty ||
                  element.phoneNumber3 != null &&
                      element.phoneNumber3!.isNotEmpty))
          ? const SizedBox()
          : Image.asset("assets/icons/null_number.png",
              width: 25, height: 25, color: Colors.red);

  Checkbox? _buildCheckbox(PersonModel person) =>
      (widget.parentSection == ParentSection.sms ||
              widget.parentSection == ParentSection.sendSMS)
          ? Checkbox(
            side: widget.parentSection == ParentSection.sendSMS
              ? (
                  person.phoneNumber1 != null && person.phoneNumber1!.isNotEmpty ||
                  person.phoneNumber2 != null && person.phoneNumber2!.isNotEmpty ||
                  person.phoneNumber3 != null && person.phoneNumber3!.isNotEmpty
                )
                  ? const BorderSide(color: Colors.black)
                  : BorderSide(color: Colors.black.withOpacity(0.2))
              : const BorderSide(color: Colors.black),
              activeColor: getActiveColor(),
              value: getCheckboxValue(person),
              onChanged: (value) => onCheckboxChanged(person, value),
            )
          : null;

  Color? getActiveColor() => widget.parentSection == ParentSection.sendSMS
      ? SMSRecipientColors.thirdColor
      : Colors.orange;

  bool getCheckboxValue(PersonModel person) =>
      widget.parentSection == ParentSection.sms
          ? selectedParents.any((selectedParent) =>
              person.childRelations?.contains(selectedParent) ?? false)
          : getCheckboxValueForSendSMS(person);

  bool getCheckboxValueForSendSMS(PersonModel person) =>
      personSelectionSendSMS[0]
          ? selectedAllPeopleSendSMS
              .any((selectedAllPeople) => person.id == selectedAllPeople.id)
          : personSelectionSendSMS[1]
              ? selectedStudentsSendSMS
                  .any((selectedAllPeople) => person.id == selectedAllPeople.id)
              : personSelectionSendSMS[2]
                  ? selectedParentsSendSMS.any(
                      (selectedAllPeople) => person.id == selectedAllPeople.id)
                  : selectedTeachersSendSMS.any(
                      (selectedAllPeople) => person.id == selectedAllPeople.id);

  void onCheckboxChanged(PersonModel person, bool? value) {
    if (widget.parentSection == ParentSection.sms) {
      handleCheckboxChangedForSMS(person, value);
    }

    if (widget.parentSection == ParentSection.sendSMS) {
      handleCheckboxChangedForSendSMS(person, value);
    }
  }

  void handleCheckboxChangedForSMS(PersonModel person, bool? value) {
    if (person.childRelations != null) {
      if (value!) {
        // Iterate over child relations and add parents
        person.childRelations!
            .where((relatedPerson) =>
                relatedPerson.phoneNumber1 != null &&
                    relatedPerson.phoneNumber1!.isNotEmpty ||
                relatedPerson.phoneNumber2 != null &&
                    relatedPerson.phoneNumber2!.isNotEmpty ||
                relatedPerson.phoneNumber3 != null &&
                    relatedPerson.phoneNumber3!.isNotEmpty)
            .forEach(addParent);

        // Add Student if parent is selected
        selectedParents.forEach((element) {
          if (person.childRelations!.contains(element)) {
            addStudent(person);
          }
        });
      } else {
        // Iterate over child relations and remove parents
        person.childRelations!
            .where((relatedPerson) =>
                relatedPerson.phoneNumber1 != null &&
                    relatedPerson.phoneNumber1!.isNotEmpty ||
                relatedPerson.phoneNumber2 != null &&
                    relatedPerson.phoneNumber2!.isNotEmpty ||
                relatedPerson.phoneNumber3 != null &&
                    relatedPerson.phoneNumber3!.isNotEmpty)
            .forEach(removeParent);

        // Remove Student if parent is unselected
        selectedParents.forEach((element) {
          if (!person.childRelations!.contains(element)) {
            removeStudent(person);
          }
        });
      }
    }

    // Check if no phone number found for parent
    if (person.childRelations == null ||
        person.childRelations!.every((element) =>
            element.phoneNumber1 == null &&
            element.phoneNumber2 == null &&
            element.phoneNumber3 == null)) {
      GFToast.showToast(
        "No phone number found for parent",
        context,
        toastPosition: GFToastPosition.BOTTOM,
        backgroundColor: CustomColor.red,
        toastBorderRadius: 12.0,
        toastDuration: 5,
      );
    }
  }

  void handleCheckboxChangedForSendSMS(PersonModel person, bool? value) {
    value!
        ? (person.phoneNumber1 != null && person.phoneNumber1!.isNotEmpty ||
                person.phoneNumber2 != null &&
                    person.phoneNumber2!.isNotEmpty ||
                person.phoneNumber3 != null && person.phoneNumber3!.isNotEmpty)
            ? handleAddPersonForSendSMS(person)
            : null
        : (person.phoneNumber1 != null && person.phoneNumber1!.isNotEmpty ||
                person.phoneNumber2 != null &&
                    person.phoneNumber2!.isNotEmpty ||
                person.phoneNumber3 != null && person.phoneNumber3!.isNotEmpty)
            ? handleRemovePersonForSendSMS(person)
            : null;

    if (person.phoneNumber1 == null &&
        person.phoneNumber2 == null &&
        person.phoneNumber3 == null) {
      GFToast.showToast(
        "No phone number found",
        context,
        toastPosition: GFToastPosition.BOTTOM,
        backgroundColor: CustomColor.red,
        toastBorderRadius: 12.0,
        toastDuration: 5,
      );
    }
  }

  void handleAddPersonForSendSMS(PersonModel person) {
    personSelectionSendSMS[0] ? addAllPeopleSendSMS(person) : null;
    personSelectionSendSMS[1] ? addStudentsSendSMS(person) : null;
    personSelectionSendSMS[2] ? addParentsSendSMS(person) : null;
    personSelectionSendSMS[3] ? addTeachersSendSMS(person) : null;
  }

  void handleRemovePersonForSendSMS(PersonModel person) {
    personSelectionSendSMS[0] ? removeAllPeopleSendSMS(person) : null;
    personSelectionSendSMS[1] ? removeStudentsSendSMS(person) : null;
    personSelectionSendSMS[2] ? removeParentsSendSMS(person) : null;
    personSelectionSendSMS[3] ? removeTeachersSendSMS(person) : null;
  }

  AppBar _buildAppBar(
      List<SizedBox> toggleOptions, List<SizedBox> toggleOptionsSendSMS) {
    return AppBar(
      title: _buildAppBarTitle(widget.parentSection),
      iconTheme: _buildAppBarIconTheme(),
      centerTitle: true,
      backgroundColor: _buildAppBarBackgroundColor(),
      actions: _buildAppBarActions(widget.parentSection),
      bottom: _buildAppBarBottom(toggleOptions, toggleOptionsSendSMS),
    );
  }

  Widget _buildAppBarTitle(ParentSection parentSection) {
    switch (parentSection) {
      case ParentSection.sms:
        return Text(
          "Select students",
          style: TextStyle(
            color: secondaryColorSelection(parentSection),
          ),
        );
      case ParentSection.letter:
        return Text(
          "Select student",
          style: TextStyle(
            color: secondaryColorSelection(parentSection),
          ),
        );
      case ParentSection.conversation:
        return Text(
          "Select student",
          style: TextStyle(
            color: secondaryColorSelection(parentSection),
          ),
        );
      case ParentSection.todo:
        return Text(
          "Log Todo Reminder",
          style: TextStyle(
            color: secondaryColorSelection(parentSection),
          ),
        );
      case ParentSection.students:
        return Text(
          "Students",
          style: TextStyle(
            color: secondaryColorSelection(parentSection),
          ),
        );
      case ParentSection.sendSMS:
        return Text(
          "Send SMS",
          style: TextStyle(
            color: SMSRecipientColors.primaryColor,
          ),
        );
      case ParentSection.contacts:
        return Text(
          "Manage contacts",
          style: TextStyle(
            color: secondaryColorSelection(parentSection),
          ),
        );
      default:
        return Text(
          "Send SMS",
          style: TextStyle(
            color: secondaryColorSelection(parentSection),
          ),
        );
    }
  }

  IconThemeData _buildAppBarIconTheme() {
    return IconThemeData(
      color: widget.parentSection == ParentSection.sendSMS
        ? SMSRecipientColors.primaryColor
        : secondaryColorSelection(widget.parentSection),
    );
  }

  Color _buildAppBarBackgroundColor() {
    return widget.parentSection == ParentSection.sendSMS
        ? SMSRecipientColors.secondaryColor.withOpacity(.3)
        : primaryColorSelection(widget.parentSection);
  }

  List<Widget> _buildAppBarActions(ParentSection parentSection) {
    return [
      _buildAuthBlocListener(),
      _buildReminderBlocListener(),
      _buildSMSBlocListener(),
      _buildAddButton(),
    ];
  }

  Widget _buildAuthBlocListener() {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (isCurrentPage) {
          _handleRefreshStateChange(context, state);
          _handleLogoutStateChange(context, state);
        }
      },
      child: Container(),
    );
  }

  Widget _buildReminderBlocListener() {
    return BlocListener<ReminderBloc, ReminderState>(
      listener: (context, state) {
        if (isCurrentPage) {
          _handleReminderStateChange(context, state);
        }
      },
      child: Container(),
    );
  }

  Widget _buildSMSBlocListener() {
    return BlocListener<SMSBloc, SMSState>(
      listener: (context, state) {
        if (isCurrentPage) {
          _handleSMSStateChange(context, state);
        }
      },
      child: Container(),
    );
  }

  Widget _buildAddButton() {
    return widget.parentSection == ParentSection.students
        ? IconButton(
            onPressed: () {
              nextScreen(
                context: context,
                screen: const PersonDetails(screenFunction: ScreenFunction.add, contactVariant: ContactVariant.student,),
              );
            },
            icon: const Icon(Icons.add_rounded),
          )
        : Container();
  }

  PreferredSizeWidget _buildAppBarBottom(
      List<SizedBox> toggleOptions, List<SizedBox> toggleOptionsSendSMS) {
    return PreferredSize(
      preferredSize: _buildPreferredSize(),
      child: _buildColumn(toggleOptions, toggleOptionsSendSMS),
    );
  }

  Size _buildPreferredSize() {
    return Size(
      double.infinity,
      widget.parentSection == ParentSection.sendSMS ?
        190 
        : widget.parentSection == ParentSection.contacts
          ? 170
          : 80,
    );
  }

  Padding _buildColumn(
      List<SizedBox> toggleOptions, List<SizedBox> toggleOptionsSendSMS) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.parentSection == ParentSection.contacts)
            _buildDropDownGroups(),
          // _buildSizedBox(),
          _buildCustomGroups(),
          _buildCustomTextField(),
          // _buildParentSelectionSendSMS(toggleOptionsSendSMS),
          // _buildSizedBox(),
          _buildCustomizeParentSelectionSendSMSSearch(),
          // Select All Button
          // _buildSelectAllButton(),
        ],
      ),
    );
  }

  Widget _buildDropDownGroups() {
    return CustomDropDownMenu(
      color: secondaryColorSelection(widget.parentSection),
      options: ["Groups", "All people", ...Constants.personRoles],
      onChanged: _updateSelectedContactType,
      value: selectedContactType,
    );
  }

  Widget _buildSizedBox() {
    return widget.parentSection == ParentSection.sendSMS
        ? const SizedBox(height: 20)
        : Container();
  }

  Widget _buildCustomTextField() {
    return widget.parentSection != ParentSection.sendSMS
        ? CustomTextField(
            color: secondaryColorSelection(widget.parentSection),
            hintText: "Search...",
            controller: searchController,
            onChanged: search,
          )
        : Container();
  }

  Widget _buildCustomGroups() {
    return widget.parentSection == ParentSection.sendSMS
      ?
      Column(
        children: [
          DropdownMenu<String>(
            leadingIcon: Icon(Icons.filter_list_alt, color: SMSRecipientColors.primaryColor),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:  const BorderSide(
                  color: Color(0xff1877F2),
                  width: 1
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(70),
                borderSide: const BorderSide(
                  color: Color(0xff1877F2),
                  width: 1
                ),
              ),
            ),
            width: 390,
            initialSelection: selectedGroupDropdownValue,
            onSelected: (String? value) => handleChangeDropdownItem(value),  
            // enabled: Constants.selectedGroups[0] false,
            dropdownMenuEntries: Constants.selectedGroups.map<DropdownMenuEntry<String>>((item) {
              return DropdownMenuEntry<String>(
                value: item, 
                label: item,
                style: ButtonStyle(
                  side: MaterialStateProperty.all<BorderSide>(
                    const BorderSide(
                      width: 0.01,
                      color: Color(0xff1877F2),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          GestureDetector(
            onTap: () {
              print("tada.....");
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                "All recipients",
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xff1877F2),
                ),
              ),
            ),
            ),
          ),
        ],
      )
      : Container();
  }

  Widget _buildParentSelectionSendSMS(List<SizedBox> toggleOptionsSendSMS) {
    return widget.parentSection == ParentSection.sendSMS
        ? Center(
            child: ToggleButtons(
              borderWidth: 1.3,
              renderBorder: true,
              selectedColor: Colors.white,
              fillColor: SMSRecipientColors.primaryColor,
              borderRadius: BorderRadius.circular(50),
              selectedBorderColor: SMSRecipientColors.primaryColor,
              borderColor: SMSRecipientColors.primaryColor,
              color: SMSRecipientColors.primaryColor,
              // constraints: const BoxConstraints.expand(width: 400 / 4.3),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: CustomFontSize.small,
              ),
              isSelected: personSelectionSendSMS,
              onPressed: updatePersonSelectionSendSMS,
              children: toggleOptionsSendSMS,
            ),
          )
        : Container();
  }

  Widget _buildCustomizeParentSelectionSendSMSSearch() {
    return widget.parentSection == ParentSection.sendSMS
        ? CustomTextField(
            color: SMSRecipientColors.primaryColor,
            fillColor: SMSRecipientColors.fifthColor,
            hintText: "Search...",
            controller: searchController,
            onChanged: searchSendSMS,
          )
        : Container();
  }

  // Widget _selectALlButton(){
    // return widget.parentSection == ParentSection.sendSMS
    //     ? GFButton(
    //         onPressed: () {
    //           setState(() {
    //             personSelectionSendSMS = [true, false, false, false];
    //             selectedAllPeopleSendSMS = [...allPeople];
    //             selectedStudentsSendSMS = [...students];
    //             selectedParentsSendSMS = [...parents];
    //             selectedTeachersSendSMS = [...teachers];
    //           });
    //         },
    //         text: "Select all",
    //         textStyle: TextStyle(
    //           fontSize: CustomFontSize.small,
    //           color: SMSRecipientColors.primaryColor,
    //         ),
    //         color: SMSRecipientColors.fifthColor,
    //         size: GFSize.LARGE,
    //         shape: GFButtonShape.pills,
    //         type: GFButtonType.outline,
    //         fullWidthButton: true,
    //         icon: Icon(
    //           Icons.check_circle_outline_rounded,
    //           color: SMSRecipientColors.primaryColor,
    //         ),
    //         position: GFPosition.end,
    //       )
    //     : Container();

    // Select All Radio Button
    // return widget.parentSection == ParentSection.sendSMS
    //     ? Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           Text(
    //             "Select all",
    //             style: TextStyle(
    //               fontSize: CustomFontSize.small,
    //               color: SMSRecipientColors.primaryColor,
    //             ),
    //           ),
    //           Radio(
    //             value: true,
    //             groupValue: selectAll,
    //             onChanged: (value) {
    //               setState(() {
    //                 selectAll = value as bool;
    //                 personSelectionSendSMS = [true, false, false, false];
    //                 selectedAllPeopleSendSMS = [...allPeople];
    //                 selectedStudentsSendSMS = [...students];
    //                 selectedParentsSendSMS = [...parents];
    //                 selectedTeachersSendSMS = [...teachers];
    //               });
    //             },
    //             activeColor: SMSRecipientColors.primaryColor,
    //           ),
    //         ],
    //       )
    //     : Container();
  // }

}
