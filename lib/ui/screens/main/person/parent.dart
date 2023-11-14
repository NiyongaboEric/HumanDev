import 'dart:convert';
import 'dart:math';

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:seymo_pay_mobile_application/data/reminders/model/reminder_request.dart';
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
  List<RelatedPersons> selectedParents = <RelatedPersons>[];
  List<PersonModel> students = <PersonModel>[];
  List<RelatedPersons> relatives = <RelatedPersons>[];
  List<PersonModel> parents = <PersonModel>[];
  List<PersonModel> teachers = <PersonModel>[];
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
  List<bool> personSelection = [true, false, false];

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

  // Search Function
  search(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        showResults = false;
      });
    } else {
      
      setState(() {
        showResults = true;
        searchResults = students
            .toSet()
            .toList()
            .where((student) =>
                student.firstName.toLowerCase().contains(query) ||
                (student.middleName ?? "").toLowerCase().contains(query) ||
                student.lastName1.toLowerCase().contains(query) ||
                (student.lastName2 ?? "").toLowerCase().contains(query))
            .toList();
      });
    }
  }

  void addParent(RelatedPersons parents) {
    setState(() {
      selectedParents.add(parents);
    });
  }

  void removeParent(RelatedPersons parents) {
    setState(() {
      // for (var parent in parents) {
      //   selectedParents.remove(parent);
      // }
      selectedParents.remove(parents);
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
        return const SendSMS();
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
      });
      for (var person in state.persons) {
        if (person.role == Role.STUDENT) {
          if (!students.contains(person)) {
            students.add(person);
            if (person.relatedPersons != null) {
              relatives.addAll(person.relatedPersons!);
            }
            randomNumbers.add((50 + Random().nextInt(150 - 50)));
          }
        }
        if (person.role == Role.RELATIVE) {
          if (!parents.contains(person)) {
            parents.add(person);
          }
        }
        if (person.role == Role.TEACHER) {
          if (!teachers.contains(person)) {
            teachers.add(person);
          }
        }

        students = students.toSet().toList();
      }
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
        child: Center(child: Text("Students")),
      ),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 20) / 3,
        child: Center(child: Text("Parents")),
      ),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 20) / 3,
        child: Center(child: Text("Teachers")),
      ),
    ];

    // Get the list of first characters from students list
    List<String> firstCharacters = students.map((student) {
      return student.firstName.substring(0, 1);
    }).toList();

    alphabetView = firstCharacters.map(
      (alphabet) {
        students.sort((a, b) => a.firstName.compareTo(b.firstName));
        return AlphabetListViewItemGroup(
            tag: alphabet,
            children: students.map((relative) {
              if (relative.firstName.startsWith(alphabet)) {
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
                      // leading: CircleAvatar(
                      //   child: Icon(
                      //     Icons.person_rounded,
                      //     color: SecondaryColors.secondaryYellow.withOpacity(0.7),
                      //   ),
                      // ),
                      title: Text(
                          "${relative.firstName} ${relative.middleName ?? ""} ${relative.lastName1}",
                          style: TextStyle(
                            color: secondaryColorSelection(parentSection),
                            fontSize: CustomFontSize.medium,
                          )),
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
                                (relative.relatedPersons == null ||
                                        relative.relatedPersons!.isEmpty ||
                                        relative.relatedPersons!.any(
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
                      trailing: parentSection == ParentSection.sms
                          ? Checkbox(
                              activeColor: primaryColorSelection(parentSection),
                              value: selectedParents.any((selectedParent) {
                                return relative.relatedPersons
                                        ?.contains(selectedParent) ??
                                    false;
                              }),
                              onChanged: (value) {
                                if (relative.relatedPersons != null) {
                                  if (value!) {
                                    for (var relatedPerson
                                        in relative.relatedPersons!) {
                                      if (relatedPerson.phoneNumber != null ||
                                          relatedPerson
                                              .phoneNumber!.isNotEmpty) {
                                        addParent(relatedPerson);
                                      }
                                    }
                                  } else {
                                    for (var relatedPerson
                                        in relative.relatedPersons!) {
                                      if (relatedPerson.phoneNumber != null ||
                                          relatedPerson
                                              .phoneNumber!.isNotEmpty) {
                                        removeParent(relatedPerson);
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
      return student.firstName.substring(0, 1);
    }).toList();

    searchResultAlphabetView = searchResultsFirstCharacters.map(
      (alphabet) {
        searchResults.sort((a, b) => a.firstName.compareTo(b.firstName));
        return AlphabetListViewItemGroup(
            tag: alphabet,
            children: searchResults.map((relative) {
              if (relative.firstName.startsWith(alphabet)) {
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
                      title: Text(
                          "${relative.firstName} ${relative.middleName ?? ""} ${relative.lastName1}",
                          style: TextStyle(
                            color: secondaryColorSelection(parentSection),
                            fontSize: CustomFontSize.medium,
                          )),
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
                                (relative.relatedPersons == null ||
                                        relative.relatedPersons!.isEmpty ||
                                        relative.relatedPersons!.any(
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
                      trailing: parentSection == ParentSection.sms
                          ? Checkbox(
                              activeColor: primaryColorSelection(parentSection),
                              value: selectedParents
                                  .contains(relative.relatedPersons?.first),
                              onChanged: (value) {
                                if (relative.relatedPersons != null) {
                                  if (value!) {
                                    for (var relatedPerson
                                        in relative.relatedPersons!) {
                                      if (relatedPerson.phoneNumber != null ||
                                          relatedPerson
                                              .phoneNumber!.isNotEmpty) {
                                        addParent(relatedPerson);
                                      }
                                    }
                                    // addParent(relative.relatedPersons!);
                                  } else {
                                    for (var relatedPerson
                                        in relative.relatedPersons!) {
                                      if (relatedPerson.phoneNumber != null ||
                                          relatedPerson
                                              .phoneNumber!.isNotEmpty) {
                                        removeParent(relatedPerson);
                                      }
                                    }
                                    // removeParent(relative.relatedPersons!);
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
                    color: primaryColorSelection(parentSection).shade200,
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
          if (student.firstName.toLowerCase().contains(searchController.text)) {
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
              title: Text(
                "Select students",
                style: TextStyle(
                  color: secondaryColorSelection(parentSection),
                ),
              ),
              iconTheme: IconThemeData(
                color: secondaryColorSelection(parentSection),
              ),
              centerTitle: true,
              backgroundColor: primaryColorSelection(parentSection).shade100,
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
                        onPressed: () {}, icon: Icon(Icons.add_rounded))
                    : Container()
              ],
              bottom: PreferredSize(
                preferredSize: Size(double.infinity,
                    widget.parentSection == ParentSection.family ? 150 : 80),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.parentSection == ParentSection.family
                          ? ToggleButtons(
                              selectedColor: Colors.white,
                              fillColor:
                                  primaryColorSelection(parentSection).shade300,
                              borderRadius: BorderRadius.circular(50),
                              children: toggleOptions,
                              isSelected: personSelection,
                              onPressed: updatePersonSelection,
                            )
                          : Container(),
                      widget.parentSection == ParentSection.family
                          ? SizedBox(
                              height: 10,
                            )
                          : Container(),
                      CustomTextField(
                        color: secondaryColorSelection(parentSection),
                        hintText: "Search...",
                        controller: searchController,
                        onChanged: search,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: parentSection == ParentSection.sms
                ? Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: FloatingActionButton.extended(
                      backgroundColor: parentSection == ParentSection.sms
                          ? selectedParents.isEmpty
                              ? Colors.grey.shade300
                              : Colors.orange.shade100
                          : selectedParents.isEmpty
                              ? Colors.grey
                              : Colors.red.shade100,
                      onPressed: selectedParents.isEmpty
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
                                color: selectedParents.isEmpty
                                    ? Colors.grey
                                    : secondaryColorSelection(parentSection)),
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
