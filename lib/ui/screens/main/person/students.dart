import 'dart:convert';

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_request.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_response.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/data/journal/model/request_model.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/contacts/person_details.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/bloc/journal_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/recieved_money/tuition_fee/tuition_fee_record.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/drop_down_menu.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../data/groups/model/group_model.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/custom_colors.dart';
import '../../../utilities/font_sizes.dart';
import '../../../widgets/constants/offline_model.dart';
import '../../auth/login.dart';
import '../../home/homepage.dart';
import 'bloc/person_bloc.dart';

// This Widget/Screen is meant for Transactions and send SMS to Student Screens...

var sl = GetIt.instance;

// Enum for Feeding Fees, Tuition Fees and Student Contact Screens.
enum StudentOption { feeding, tuition, studentContact }

class Students extends StatefulWidget {
  final bool select;
  final StudentOption option;
  const Students({
    super.key,
    required this.select,
    required this.option,
  });

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  bool logout = false;
  TextEditingController searchController = TextEditingController();
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  var preferences = sl<SharedPreferences>();
  var prefs = sl<SharedPreferenceModule>();
  List<PersonModel> searchResults = [];
  List<PersonModel> students = [];
  List<PersonModel> selectedStudents = [];
  // Groups
  List<String> groups = [];
  String selectedGroup = "All groups";
  bool showResults = false;
  String errorMsg = "";
  late List<AlphabetListViewItemGroup> studentAlphabetView;
  late List<AlphabetListViewItemGroup> searchResultAlphabetView;
  bool loading = false;
  Key studentData = const Key("student-data");
  bool isCurrentPage = false;

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

  // Update Groups
  void _updateGroups(group) {
    setState(() {
      selectedGroup = group;
    });
  }

    // Filter Selected Group Students
  List<PersonModel> filterSelectedGroupContacts(String group) {
    if (group == "All groups") {
      return students;
    }
    return students.where((element) => element.role == group).toList();
  }

  // Refresh Tokens
  void _refreshTokens() {
    var prefs = sl<SharedPreferenceModule>();
    TokenResponse? token = prefs.getToken();
    if (token != null) {
      context.read<AuthBloc>().add(
            AuthEventRefresh(
              RefreshRequest(refresh: token.refreshToken),
            ),
          );
    }
  }

  // Logout
  void _logout() {
    context.read<AuthBloc>().add(const AuthEventLogout());
  }

  // Set Selected Students
  void _onSelected(bool selected, PersonModel dataName) {
    if (selected == true) {
      setState(() {
        selectedStudents.add(dataName);
      });
    } else {
      setState(() {
        selectedStudents.remove(dataName);
      });
    }
  }

  _getAllStudents() {
    context.read<PersonBloc>().add(const GetAllPersonEvent());
  }

  // Handle Student State Change
  _handlePersonStateChange(BuildContext context, PersonState state) {
    if (state.status == PersonStatus.success) {
      // Clear the existing students list before adding new students
      setState(() {
        students.clear();
      });
      // Handle Success
      for (var person in state.persons) {
        // Add Group names to groups list
        // if (person.groups != null) {
        //   for (var group in person.groups!) {
        //     if (!groups.contains(group.name)) {
        //       groups.add(group.name!);
        //     }
        //   }
        // }

        if (person.role == Role.Student.name) {
          if (!students.contains(person)) {
            students.add(person);
          } else {
            students.remove(person);
          }
        }
      }
      var offlineStudentList = json.encode(students);
      preferences.setString("students", offlineStudentList);
    }
    if (state.status == PersonStatus.error) {
      // if (state.errorMessage == "Unauthorized" ||
      //     state.errorMessage == "Exception: Unauthorized") {
      //   _refreshTokens();
      // } else {
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
      // }
    }
  }

