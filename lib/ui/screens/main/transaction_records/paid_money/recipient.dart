import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pinput/pinput.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/journal/model/journal_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/bloc/person_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/parent.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/bloc/journal_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/constants/recipients_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../data/auth/model/auth_request.dart';
import '../../../../../data/auth/model/auth_response.dart';
import '../../../../../data/constants/shared_prefs.dart';
import '../../../../../data/person/model/person_model.dart';
import '../../../../utilities/custom_colors.dart';
import '../../../../utilities/navigation.dart';
import '../../../../widgets/inputs/text_field.dart';
import '../../../auth/auth_bloc/auth_bloc.dart';
import '../../../auth/login.dart';
import 'add_new_recipient.dart';
import 'log_payment.dart';

var sl = GetIt.instance;

class Recipient extends StatefulWidget {
  const Recipient({super.key});

  @override
  State<Recipient> createState() => _RecipientState();
}

class _RecipientState extends State<Recipient> {
  TextEditingController searchController = TextEditingController();
  TextEditingController recipientNameController = TextEditingController();
  var preferences = sl<SharedPreferences>();
  var prefs = sl<SharedPreferences>();
  var prefsModule = sl<SharedPreferenceModule>();
  List<PersonModel> recipientOptions = [];
  List<PersonModel> selectedRecipients = [];
  List<PersonModel> searchResults = [];
  List<PersonModel> parents = [];
  List<PersonModel> allPeople = [];
  List<PersonModel> searchResultsAllPeople = [];
  // List<PersonModel> recipientOptionsAllPeople = [];
  bool showResultsAllPeople = false;
  bool showResults = false;
  List<bool> isSelected = [true, false];
  bool isCurrentPage = false;
  bool logout = false;

  String selectedOption = 'Option 1'; // Initialize the selected option

  // Toggle Forms
  // void toggleForm(int index) {
  //   setState(() {
  //     for (var i = 0; i < isSelected.length; i++) {
  //       if (i == index) {
  //         isSelected[i] = true;
  //       } else {
  //         isSelected[i] = false;
  //       }
  //     }
  //   });
  // }

