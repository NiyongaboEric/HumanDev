import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/journal/model/journal_model.dart';
import 'package:seymo_pay_mobile_application/data/tags/model/tag_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/home/homepage.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/bloc/journal_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/constants.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/number_field.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/pickers/date_picker.dart';

import '../../../../../data/account/model/account_model.dart';
import '../../../../../data/constants/logger.dart';
import '../../../../../data/constants/shared_prefs.dart';
import '../../../../../data/journal/model/request_model.dart';
import '../../../../utilities/custom_colors.dart';
import '../../../../widgets/inputs/drop_down_menu.dart';
import '../../../auth/auth_bloc/auth_bloc.dart';
import '../../../auth/login.dart';

var sl = GetIt.instance;

class LogPayment extends StatefulWidget {
  const LogPayment({super.key});

  @override
  State<LogPayment> createState() => _LogPaymentState();
}

class _LogPaymentState extends State<LogPayment> {
  // Text Editing Controller
  TextEditingController amountController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  String selectedCurrency = 'GHS';
  DateTime date = DateTime.now();
  var preferences = sl<SharedPreferenceModule>();
  bool logout = false;

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

  // Payment Method Buttons

  // Selected Payment Method
  AccountsModel selectedPaymentMethod = Constants.paymentMethods
      .where((element) => element.name.name == "CASH")
      .toList()[0];

  // Selected Options
  List<bool> selectedOptions = [false, false, false, false];

  // create journal record
  void _createJournalRecord(JournalModel journalData) {
    var accounts = preferences.getAccounts();
    logger.i(journalData.personId);
    context.read<JournalBloc>().add(
          AddNewPaidMoneyJournalEvent([
            PaidMoneyJournalRequest(
              creditAccountId: accounts
                  .firstWhere(
                      (element) => element.name.name == "ACCOUNTS_RECEIVABLE")
                  .id,
              debitAccountId: selectedPaymentMethod.id,
              subaccountPersonId: journalData.personId!,
              amount: int.parse(amountController.text),
              currency: selectedCurrency,
              reason: journalData.description,
              tags: journalData.tags!.isNotEmpty
                  ? journalData.tags!
                      .map((tag) => TagModel(name: tag.name))
                      .toList()
                  : null,
            ),
          ]),
        );
  }

  // Logout
  void _logout() {
    context.read<AuthBloc>().add(AuthEventLogout());
  }

  // Handle Journal State Change
  void _handleJournalStateChange(BuildContext context, JournalState state) {
    if (state.status == JournalStatus.success) {
      GFToast.showToast(
        state.successMessage,
        context,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        toastDuration: 5,
        toastBorderRadius: 12.0,
        backgroundColor: Colors.green.shade700,
      );
      nextScreenAndRemoveAll(context: context, screen: const HomePage());
    }
    if (state.status == JournalStatus.error) {
      logger.e(state.errorMessage);
      GFToast.showToast(
        state.errorMessage,
        context,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        toastDuration: 5,
        toastBorderRadius: 12.0,
        backgroundColor: CustomColor.red,
      );
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

  // Update Date
  updateDate(DateTime date) {
    setState(() {
      this.date = date;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text("Paid money",
                style: TextStyle(
                  color: SecondaryColors.secondaryRed,
                )),
            centerTitle: true,
            backgroundColor: Colors.red.shade100,
            actions: [
              IconButton(
                  onPressed: () {
                    if (amountController.text.isEmpty) {
                      GFToast.showToast(
                        "Please enter an amount",
                        context,
                        toastPosition:
                            MediaQuery.of(context).viewInsets.bottom != 0
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
                        toastBorderRadius: 12.0,
                        toastDuration: 5,
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                    _createJournalRecord(state.journalData!);
                    // nextScreenAndRemoveAll(
                    //     context: context, screen: HomePage());
                  },
                  icon: const Icon(Icons.check)),
            ],
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.red.shade100,
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (amountController.text.isEmpty) {
                            GFToast.showToast(
                              "Please enter an amount",
                              context,
                              toastPosition:
                                  MediaQuery.of(context).viewInsets.bottom != 0
                                      ? GFToastPosition.TOP
                                      : GFToastPosition.BOTTOM,
                              toastBorderRadius: 12.0,
                              toastDuration: 5,
                              backgroundColor: Colors.red,
                            );
                            return;
                          }
                          _createJournalRecord(state.journalData!);
                          // nextScreenAndRemoveAll(
                          //     context: context, screen: HomePage());
                        },
                  label: SizedBox(
                    width: 80,
                    child: Center(
                      child: !state.isLoading
                          ? const Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: CustomFontSize.large,
                                  color: Color(0xff410002)),
                            )
                          : CircularProgressIndicator(
                              color: SecondaryColors.secondaryRed,
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Recipient:",
                    style: TextStyle(
                      fontSize: 18,
                      color: SecondaryColors.secondaryRed.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    state.journalData?.companyName ??
                        "${state.journalData?.recipientFirstName} ${state.journalData?.recipientLastName}",
                    style: TextStyle(
                      fontSize: CustomFontSize.medium,
                      fontWeight: FontWeight.w500,
                      color: SecondaryColors.secondaryRed,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Description:",
                    style: TextStyle(
                      fontSize: 18,
                      color: SecondaryColors.secondaryRed.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    state.journalData?.description ?? "",
                    style: TextStyle(
                      fontSize: CustomFontSize.medium,
                      fontWeight: FontWeight.w500,
                      color: SecondaryColors.secondaryRed,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Tags:",
                    style: TextStyle(
                      fontSize: 18,
                      color: SecondaryColors.secondaryRed.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      state.journalData?.tags?.map((e) => e.name).join("; ") ??
                          "",
                      style: TextStyle(
                        fontSize: CustomFontSize.medium,
                        fontWeight: FontWeight.w500,
                        color: SecondaryColors.secondaryRed,
                      ),
                      overflow: TextOverflow.ellipsis, // Add this line
                      maxLines:
                          1, // You can adjust the max number of lines before ellipsis
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "GHS",
                      style: TextStyle(
                        fontSize: CustomFontSize.extraLarge,
                        color: SecondaryColors.secondaryRed.withOpacity(0.7),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 135,
                  //   child: CustomDropDownMenu(
                  //         color: SecondaryColors.secondaryRed.withOpacity(0.7),
                  //         value: selectedCurrency,
                  //         options: [
                  //           "Currency",
                  //           ...currencies,
                  //         ],
                  //         onChanged: updateCurrency,
                  //       ),
                  // ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomNumberField(
                      color: SecondaryColors.secondaryRed,
                      hintText: "Amount",
                      controller: amountController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Payment date",
                style: TextStyle(
                  fontSize: 18,
                  color: SecondaryColors.secondaryRed.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 5),
              DatePicker(
                pickerTimeLime: PickerTimeLime.past,
                pickerColor: Colors.red,
                bgColor: Colors.white.withOpacity(0.3),
                borderColor: SecondaryColors.secondaryRed,
                date: date,
                onSelect: updateDate,
              ),
              const SizedBox(height: 40),
              Text(
                "Payment method",
                style: TextStyle(
                  fontSize: 18,
                  color: SecondaryColors.secondaryRed.withOpacity(0.7),
                ),
              ),
              CustomDropDownMenu(
                color: const Color(0xff410002),
                options: [
                  "Payment method",
                  ...Constants.paymentMethods.map((e) => e.name.name)
                ],
                value: selectedPaymentMethod.name.name,
                onChanged: updatePaymentMethod,
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