  // Create Journal Record
  void createJournalRecord() {
    // TODO: implement createJournalRecord
    var accounts = prefs.getAccounts();
    var space = prefs.getSpaces().first;
    context.read<JournalBloc>().add(
          AddNewReceivedMoneyJournalEvent(
            selectedStudents.map((student) {
              return ReceivedMoneyJournalRequest(
                creditAccountId: accounts
                    .firstWhere(
                        (element) => element.name.name == "ACCOUNTS_RECEIVABLE")
                    .id,
                debitAccountId: accounts
                    .firstWhere((element) => element.name.name == "CASH")
                    .id,
                subaccountPersonId: student.id,
                amount: 85,
                currency: space.currency ?? "GHS",
                reason: "Feeding Fees",
                sendSMS: false,
                isInvoicePayment: false,
                studentPersonId: student.id,
              );
            }).toList(),
            // ReceivedMoneyJournalRequest(
            //   creditAccountId: 1,
            //   debitAccountId: 1,
            //   amount: 85,
            //   reason: "Feeding Fees",
            //   sendSMS: false,
            //   personIds: selectedStudents.map((e) => e.id).toList(),
            // ),
          ),
        );
  }

  // Save Offline
  saveOffline() {
    var accounts = prefs.getAccounts();
    var space = prefs.getSpaces().first;
    List<OfflineModel> offlineTuitionFee = [];
    List<ReceivedMoneyJournalRequest> feedingFeesRequest = [];
    String? value = preferences.getString("offlineFeedingFee");
    if (value != null) {
      List<dynamic> decodedValue = json.decode(value);
      offlineTuitionFee.addAll(
          decodedValue.map((model) => OfflineModel.fromJson(model)).toList());
    }
    feedingFeesRequest.add(
      ReceivedMoneyJournalRequest(
        creditAccountId: accounts
            .firstWhere((element) => element.name.name == "ACCOUNTS_RECEIVABLE")
            .id,
        debitAccountId:
            accounts.firstWhere((element) => element.name.name == "CASH").id,
        subaccountPersonId: 1,
        amount: 85,
        currency: space.currency ?? "GHS",
        reason: "Feeding Fees",
        sendSMS: false,
        studentPersonId: 1,
      ),
      // ReceivedMoneyJournalRequest(
      //   creditAccountId: 1,
      //   debitAccountId: 1,
      //   amount: 85,
      //   reason: "Feeding Fees",
      //   sendSMS: false,
      //   personIds: selectedStudents.map((e) => e.id).toList(),
      // ),
    );
    offlineTuitionFee.add(
      OfflineModel(
        id: DateTime.now().toString(),
        title: "Feeding Fee",
        data: feedingFeesRequest,
        status: UploadStatus.initial,
      ),
    );
    preferences.setString(
      "offlineFeedingFee",
      json.encode(
        offlineTuitionFee.map((model) => model.toJson()).toList(),
      ),
    );
  }

