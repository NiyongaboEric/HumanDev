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
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/bloc/journal_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/recieved_money/tuition_fee/tuition_fee_record.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/custom_colors.dart';
import '../../../utilities/font_sizes.dart';
import '../../../widgets/constants/offline_model.dart';
import '../../auth/login.dart';
import '../../home/homepage.dart';
import 'bloc/person_bloc.dart';

var sl = GetIt.instance;

enum StudentOption { feeding, tuition, smsReminder }

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
  List<PersonModel> searchResults = [];
  List<PersonModel> students = [];
  List<PersonModel> selectedStudents = [];
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
      for (var student in state.students) {
        if (student.role == Role.STUDENT) {
          if (!students.contains(student)) {
            students.add(student);
          } else {
            students.remove(student);
          }
        }
      }
      var offlineStudentList = json.encode(students);
      preferences.setString("students", offlineStudentList);
    }
    if (state.status == PersonStatus.error) {
      if (state.errorMessage == "Unauthorized" ||
          state.errorMessage == "Exception: Unauthorized") {
        _refreshTokens();
      } else {
        GFToast.showToast(
          state.errorMessage,
          context,
          toastBorderRadius: 8.0,
          toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
          toastDuration: 6,
        );
      }
    }
  }

  // Create Journal Record
  void createJournalRecord() {
    // TODO: implement createJournalRecord
    context.read<JournalBloc>().add(
          AddNewJournalEvent(
            JournalRequest(
              creditAccountId: 1,
              debitAccountId: 1,
              amount: 85,
              reason: "Feeding Fees",
              paymentType: PaymentType.RECEIVED_MONEY,
              sendSMS: false,
              personIds: selectedStudents.map((e) => e.id).toList(),
            ),
          ),
        );
  }

  // Save Offline
  saveOffline() {
    var prefs = sl<SharedPreferences>();
    List<OfflineModel> offlineTuitionFee = [];
    List<JournalRequest> feedingFeesRequest = [];
    String? value = prefs.getString("offlineFeedingFee");
    if (value != null) {
      List<dynamic> decodedValue = json.decode(value);
      offlineTuitionFee.addAll(
          decodedValue.map((model) => OfflineModel.fromJson(model)).toList());
    }
    feedingFeesRequest.add(
      JournalRequest(
        creditAccountId: 1,
        debitAccountId: 1,
        amount: 85,
        reason: "Feeding Fees",
        paymentType: PaymentType.RECEIVED_MONEY,
        sendSMS: false,
        personIds: selectedStudents.map((e) => e.id).toList(),
      ),
    );
    offlineTuitionFee.add(
      OfflineModel(
        id: DateTime.now().toString(),
        title: "Feeding Fee",
        data: feedingFeesRequest,
        status: UploadStatus.initial,
      ),
    );
    prefs.setString(
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
        toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,
        toastDuration: 6,
      );
      nextScreenAndRemoveAll(context: context, screen: const HomePage());
    }
    if (state.status == JournalStatus.error) {
      GFToast.showToast(
        state.errorMessage,
        context,
        toastBorderRadius: 8.0,
        toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
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
          toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
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
    String? value = preferences.getString("students");
    if (value != null) {
      List<dynamic> studentData = json.decode(value);
      try {
        List<PersonModel> studentList = studentData.map((data) {
          return PersonModel.fromJson(data);
        }).toList();
        logger.d(studentList);
        students.addAll(studentList);
      } catch (e) {
        logger.f(studentData);
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

    // Get the list of first characters from students list
    List<String> firstCharacters = students.map((student) {
      return student.firstName.substring(0, 1);
    }).toList();

    // Get the list of first characters from searchResults list
    List<String> searchResultsFirstCharacters = searchResults.map((student) {
      return student.firstName.substring(0, 1);
    }).toList();

    studentAlphabetView = firstCharacters.map(
      (alphabet) {
        students.sort((a, b) => a.firstName.compareTo(b.firstName));
        return AlphabetListViewItemGroup(
            tag: alphabet,
            children: students.map((student) {
              if (student.firstName.startsWith(alphabet)) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        if (!isSelect) {
                          nextScreen(
                            context: context,
                            screen: TuitionFeeRecord(
                              student: student,
                            ),
                          );
                        }
                      },
                      title: Text(
                        // Student first and last name
                        "${student.firstName} ${student.lastName1}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: isSelect
                          ? Checkbox(
                              activeColor: Colors.green,
                              value: selectedStudents.contains(student),
                              onChanged: (value) {
                                _onSelected(value!, student);
                              })
                          : Container(
                              width: 0,
                            ),
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                    )
                  ],
                );
              }
              return Container();
            }).toList());
      },
    ).toList();

    searchResultAlphabetView = searchResultsFirstCharacters.map(
      (alphabet) {
        searchResults.sort((a, b) => a.firstName.compareTo(b.firstName));
        return AlphabetListViewItemGroup(
            tag: alphabet,
            children: searchResults.map((student) {
              if (student.firstName.startsWith(alphabet)) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        if (!isSelect) {
                          nextScreen(
                            context: context,
                            screen: TuitionFeeRecord(
                              student: student,
                            ),
                          );
                        }
                      },
                      title: Text(
                        // Student first and last name
                        "${student.firstName} ${student.lastName1}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: isSelect
                          ? Checkbox(
                              activeColor: Colors.green,
                              value: selectedStudents.contains(student),
                              onChanged: (value) {
                                _onSelected(value!, student);
                              })
                          : Container(
                              width: 0,
                            ),
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                    )
                  ],
                );
              }
              return Container();
            }).toList());
      },
    ).toList();

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
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                      child: Text(symbol,
                          style: TextStyle(
                              color: SecondaryColors.secondaryGreen,
                              fontSize: CustomFontSize.small))),
                ),
              ),
            ],
          ),
        ),
        scrollbarOptions: ScrollbarOptions(
          backgroundColor: Colors.green.shade50,
        ),
        overlayOptions: OverlayOptions(
          showOverlay: true,
          overlayBuilder: (context, symbol) {
            return Container(
              height: 150,
              width: 150,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.green.shade300.withOpacity(0.6),
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

    return VisibilityDetector(
      key: studentData,
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1.0) {
          setState(() {
            isCurrentPage = true;
          });
        } else {
          setState(() {
            isCurrentPage = false;
          });
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
            backgroundColor: Colors.green.shade50,
            bottomNavigationBar: widget.option == StudentOption.feeding
                ? Column(
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
                            selectedStudents.isEmpty
                                ? Text("GHS 85.00 per student",
                                    style: TextStyle(
                                      fontSize: CustomFontSize.small,
                                      color: SecondaryColors.secondaryGreen,
                                    ))
                                : Column(
                                    children: [
                                      Text(
                                          "${selectedStudents.length} ${selectedStudents.length > 1 ? "children" : "child"}",
                                          style: TextStyle(
                                            fontSize: CustomFontSize.small,
                                            color:
                                                SecondaryColors.secondaryGreen,
                                          )),
                                      Text(
                                          "GHS ${selectedStudents.length * 85}",
                                          style: TextStyle(
                                            fontSize: CustomFontSize.small,
                                            color:
                                                SecondaryColors.secondaryGreen,
                                          )),
                                    ],
                                  ),
                            isSelect && students.isNotEmpty
                                ? FloatingActionButton.extended(
                                    backgroundColor: selectedStudents.isNotEmpty
                                        ? Colors.green.shade300
                                        : Colors.grey.shade300,
                                    onPressed: selectedStudents.isNotEmpty
                                        ? () {
                                            if (selectedStudents.isNotEmpty) {
                                              createJournalRecord();
                                            } else {
                                              // GF Toast
                                              GFToast.showToast(
                                                "No student selected",
                                                context,
                                                toastPosition:
                                                     MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
                                                toastBorderRadius: 12.0,
                                                toastDuration: 5,
                                                backgroundColor: Colors.red,
                                              );
                                            }
                                          }
                                        : null,
                                    label: SizedBox(
                                      width: 80,
                                      child: Center(
                                        child: !loading
                                            ? Text("Save",
                                                style: TextStyle(
                                                  fontSize:
                                                      CustomFontSize.large,
                                                  color: selectedStudents
                                                          .isNotEmpty
                                                      ? SecondaryColors
                                                          .secondaryGreen
                                                      : Colors.grey,
                                                ))
                                            : CircularProgressIndicator(
                                                color: SecondaryColors
                                                    .secondaryGreen,
                                              ),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  )
                : null,
            appBar: AppBar(
              title: Text(
                  widget.option == StudentOption.tuition
                      ? 'Select student'
                      : "Select students",
                  style: TextStyle(
                    color: SecondaryColors.secondaryGreen,
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
                    child: Container())
              ],
              backgroundColor: Colors.green.shade100,
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 80),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomTextField(
                    color: SecondaryColors.secondaryGreen,
                    hintText: "Search...",
                    controller: searchController,
                    onChanged: search,
                  ),
                ),
              ),
            ),
            body: state.isLoading && students.isEmpty
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
                                  "No Results Found",
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
                        : AlphabetListView(
                            options: options,
                            items: studentAlphabetView,
                          ),
          );
        },
      ),
    );
  }
}
