import 'dart:convert';

// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/account/model/account_model.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/data/journal/model/request_model.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/data/space/model/space_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/home/homepage.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/bloc/journal_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/currency_selector.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/constants.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/constants/offline_model.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/drop_down_menu.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/pickers/date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../data/auth/model/auth_request.dart';
import '../../../../../../data/auth/model/auth_response.dart';
import '../../../../../utilities/custom_colors.dart';
import '../../../../../utilities/font_sizes.dart';
import '../../../../../widgets/inputs/number_field.dart';
import '../../../../auth/auth_bloc/auth_bloc.dart';
import '../../../../auth/login.dart';

var sl = GetIt.instance;

class TuitionFeeRecord extends StatefulWidget {
  final PersonModel student;
  const TuitionFeeRecord({super.key, required this.student});

  @override
  State<TuitionFeeRecord> createState() => _TuitionFeeRecordState();
}

class _TuitionFeeRecordState extends State<TuitionFeeRecord> {
  Space? space;
  String defaultCurrency = 'GHS';
  // Text Editing Controllers
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var prefs = sl<SharedPreferences>();
  var preferences = sl<SharedPreferenceModule>();
  bool logout = false;

  @override
  void initState() {
    super.initState();
    space = preferences.getSpaces().first;
    defaultCurrency = space?.currency ?? 'GHS';
  }

  // final Connectivity _connectivity = Connectivity();

  AccountsModel selectedPaymentMethod = Constants.paymentMethods
      .where((element) => element.name.name == "CASH")
      .toList()[0];
  String selectedCurrency = "";
  DateTime date = DateTime.now();
  bool sendSMS = true;
  // Toggle options
  List<bool> selectedOptions = <bool>[false, false, false];

  // List<String> currencies = ['GHS', 'USD', 'NGN', 'EUR'];

  // Update Payment Method
  void updatePaymentMethod(value) {
    setState(() {
      selectedPaymentMethod = Constants.paymentMethods
          .firstWhere((element) => element.name.name == value);
    });
  }

  // Update Currency
  void updateCurrency(value) {
    setState(() {
      selectedCurrency = value;
    });
  }

  toggleSSM(bool value) {
    setState(() {
      sendSMS = value;
    });
  }

  // Update Date
  void updateDate(DateTime date) {
    setState(() {
      this.date = date;
    });
  }

  // Save Offline
  void saveOffline() {
    var prefs = sl<SharedPreferences>();
    List<OfflineModel> offlineTuitionFee = [];
    String? value = prefs.getString("offlineTuitionFee");
    var accounts = preferences.getAccounts();
    if (value != null) {
      List<dynamic> decodedValue = json.decode(value);
      offlineTuitionFee.addAll(
          decodedValue.map((model) => OfflineModel.fromJson(model)).toList());
    }
    offlineTuitionFee.add(
      OfflineModel(
        id: DateTime.now().toString(),
        title: "Tuition Fee",
        data: ReceivedMoneyJournalRequest(
          creditAccountId: accounts
              .firstWhere(
                  (element) => element.name.name == "ACCOUNTS_RECEIVABLE")
              .id,
          debitAccountId: selectedPaymentMethod.id,
          subaccountPersonId: widget.student.childRelations!.first.id,
          amount: int.parse(amountController.text),
          currency: selectedCurrency,
          reason: descriptionController.text,
          sendSMS: sendSMS,
          studentPersonId: widget.student.id,
        ),
        status: UploadStatus.initial,
      ),
    );
    prefs.setString(
      "offlineTuitionFee",
      json.encode(
        offlineTuitionFee.map((model) => model.toJson()).toList(),
      ),
    );
  }