  // Handle Tuition Transaction Change State
  _handleJournalStateChange(BuildContext context, JournalState state) {
    setState(() {
      loading = state.isLoading;
    });
    if (state.status == JournalStatus.success) {
      // Handle Success
      GFToast.showToast(
        state.successMessage,
        context,
        toastBorderRadius: 8.0,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        backgroundColor: primaryColorSelection(widget.option).shade700,
        toastDuration: 6,
      );
      nextScreenAndRemoveAll(context: context, screen: const HomePage());
    }
    if (state.status == JournalStatus.error) {
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

  // Handle Refresh State
  _handleRefreshState(BuildContext context, AuthState state) {
    if (logout) {
      return;
    }
    if (state.status == AuthStateStatus.authenticated) {
      // Handle Success
      return _getAllStudents();
    }
    if (state.status == AuthStateStatus.unauthenticated) {
      logger.e(state.refreshFailure);
      if (state.refreshFailure != null &&
              state.refreshFailure == "Invalid refresh token." ||
          state.refreshFailure == "Exception: Invalid refresh token.") {
        setState(() {
          logout = true;
        });
        return _logout();
      } else {
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
    // TODO: implement initState
    _connectivity.onConnectivityChanged.listen((result) {
      _connectivityResult = result;
    });
    String? studentValue = preferences.getString("students");
    String? groupValue = preferences.getString("groups");
    if (studentValue != null) {
      List<dynamic> studentData = json.decode(studentValue);
      try {
        List<PersonModel> studentList = studentData.map((data) {
          return PersonModel.fromJson(data);
        }).toList();
        students.addAll(studentList);
      } catch (e) {
        logger.f(studentData);
        logger.w(e);
      }
    }
    if (groupValue != null) {
      List<dynamic> groupData = json.decode(groupValue);
      try {
        List<Group> groupList = groupData.map((data) {
          return Group.fromJson(data);
        }).toList();
        // Add ones with only student name
        for (var group in groupList) {
          if (group.name == "Student") {
            groups.add(group.name!);
          }
        }
      } catch (e) {
        logger.f(groupData);
        logger.w(e);
      }
    }
    _getAllStudents();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    students.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSelect = widget.select;

    // Initialize the AlphabetListViewOptions
    final AlphabetListViewOptions options = _buildAlphabetListViewOptions();
    List<String> firstCharacters = getFirstCharacters(students);
    List<String> searchResultsFirstCharacters =
        getFirstCharacters(searchResults);

    studentAlphabetView =
        buildAlphabetView(firstCharacters, students, isSelect);
    searchResultAlphabetView = buildAlphabetView(
        searchResultsFirstCharacters, searchResults, isSelect);

    searchController.addListener(() {
      updateSearchResults();
    });

    // options = getAlphabetListViewOptions();

    return VisibilityDetector(
      key: studentData,
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
          if (isCurrentPage) {
            _handlePersonStateChange(context, state);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: primaryColorSelection(widget.option).shade50,
            bottomNavigationBar: widget.option == StudentOption.feeding
                ? _buildBottomNavigationBar(isSelect)
                : null,
            appBar: _buildAppBar(options),
            body: _buildBody(options, state),
          );
        },
      ),
    );
  }

  List<String> getFirstCharacters(List<PersonModel> students) {
    return students.map((student) {
      return student.firstName.substring(0, 1);
    }).toList();
  }

  List<AlphabetListViewItemGroup> buildAlphabetView(
      List<String> firstCharacters, List<PersonModel> students, bool isSelect) {
    return firstCharacters.map(
      (alphabet) {
        selectedGroupPeople() {
          if (selectedGroup == groups[0]) {
            // Students in initial group
          }
        }

        students.sort((a, b) => a.firstName.compareTo(b.firstName));
        return AlphabetListViewItemGroup(
          tag: alphabet,
          children: buildStudentListTiles(alphabet, students, isSelect),
        );
      },
    ).toList();
  }

  List<Widget> buildStudentListTiles(
      String alphabet, List<PersonModel> students, bool isSelect) {
    return students.map((student) {
      if (student.firstName.startsWith(alphabet)) {
        return buildStudentTile(student, isSelect);
      }
      return Container();
    }).toList();
  }

  Widget buildStudentTile(PersonModel student, bool isSelect) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            onStudentTileTap(student, isSelect, widget.option);
          },
          title: Text(
            [
              student.firstName ?? "First Name",
              student.middleName ?? "",
              student.lastName1 ?? "Last Name",
              student.lastName2 ?? ""
            ].join(" ").trim(),
            style: TextStyle(
                fontSize: CustomFontSize.small,
                color: _secondaryColorSelection(widget.option)),
          ),
          trailing: isSelect
              ? Checkbox(
                  activeColor: primaryColorSelection(widget.option),
                  value: selectedStudents.contains(student),
                  onChanged: (value) {
                    _onSelected(value!, student);
                  },
                )
              : Container(
                  width: 0,
                ),
        ),
        Divider(
          color: _secondaryColorSelection(widget.option).withOpacity(0.2),
        ),
      ],
    );
  }

  void onStudentTileTap(
      PersonModel student, bool isSelect, StudentOption option) async {
    if (!isSelect) {
      if (option == StudentOption.tuition) {
        nextScreen(
          context: context,
          screen: TuitionFeeRecord(student: student),
        );
      }
      if (option == StudentOption.studentContact) {
        bool? refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetails(
              screenFunction: ScreenFunction.edit,
              contactVariant: ContactVariant.student,
              person: student,
            ),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        logger.d("Update Refresh: $refresh");
        if (refresh != null && refresh) {
          _getAllStudents();
        }
        // nextScreen(
        //   context: context,
        //   screen: PersonDetails(
        //     screenFunction: ScreenFunction.edit,
        //     contactVariant: ContactVariant.student,
        //     person: student,
        //   ),
        // );
      }
    }
  }

  void updateSearchResults() {
    if (searchController.text.isNotEmpty) {
      searchResults.clear();
      for (var student in students) {
        if (student.firstName.toLowerCase().contains(searchController.text)) {
          searchResults.add(student);
        }
      }
    } else {
      searchResults.clear();
      searchResults.addAll(students);
    }
  }

  AlphabetListViewOptions _buildAlphabetListViewOptions() {
    return AlphabetListViewOptions(
      listOptions: _buildListOptions(),
      scrollbarOptions: _buildScrollbarOptions(),
      overlayOptions: _buildOverlayOptions(),
    );
  }

  ListOptions _buildListOptions() {
    return ListOptions(
      listHeaderBuilder: (context, symbol) => _buildListHeader(symbol),
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
            decoration: BoxDecoration(
              color: primaryColorSelection(widget.option).shade200,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(symbol,
                  style: TextStyle(
                      color: _secondaryColorSelection(widget.option),
                      fontSize: CustomFontSize.small)),
            ),
          ),
        ),
      ],
    );
  }

  ScrollbarOptions _buildScrollbarOptions() {
    return ScrollbarOptions(
      backgroundColor: primaryColorSelection(widget.option).shade50,
    );
  }

  OverlayOptions _buildOverlayOptions() {
    return OverlayOptions(
      showOverlay: true,
      overlayBuilder: (context, symbol) => _buildOverlay(symbol),
    );
  }

  Widget _buildOverlay(String symbol) {
    return Container(
      height: 150,
      width: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: primaryColorSelection(widget.option).shade300.withOpacity(0.6),
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
  }

  AppBar _buildAppBar(AlphabetListViewOptions options) {
    return AppBar(
      iconTheme: IconThemeData(
        color: _secondaryColorSelection(widget.option),
      ),
      title: Text(_appBarTitle(widget.option),
          style: TextStyle(
            color: _secondaryColorSelection(widget.option),
          )),
      centerTitle: true,
      actions: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (isCurrentPage) {
              _handleRefreshState(context, state);
              _handleLogoutStateChange(context, state);
            }
          },
          child: Container(),
        ),
        BlocListener<JournalBloc, JournalState>(
            listener: (context, state) {
              if (isCurrentPage) {
                _handleJournalStateChange(context, state);
              }
            },
            child: Container()),
        if (widget.option == StudentOption.studentContact)
          IconButton(
              onPressed: () async {
                var refresh = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDetails(
                      screenFunction: ScreenFunction.add,
                      contactVariant: ContactVariant.student,
                    ),
                  ),
                );
                await Future.delayed(const Duration(seconds: 2));
                logger.d("Create Refresh: $refresh");
                if (refresh != null && refresh) {
                  _getAllStudents();
                }
                // nextScreen(
                //     context: context,
                //     screen: const PersonDetails(
                //       contactVariant: ContactVariant.student,
                //         screenFunction: ScreenFunction.add));
              },
              icon: const Icon(
                Icons.add_rounded,
                size: 28,
              ))
      ],
      backgroundColor: primaryColorSelection(widget.option).shade100,
      bottom: PreferredSize(
        preferredSize: Size(double.infinity,
            widget.option == StudentOption.studentContact ? 170 : 80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              // Student Groups
              widget.option == StudentOption.studentContact
                  ? CustomDropDownMenu(
                      color: _secondaryColorSelection(widget.option),
                      options: [
                        "Select group",
                        "All groups",
                        ...groups,
                      ],
                      value: selectedGroup,
                      onChanged: _updateGroups,
                    )
                  : Container(),
              CustomTextField(
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: _secondaryColorSelection(widget.option),
                ),
                color: _secondaryColorSelection(widget.option),
                hintText: "Search...",
                controller: searchController,
                onChanged: search,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AlphabetListViewOptions options, PersonState state) {
    return state.isLoading && students.isEmpty
        ? const Center(
            child: GFLoader(type: GFLoaderType.ios),
          )
        : errorMsg.isNotEmpty
            ? Center(
                child: Text(
                  errorMsg,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              )
            : showResults
                ? searchResults.isEmpty
                    ? const Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : AlphabetListView(
                        items: searchResultAlphabetView,
                        options: options,
                      )
                : students.isEmpty
                    ? const Center(
                        child: Text(
                          "No students found",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : AlphabetListView(
                        options: options,
                        items: studentAlphabetView,
                      );
  }

  Widget _buildBottomNavigationBar(bool isSelect) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: CustomColor.grey.withOpacity(0.5),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBottomNavigationBarText(),
              _buildFloatingActionButton(isSelect),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBarText() {
    return selectedStudents.isEmpty
        ? Text("GHS 85.00 per student",
            style: TextStyle(
              fontSize: CustomFontSize.small,
              color: _secondaryColorSelection(widget.option),
            ))
        : Column(
            children: [
              Text(
                  "${selectedStudents.length} ${selectedStudents.length > 1 ? "children" : "child"}",
                  style: TextStyle(
                    fontSize: CustomFontSize.small,
                    color: _secondaryColorSelection(widget.option),
                  )),
              Text("GHS ${selectedStudents.length * 85}",
                  style: TextStyle(
                    fontSize: CustomFontSize.small,
                    color: _secondaryColorSelection(widget.option),
                  )),
            ],
          );
  }

  Widget _buildFloatingActionButton(bool isSelect) {
    return isSelect && students.isNotEmpty
        ? FloatingActionButton.extended(
            backgroundColor: selectedStudents.isNotEmpty
                ? primaryColorSelection(widget.option).shade300
                : Colors.grey.shade300,
            onPressed: selectedStudents.isNotEmpty
                ? () {
                    if (selectedStudents.isNotEmpty) {
                      createJournalRecord();
                    } else {
                      _showToast();
                    }
                  }
                : null,
            label: SizedBox(
              width: 80,
              child: Center(
                child: !loading
                    ? Text("Save",
                        style: TextStyle(
                          fontSize: CustomFontSize.large,
                          color: selectedStudents.isNotEmpty
                              ? _secondaryColorSelection(widget.option)
                              : Colors.grey,
                        ))
                    : CircularProgressIndicator(
                        color: _secondaryColorSelection(widget.option),
                      ),
              ),
            ),
          )
        : Container();
  }

  void _showToast() {
    // GF Toast
    GFToast.showToast(
      "No student selected",
      context,
      toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
          ? GFToastPosition.TOP
          : GFToastPosition.BOTTOM,
      toastBorderRadius: 12.0,
      toastDuration: 5,
      backgroundColor: Colors.red,
    );
  }

  Color _secondaryColorSelection(StudentOption studentOption) {
    if (studentOption == StudentOption.tuition) {
      return SecondaryColors.secondaryGreen;
    } else if (studentOption == StudentOption.feeding) {
      return SecondaryColors.secondaryGreen;
    } else {
      return SecondaryColors.secondaryPink;
    }
  }

  MaterialColor primaryColorSelection(StudentOption studentOption) {
    if (studentOption == StudentOption.tuition) {
      return Colors.green;
    } else if (studentOption == StudentOption.feeding) {
      return Colors.green;
    } else {
      return Colors.pink;
    }
  }

  String _appBarTitle(StudentOption studentOption) {
    if (studentOption == StudentOption.tuition) {
      return "Select student";
    }
    if (studentOption == StudentOption.feeding) {
      return "Select students";
    }
    return "Manage students";
  }

  // Widget _destinationRoutes(StudentOption studentOption, PersonModel student){
  //   if(studentOption == StudentOption.tuition){
  //     return const Tuition();
  //   }
  //   return const PersonDetails(screenFunction: ScreenFunction.edit, person: student,);
  // }
}
