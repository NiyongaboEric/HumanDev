import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/account/api/account_api.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_request.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_response.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/data/groups/model/group_model.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/paid_money/log_payment.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/custom_colors.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/group_drop_down.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../data/constants/logger.dart';
import '../../../../../data/journal/model/journal_model.dart';
import '../../../../../data/person/model/person_request.dart';
import '../../../../utilities/colors.dart';
import '../../../../utilities/custom_colors.dart';
import '../../../../utilities/navigation.dart';
import '../../../../widgets/constants/recipients_model.dart';
import '../../../../widgets/inputs/drop_down_menu.dart';
import '../../../auth/login.dart';
import '../../person/bloc/person_bloc.dart';
import '../bloc/journal_bloc.dart';

var sl = GetIt.instance;

class AddNewRecipient extends StatefulWidget {
  const AddNewRecipient({super.key});

  @override
  State<AddNewRecipient> createState() => _AddNewRecipientState();
}

class _AddNewRecipientState extends State<AddNewRecipient> {
  var prefs = sl<SharedPreferences>();
  var preferences = sl<SharedPreferenceModule>();

  List<bool> isSelected = [true, false];

  // Form Keys
  final _personFormKey = GlobalKey<FormState>();
  final _companyFormKey = GlobalKey<FormState>();

  final recipientFirstNameController = TextEditingController();
  final recipientLastNameController = TextEditingController();
  String role = "";
  // List<String> roleOptions = ["Student", "Parent"];
  final companyNameController = TextEditingController();
  String supplier = "";
  List<String> supplierOptions = ["Retail", "WholeSale"];
  List<Group> groupSpace = [];
  bool logout = false;

  String currentSelectedGroupSpace = 'Student';
  bool formHasErrors = false;
  // String allGroups = 'Role';
  // Text textErrors = const Text('Remember to fill details person and company section');