  // Create Journal Record
  void createJournalRecord() {
    // TODO: implement createJournalRecord
    var accounts = preferences.getAccounts();
    context.read<JournalBloc>().add(
          AddNewReceivedMoneyJournalEvent([
            ReceivedMoneyJournalRequest(
              creditAccountId: accounts
                  .firstWhere(
                      (element) => element.name.name == "ACCOUNTS_RECEIVABLE")
                  .id,
              debitAccountId: selectedPaymentMethod.id,
              subaccountPersonId: widget.student.id,
              currency: selectedCurrency,
              amount: int.parse(amountController.text),
              reason: descriptionController.text,
              sendSMS: sendSMS,
              isInvoicePayment: true,
              studentPersonId: widget.student.id,
            ),
          ]),
        );
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

  // Handle State Change
  void handleStateChange(BuildContext context, JournalState state) {
    if (state.status == JournalStatus.success) {
      // Handle Success
      print(state.successMessage);
      prefs.remove("offlineTuitionFee");
      GFToast.showToast(state.successMessage, context,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          toastDuration: 5,
          toastBorderRadius: 12.0,
          backgroundColor: Colors.green.shade700);
      nextScreenAndRemoveAll(context: context, screen: const HomePage());
      setState(() {});
    }
    if (state.status == JournalStatus.error) {
      // Handle Error
      print(state.errorMessage);
      if (state.errorMessage == "Unauthorized" ||
          state.errorMessage == "Exception: Unauthorized") {
        _refreshTokens();
      } else {
        logger.f(state.errorMessage);
        GFToast.showToast(state.errorMessage!, context,
            toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
                ? GFToastPosition.TOP
                : GFToastPosition.BOTTOM,
            toastDuration: 5,
            toastBorderRadius: 12.0,
            backgroundColor: CustomColor.red);
        setState(() {});
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
      nextScreenAndRemoveAll(context: context, screen: const HomePage());
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
  Widget build(BuildContext context) {
    return BlocConsumer<JournalBloc, JournalState>(
      listener: (context, state) {
        // TODO: implement listener
        handleStateChange(context, state);
      },
      builder: (context, state) {
        logger.d(space?.toJson());
        selectedCurrency = defaultCurrency;
        return Scaffold(
          backgroundColor: Colors.green.shade50,
          appBar: AppBar(
            backgroundColor: Colors.green.shade100,
            title: Text(
              "Received money",
              style: TextStyle(
                color: SecondaryColors.secondaryGreen,
              ),
            ),
            centerTitle: true,
            actions: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  _handleRefreshStateChange(context, state);
                  _handleLogoutStateChange(context, state);
                },
                child: Container(),
              ),
              IconButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          // TODO: implement
                          if (amountController.text.isEmpty ||
                              selectedCurrency.isEmpty) {
                            GFToast.showToast("Please fill all fields", context,
                                toastPosition:
                                    MediaQuery.of(context).viewInsets.bottom !=
                                            0
                                        ? GFToastPosition.TOP
                                        : GFToastPosition.BOTTOM,
                                backgroundColor: CustomColor.red,
                                toastBorderRadius: 8.0,
                                toastDuration: 5);
                          } else {
                            // TODO: implement save
                            try {
                              // saveOffline();
                              createJournalRecord();
                            } catch (e) {
                              logger.w(e);
                            }
                          }
                        },
                  icon: const Icon(
                    Icons.check,
                  )),
            ],
          ),
          body: Form(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                const SizedBox(height: 10),
                Text(
                  "${widget.student.firstName} ${widget.student.middleName ?? ""} ${widget.student.lastName1} ${widget.student.lastName2 ?? ""}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: SecondaryColors.secondaryGreen,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Old balance: $defaultCurrency ",
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: SecondaryColors.secondaryGreen.withOpacity(0.7),
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "1000",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: SecondaryColors.secondaryGreen.withOpacity(0.7),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String? value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CurrencySelector(
                              primaryColor: Colors.green,
                              secondaryColor: SecondaryColors.secondaryGreen,
                              initialCurrency: selectedCurrency,
                            ),
                          ),
                        );
                        logger.f(value);
                        if (value != null) {
                          setState(() {
                            selectedCurrency = value;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Text(
                          selectedCurrency,
                          style: TextStyle(
                            fontSize: CustomFontSize.extraLarge,
                            // underline text
                            decoration: TextDecoration.underline,
                            color:
                                SecondaryColors.secondaryGreen.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 135,
                    //   child: CustomDropDownMenu(
                    //     color: SecondaryColors.secondaryGreen.withOpacity(0.7),
                    //     value: selectedCurrency,
                    //     options: [
                    //       "Currency",
                    //       ...currencies,
                    //     ],
                    //     onChanged: updateCurrency,
                    //   ),
                    // ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomNumberField(
                        color: SecondaryColors.secondaryGreen.withOpacity(0.7),
                        hintText: "Paid amount",
                        controller: amountController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter an amount";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text("Payment method",
                    style: TextStyle(
                      color: SecondaryColors.secondaryGreen.withOpacity(0.7),
                      fontSize: 18,
                    )),
                const SizedBox(height: 5),
                CustomDropDownMenu(
                  color: SecondaryColors.secondaryGreen.withOpacity(0.7),
                  options: [
                    "Payment method",
                    ...Constants.paymentMethods
                        .map((e) => e.name.name.split("_").join(" "))
                        .toList(),
                  ],
                  value: selectedPaymentMethod.name.name,
                  onChanged: updatePaymentMethod,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  color: SecondaryColors.secondaryGreen.withOpacity(0.7),
                  hintText: "Description (optional)",
                  controller: descriptionController,
                ),
                const SizedBox(height: 20),
                Text("Payment date",
                    style: TextStyle(
                      color: SecondaryColors.secondaryGreen.withOpacity(0.7),
                      fontSize: 18,
                    )),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    updateDate(date);
                  },
                  child: DatePicker(
                    pickerTimeLime: PickerTimeLime.past,
                    color: SecondaryColors.secondaryGreen.withOpacity(0.7),
                    bgColor: Colors.white.withOpacity(0.3),
                    date: date,
                    onSelect: updateDate,
                    pickerColor: Colors.green,
                    borderColor:
                        SecondaryColors.secondaryGreen.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 90),
                // SMS Toggle
                Row(
                  children: [
                    Text(
                      "SMS receipt",
                      style: TextStyle(
                          fontSize: 18, color: SecondaryColors.secondaryGreen),
                    ),
                    const SizedBox(width: 10),
                    Switch(
                      value: sendSMS,
                      onChanged: toggleSSM,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: FloatingActionButton.extended(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                // TODO: implement
                                if (amountController.text.isEmpty ||
                                    selectedCurrency.isEmpty) {
                                  logger.d("Please fill all fields");
                                  GFToast.showToast(
                                      "Please fill all fields", context,
                                      toastPosition: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom !=
                                              0
                                          ? GFToastPosition.TOP
                                          : GFToastPosition.BOTTOM,
                                      backgroundColor: CustomColor.red,
                                      toastBorderRadius: 8.0,
                                      toastDuration: 5);
                                } else {
                                  // TODO: implement save
                                  createJournalRecord();
                                  // try {
                                  //   // saveOffline();
                                  // } catch (e) {
                                  //   logger.w(e);
                                  // }
                                }
                              },
                        backgroundColor: Colors.green.shade300,
                        label: SizedBox(
                          width: 80,
                          child: Center(
                            child: state.isLoading
                                ? CircularProgressIndicator(
                                    color: SecondaryColors.secondaryGreen,
                                  )
                                : Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: CustomFontSize.large,
                                      color: SecondaryColors.secondaryGreen,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
