import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/journal/model/journal_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/bloc/person_bloc.dart';
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
  List<RecipientModel> recipientOptions = [];
  List<RecipientModel> selectedRecipients = [];
  List<RecipientModel> searchResults = [];
  List<RecipientModel> parents = [];
  bool showResults = false;
  List<bool> isSelected = [true, false];

  String selectedOption = 'Option 1'; // Initialize the selected option

  // Toggle Forms
  void toggleForm(int index) {
    setState(() {
      for (var i = 0; i < isSelected.length; i++) {
        if (i == index) {
          isSelected[i] = true;
        } else {
          isSelected[i] = false;
        }
      }
    });
  }

  // Get All Parents
  void _getParents() {
    context.read<PersonBloc>().add(const GetAllPersonEvent());
  }

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

  // Set Selected Students
  void _onSelected(bool selected, RecipientModel dataName) {
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
        searchResults = recipientOptions
            .toSet()
            .toList()
            .where(
              (recipient) =>
                  (recipient.companyName ?? "").toLowerCase().contains(query) ||
                  (recipient.firstName ?? "").toLowerCase().contains(query) ||
                  (recipient.lastName ?? "").toLowerCase().contains(query),
            )
            .toList();
        searchResults.addAll(parents.toSet().toList().where((recipient) =>
            (recipient.firstName ?? "").toLowerCase().contains(query) ||
            (recipient.lastName ?? "").toLowerCase().contains(query)));
      });
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
        if (!parents.contains(person)) {
          parents.add(RecipientModel(
            id: person.id,
            firstName: person.firstName,
            lastName: person.lastName1,
            role: person.role == Role.Relative.name
                ? "parent"
                : person.role.name.toLowerCase(),
            isPerson: true,
          ));
        } else {
          parents.remove(RecipientModel(
            id: person.id,
            isPerson: true,
            firstName: person.firstName,
            lastName: person.lastName1,
            role: person.role == Role.Relative.name
                ? "parent"
                : person.role.name.toLowerCase(),
          ));
        }
      }
      var offlineStudentList = json.encode(parents);
      preferences.setString("recipientsParents", offlineStudentList);
    }
    if (state.status == PersonStatus.error) {
      logger.e(state.errorMessage);
      if (state.errorMessage == "Invalid refresh token." ||
          state.errorMessage == "Exception: Invalid refresh token.") {
        _refreshTokens();
      } else {
        GFToast.showToast(
          state.errorMessage,
          context,
          toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
          toastBorderRadius: 8.0,
          backgroundColor: CustomColor.red,
          toastDuration: 5,
        );
      }
    }
  }

  // Handle Refresh State Change
  void _handleRefreshStateChange(BuildContext context, AuthState state) {
    if (state.refreshFailure == null) {
      // Handle Success
      _getParents();
    }
    if (state.refreshFailure != null) {
      logger.e(state.refreshFailure);
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
        decodedValue.map((model) => RecipientModel.fromJson(model)).toList(),
      );
    }
    if (valueParents != null) {
      List<dynamic> decodedValue = json.decode(valueParents);
      parents.addAll(
        decodedValue.map((model) => RecipientModel.fromJson(model)).toList(),
      );
    }
    _getParents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addRecipient() async {
      RecipientModel? recipient = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddNewRecipient(),
        ),
      );
      if (recipient != null) {
        setState(() {
          recipientOptions.add(recipient);
        });
      }
    }

    navigate(
      BuildContext context,
      JournalState state,
      RecipientModel recipient,
    ) {
      var paymentRequest = JournalModel(
        recipientFirstName: recipient.firstName,
        recipientLastName: recipient.lastName,
        companyName: recipient.companyName,
        recipientRole: recipient.role,
        supplier: recipient.supplier,
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
        personId: recipient.id
      );
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
                                  leading: iconSelector(recipient.isPerson),
                                  title: Text(
                                    recipient.companyName ??
                                        "${recipient.firstName} ${recipient.lastName} (${recipient.role?.toLowerCase()})",
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
                            ],
                          ),
                        )
                  : Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ...recipientOptions.map(
                            (recipient) => ListTile(
                              onTap: () {
                                navigate(context, state, recipient);
                              },
                              leading: iconSelector(recipient.isPerson),
                              title: Text(
                                recipient.companyName ??
                                    "${recipient.firstName} ${recipient.lastName}",
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
                            ),
                          ),
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
                                  color: SecondaryColors.secondaryRed.withOpacity(0.7)),
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