  @override
  void initState() {
    String? groupValue = prefs.getString("groups");
    if (groupValue != null) {
      List<dynamic> groupData = json.decode(groupValue);
      try {
        List<Group> groupList = groupData.map((data) {
          return Group.fromJson(data);
        }).toList();
        logger.d(groupList);

        // Attach all groups as a default in group space
        groupSpace = [
          // Group.fromJson({
          //   "id": 0,
          //   "name": allGroups,
          //   "isRole": false,
          //   "isActive": false,
          //   "spaceId": 00,
          // }),
          ...groupList
        ];
      } catch (e) {
        logger.f(groupData);
        logger.w(e);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    recipientFirstNameController.dispose();
    recipientLastNameController.dispose();
    companyNameController.dispose();
  }

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

  // Update Role
  void updateRole(value) {
    setState(() {
      // role = value;
      currentSelectedGroupSpace = value;
    });
  }

  // Update Supplier
  void updateSupplier(value) {
    setState(() {
      supplier = value;
    });
  }

  // Create Person
  void _createPerson() {
    BlocProvider.of<PersonBloc>(context).add(AddPersonEvent(PersonRequest(
      firstName: recipientFirstNameController.text.isNotEmpty
          ? recipientFirstNameController.text
          : null,
      lastName1: recipientLastNameController.text.isNotEmpty
          ? recipientLastNameController.text
          : null,
      organizationName: companyNameController.text.isNotEmpty
          ? companyNameController.text
          : null,
      isLegal: isSelected[1],
      groupIds: isSelected[0]
          ? groupSpace
              .where((element) => element.name == currentSelectedGroupSpace)
              .map((e) => e.id!)
              .toList()
          : [
              groupSpace.firstWhere((element) => element.name == "Supplier").id!
            ],
    )));
  }

  // Refresh Tokens
  void _refreshTokens() async {
    TokenResponse? token = preferences.getToken();
    if (token != null) {
      BlocProvider.of<AuthBloc>(context).add(AuthEventRefresh(RefreshRequest(
        refresh: token.refreshToken,
      )));
    }
  }

  // Logout
  void _logout() async {
    context.read<AuthBloc>().add(AuthEventLogout());
  }

  // Handle Person Change State
  void _handlePersonStateChange(BuildContext context, PersonState state) {
    if (state.status == PersonStatus.createSuccess) {
      // Handle Success
      Navigator.pop(context, state.personResponse);
    }
    if (state.status == PersonStatus.error) {
      logger.e(state.errorMessage);
      if (state.errorMessage == "Unauthorized" ||
          state.errorMessage == "Exception: Unauthorized") {
        _refreshTokens();
      }
    }
  }

  // navigate(
  //   BuildContext context,
  //   PersonModel recipient,
  // ) async {
  //   print('AddNewRecipient - navigate()...');
  //   JournalState state = context.read<JournalBloc>().state;
  //   state.copyWith(
  //     recipient: recipient,
  //   );
  //   var paymentRequest = JournalModel(
  //       recipientFirstName: recipient.firstName,
  //       recipientLastName: recipient.lastName1,
  //       companyName: recipient.organizationName,
  //       recipientRole: recipient.role,
  //       // supplier: recipient.supplier,
  //       tags: state.journalData?.tags,
  //       amount: state.journalData?.amount,
  //       accountantId: state.journalData?.accountantId,
  //       recipientId: recipient.id,
  //       createdAt: state.journalData?.createdAt,
  //       updatedAt: state.journalData?.updatedAt,
  //       currency: state.journalData?.currency,
  //       description: state.journalData?.description,
  //       // images: state.journalData?.images,
  //       spaceId: state.journalData?.spaceId,
  //       id: state.journalData?.id,
  //       creditAccountId: state.journalData?.creditAccountId,
  //       debitAccountId: state.journalData?.debitAccountId,
  //       personId: recipient.id);
  //   try {
  //     context.read<JournalBloc>().add(
  //           SaveDataJournalState(paymentRequest),
  //         );
  //     nextScreenAndReplace(context: context, screen: LogPayment());
  //   } catch (e) {
  //     logger.e(e);
  //   }
  // }

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

  // Person Form
  Widget _buildPersonForm(PersonState state) {
    return Form(
      key: _personFormKey,
      // key: _personCompanyFormKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          CustomTextField(
            color: SecondaryColors.secondaryRed,
            hintText: "First Name",
            controller: recipientFirstNameController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^[A-Za-z][A-Za-z0-9\s\S]*$')),
            ],
            validator: (val) {
              if (val!.isEmpty) {
                return "Please enter a first name";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
              color: SecondaryColors.secondaryRed,
              hintText: "Last Name",
              controller: recipientLastNameController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^[A-Za-z][A-Za-z0-9\s\S]*$')),
              ],
              validator: (val) {
                if (val!.isEmpty) {
                  return "Please enter a last name";
                }
                return null;
              }),
          const SizedBox(height: 20),
          CustomDropDownMenu(
            color: SecondaryColors.secondaryRed,
            options: [
              "Select group",
              ...groupSpace
                  .where((element) =>
                      element.isRole! && element.name != "Supplier")
                  .map((group) {
                return group.name;
              }).toList(),
            ],
            value: currentSelectedGroupSpace,
            onChanged: updateRole,
          ),
          // GroupDropdownMenu(
          //   groupSpace: groupSpace,
          //   handleChangeDropdownItem: updateRole,
          //   btnstyle: const ButtonStyle(
          //     foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          //   ),
          //   inputDecorationTheme: InputDecorationTheme(
          //     enabledBorder: OutlineInputBorder(
          //       gapPadding: 0,
          //       borderRadius: BorderRadius.circular(10),
          //       borderSide: BorderSide(
          //         color: SecondaryColors.secondaryRed,
          //         width: 1,
          //       ),
          //     ),
          //   ),
          //   leadingIcon: Icon(Icons.filter_list_alt,
          //       color: SMSRecipientColors.primaryColor),
          //   menuStyle: const MenuStyle(
          //     backgroundColor: MaterialStatePropertyAll<Color>(
          //         Color.fromARGB(255, 255, 255, 255)),
          //   ),
          // ),
          // formHasErrors ? textErrors : Container(),
          const SizedBox(height: 75),
          Row(
            children: [
              Expanded(
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.red.shade100,
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (_personFormKey.currentState!.validate() &&
                              currentSelectedGroupSpace.isNotEmpty) {
                            formHasErrors = false;
                            _createPerson();
                          } else {
                            setState(() {
                              formHasErrors = true;
                            });
                          }
                        },
                  label: !state.isLoading
                      ? Text(
                          "Add recipient",
                          style: TextStyle(
                            color: SecondaryColors.secondaryRed,
                            fontSize: CustomFontSize.medium,
                          ),
                        )
                      : CircularProgressIndicator(
                          color: SecondaryColors.secondaryRed,
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCompanyForm(PersonState state) {
    return Form(
      key: _companyFormKey,
      // key: _personCompanyFormKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          CustomTextField(
            color: SecondaryColors.secondaryRed,
            hintText: "Company Name",
            controller: companyNameController,
            validator: (val) {
              if (val!.isEmpty) {
                return "Please enter a company name";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // CustomDropDownMenu(
          //   color: SecondaryColors.secondaryRed,
          //   options: ["Supplier", ...supplierOptions],
          //   onChanged: updateSupplier,
          //   value: "Supplier",
          // ),
          // formHasErrors ? textErrors : Container(),
          const SizedBox(height: 75),
          Row(
            children: [
              Expanded(
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.red.shade100,
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (_companyFormKey.currentState!.validate()
                              // &&
                              //   currentSelectedGroupSpace.isNotEmpty &&
                              //   recipientFirstNameController.text.isNotEmpty &&
                              //   recipientLastNameController.text.isNotEmpty
                              ) {
                            formHasErrors = false;
                            _createPerson();
                          } else {
                            setState(() {
                              formHasErrors = true;
                            });
                          }
                        },
                  label: !state.isLoading
                      ? Text(
                          "Add recipient",
                          style: TextStyle(
                            color: SecondaryColors.secondaryRed,
                            fontSize: CustomFontSize.medium,
                          ),
                        )
                      : CircularProgressIndicator(
                          color: SecondaryColors.secondaryRed,
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> recipientType = [
      SizedBox(
          width: (MediaQuery.of(context).size.width - 30) / 2,
          child: const Center(
            child: Text("Person",
                style: TextStyle(fontSize: CustomFontSize.medium)),
          )),
      SizedBox(
        width: (MediaQuery.of(context).size.width - 30) / 2,
        child: const Center(
          child: Text(
            "Company",
            style: TextStyle(fontSize: CustomFontSize.medium),
          ),
        ),
      ),
    ];
    return BlocConsumer<PersonBloc, PersonState>(
      listener: (context, state) {
        // TODO: implement listener
        _handlePersonStateChange(context, state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.red.shade50,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: SecondaryColors.secondaryRed,
            ),
            title: Text(
              "Add new recipient",
              style: TextStyle(
                color: SecondaryColors.secondaryRed,
              ),
            ),
            backgroundColor: Colors.red.shade100,
            centerTitle: true,
            actions: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  _handleRefreshStateChange(context, state);
                  _handleLogoutStateChange(context, state);
                },
                child: Container(),
              )
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              const SizedBox(height: 30),
              ToggleButtons(
                isSelected: isSelected,
                onPressed: toggleForm,
                fillColor: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                selectedBorderColor: Colors.red.shade200,
                selectedColor: SecondaryColors.secondaryRed,
                children: recipientType,
              ),
              const SizedBox(height: 20),
              isSelected[0] ? _buildPersonForm(state) : _buildCompanyForm(state)
            ],
          ),
        );
      },
    );
  }
}