  // Get All Parents
  void _getParents() {
    context.read<PersonBloc>().add(const GetAllPersonEvent());
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
        selectedRecipients.add(dataName);
      });
    } else {
      setState(() {
        selectedRecipients.remove(dataName);
      });
    }
  }

  search(String query) {
    // Search for recipient options and also parents
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        showResults = false;
      });
    } else {
      setState(() {
        showResults = true;
        searchResults = allPeople
            .where(
              (recipient) =>
                  (recipient.organizationName ?? "")
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  (recipient.firstName ?? "")
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  (recipient.lastName1 ?? "")
                      .toLowerCase()
                      .contains(query.toLowerCase()),
            )
            .toList();
        // searchResults.addAll(parents.toSet().toList().where((recipient) =>
        //     (recipient.firstName ?? "").toLowerCase().contains(query.toLowerCase()) ||
        //     (recipient.lastName ?? "").toLowerCase().contains(query.toLowerCase())));
      });
      logger.i(recipientOptions);
    }
  }

  Widget iconSelector(bool isPerson) {
    if (isPerson) {
      return Icon(
        Icons.person,
        color: SecondaryColors.secondaryRed,
      );
    } else {
      return Icon(
        Icons.business,
        color: SecondaryColors.secondaryRed,
      );
    }
  }

  // Handle Paid Money State Change
  void _handleJournalStateChange(BuildContext context, JournalState state) {
    if (state.status == JournalStatus.success) {
      nextScreen(context: context, screen: const LogPayment());
    }
    if (state.status == JournalStatus.error) {
      logger.e(state.errorMessage);
    }
  }

  // Handle Parents State Change
  void _handleParentsStateChange(BuildContext context, PersonState state) {
    if (state.status == PersonStatus.success) {
      setState(() {
        parents.clear();
      });
      // Handle Success
      for (var person in state.persons) {
        allPeople.add(person);
        // if (!parents.contains(person)) {
        //   parents.add(RecipientModel(
        //     id: person.id,
        //     firstName: person.firstName,
        //     lastName: person.lastName1,
        //     role: person.role == Role.Relative.name
        //         ? "parent"
        //         : person.role!.toLowerCase(),
        //     isPerson: true,
        //   ));
        // } else {
        //   parents.remove(RecipientModel(
        //     id: person.id,
        //     isPerson: true,
        //     firstName: person.firstName,
        //     lastName: person.lastName1,
        //     role: person.role == Role.Relative.name
        //         ? "parent"
        //         : person.role!.toLowerCase(),
        //   ));
        // }
      }
      // var offlineStudentList = json.encode(parents);
      // preferences.setString("recipientsParents", offlineStudentList);
    }
    if (state.status == PersonStatus.error) {
      logger.e(state.errorMessage);
      if (state.errorMessage == "Invalid refresh token." ||
          state.errorMessage == "Exception: Invalid refresh token." ||
          state.errorMessage == "Exception: Unauthorized") {
        _refreshTokens();
      } else {
        GFToast.showToast(
          state.errorMessage,
          context,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          toastBorderRadius: 8.0,
          backgroundColor: CustomColor.red,
          toastDuration: 5,
        );
      }
    }
  }

  // Handle Get User Data State Change
  void _handleRefreshStateChange(BuildContext context, AuthState state) {
    // var prefs = sl<SharedPreferenceModule>();
    if (logout) {
      return;
    }
    if (state.status == AuthStateStatus.authenticated) {
      // navigate(context, state);
      if (state.refreshFailure != null) {
        GFToast.showToast(
          state.refreshFailure,
          context,
          toastBorderRadius: 8.0,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
        );
      }
    }
    if (state.status == AuthStateStatus.unauthenticated) {
      print("Error...: ${state.refreshFailure}");
      if (state.refreshFailure != null &&
          state.refreshFailure!.contains("Invalid refresh token")) {
        logger.w("Invalid refresh token");
        setState(() {
          logout = true;
        });
        _logout();
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
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    var value = prefs.getString("recipients");
    var valueParents = prefs.getString("recipientsParents");
    if (value != null) {
      List<dynamic> decodedValue = json.decode(value);
      recipientOptions.addAll(
        decodedValue.map((model) => PersonModel.fromJson(model)).toList(),
      );
    }
    if (valueParents != null) {
      List<dynamic> decodedValue = json.decode(valueParents);
      parents.addAll(
        decodedValue.map((model) => PersonModel.fromJson(model)).toList(),
      );
    }
    _getParents();
    super.initState();
  }

  addRecipient() async {
    PersonModel? recipient = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewRecipient(),
      ),
    );
    logger.i(recipient?.toJson());
    if (recipient == null) return;
    int index = allPeople.indexWhere((element) => element.id == recipient.id);
    if (index != -1) {
      logger.wtf("Exists");
      allPeople[index] = recipient;
      return;
    } else {
      logger.i("Does not exist");
      allPeople.add(recipient);
      setState(() {});
    }

    // if (refresh != null && refresh) {
    //   await Future.delayed(const Duration(seconds: 1));
    //   _getParents();
    // }
  }

  navigate(
    BuildContext context,
    JournalState state,
    PersonModel recipient,
  ) {
    var paymentRequest = JournalModel(
        recipientFirstName: recipient.firstName,
        recipientLastName: recipient.lastName1,
        companyName: recipient.organizationName,
        recipientRole: recipient.role,
        // supplier: recipient.supplier,
        tags: state.journalData?.tags,
        amount: state.journalData?.amount,
        accountantId: state.journalData?.accountantId,
        recipientId: recipient.id,
        createdAt: state.journalData?.createdAt,
        updatedAt: state.journalData?.updatedAt,
        currency: state.journalData?.currency,
        description: state.journalData?.description,
        // images: state.journalData?.images,
        spaceId: state.journalData?.spaceId,
        id: state.journalData?.id,
        creditAccountId: state.journalData?.creditAccountId,
        debitAccountId: state.journalData?.debitAccountId,
        personId: recipient.id);
    try {
      var recipients = json.encode(recipientOptions);
      prefs.setString("recipients", recipients);
      context.read<JournalBloc>().add(
            SaveDataJournalState(paymentRequest),
          );
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort All People Alphabetically by First Name and also Company Name
    allPeople.sort((a, b) {
      return a.isLegal && b.isLegal
          ? a.organizationName!.compareTo(b.organizationName!)
          : a.firstName.compareTo(b.firstName);
    });
    // Sort Search Results Alphabetically
    searchResults.sort((a, b) {
      return a.firstName.compareTo(b.firstName);
    });
    return BlocConsumer<JournalBloc, JournalState>(
      listener: (context, state) {
        // TODO: implement listener
        _handleJournalStateChange(context, state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.red.shade50,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: SecondaryColors.secondaryRed,
            ),
            backgroundColor: Colors.red.shade100,
            title: Text("Recipient",
                style: TextStyle(
                  color: SecondaryColors.secondaryRed,
                )),
            centerTitle: true,
            actions: [
              BlocListener<PersonBloc, PersonState>(
                listener: (context, state) {
                  // TODO: implement listener
                  _handleParentsStateChange(context, state);
                },
                child: Container(),
              ),
              // Refresh BLoc Listener
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  _handleRefreshStateChange(context, state);
                  _handleLogoutStateChange(context, state);
                },
                child: Container(),
              ),
              IconButton(
                onPressed: addRecipient,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: SecondaryColors.secondaryRed,
                        ),
                        color: SecondaryColors.secondaryRed,
                        hintText: "Search...",
                        controller: searchController,
                        onChanged: search,
                      ),
                    ),
                  ],
                ),
              ),
              showResults
                  ? searchResults.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              "No results found",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: SecondaryColors.secondaryRed,
                                fontSize: CustomFontSize.medium,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              ...searchResults.map(
                                (recipient) => ListTile(
                                  onTap: () {
                                    navigate(context, state, recipient);
                                  },
                                  leading: iconSelector(!recipient.isLegal),
                                  title: Text(
                                    recipient.organizationName ??
                                        "${recipient.firstName} ${recipient.lastName1} (${recipient.role?.toLowerCase() ?? "--"})",
                                    style: TextStyle(
                                      fontSize: CustomFontSize.large,
                                      color: SecondaryColors.secondaryRed,
                                    ),
                                  ),
                                  // trailing: IconButton(
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       searchResults.remove(recipient);
                                  //     });
                                  //   },
                                  //   icon: Icon(Icons.clear),
                                  // ),
                                ),
                              ),

                              // ...searchResultsAllPeople.map(
                              //   (recipient) => ListTile(
                              //     onTap: () {
                              //       navigate(context, state, RecipientModel(
                              //       id: recipient.id,
                              //       firstName: recipient.firstName,
                              //       lastName: recipient.lastName1,
                              //       isPerson: true,
                              //     ));
                              //     },
                              //     leading: iconSelector(true),
                              //     title: Text(
                              //       "${recipient.firstName} ${recipient.lastName1} (${recipient.role?.toLowerCase()})",
                              //       style: TextStyle(
                              //         fontSize: CustomFontSize.large,
                              //         color: SecondaryColors.secondaryRed,
                              //       ),
                              //     ),
                              //     // trailing: IconButton(
                              //     //   onPressed: () {
                              //     //     setState(() {
                              //     //       searchResults.remove(recipient);
                              //     //     });
                              //     //   },
                              //     //   icon: Icon(Icons.clear),
                              //     // ),
                              //   ),
                              // ),
                            ],
                          ),
                        )
                  : Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          // arrange in alphabetical order first then numbers
                          ...allPeople.map((recipient) => ListTile(
                                onTap: () {
                                  navigate(context, state, recipient);
                                },
                                leading: iconSelector(!recipient.isLegal),
                                title: Text(
                                  recipient.organizationName ??
                                      "${recipient.firstName} ${recipient.lastName1}",
                                  style: TextStyle(
                                    fontSize: CustomFontSize.large,
                                    color: SecondaryColors.secondaryRed,
                                  ),
                                ),
                                // trailing: IconButton(
                                //     onPressed: () {
                                //       setState(() {
                                //         recipientOptions.remove(recipient);
                                //       });
                                //     },
                                //     icon: Icon(Icons.clear)),
                              )),
                          // ...allPeople.map((recipient) {
                          //   return ListTile(
                          //     onTap: () {
                          //       navigate(
                          //           context,
                          //           state,
                          //           RecipientModel(
                          //             id: recipient.id,
                          //             firstName: recipient.firstName,
                          //             lastName: recipient.lastName1,
                          //             isPerson: true,
                          //           ));
                          //     },
                          //     leading: iconSelector(true),
                          //     title: Text(
                          //       "${recipient.firstName} ${recipient.lastName1}",
                          //       style: TextStyle(
                          //         fontSize: CustomFontSize.large,
                          //         color: SecondaryColors.secondaryRed,
                          //       ),
                          //     ),
                          //     // trailing: IconButton(
                          //     //     onPressed: () {
                          //     //       setState(() {
                          //     //         recipientOptions.remove(recipient);
                          //     //       });
                          //     //     },
                          //     //     icon: Icon(Icons.clear)),
                          //   );
                          // }),
                          ListTile(
                            onTap: addRecipient,
                            leading: Icon(
                              Icons.add_circle_outline_rounded,
                              color: SecondaryColors.secondaryRed,
                            ),
                            title: Text(
                              "Add new recipient",
                              style: TextStyle(
                                  fontSize: CustomFontSize.large,
                                  color: SecondaryColors.secondaryRed
                                      .withOpacity(0.7)),
                            ),
                          )
                        ],
                      ),
                    )
            ],
          ),
        );
      },
    );
  }
}
