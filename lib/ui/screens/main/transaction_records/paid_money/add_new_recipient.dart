import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seymo_pay_mobile_application/data/account/api/account_api.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/data/groups/model/group_model.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/group_drop_down.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../data/constants/logger.dart';
import '../../../../../data/person/model/person_request.dart';
import '../../../../utilities/colors.dart';
import '../../../../widgets/constants/recipients_model.dart';
import '../../../../widgets/inputs/drop_down_menu.dart';
import '../../person/bloc/person_bloc.dart';

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
      firstName: recipientLastNameController.text.isNotEmpty
          ? recipientLastNameController.text
          : null,
      lastName1: recipientLastNameController.text.isNotEmpty
          ? recipientLastNameController.text
          : null,
      organizationName: companyNameController.text.isNotEmpty
          ? companyNameController.text
          : null,
      isLegal: isSelected[1],
    )));
  }

  // Handle Person Change State
  void _handlePersonStateChange(BuildContext context, PersonState state) {
    if (state.status == PersonStatus.success) {
      // Handle Success
      if (isSelected[0]) {
        Navigator.pop(
          context,
          RecipientModel(
            id: state.personResponse?.id,
            firstName: recipientFirstNameController.text,
            lastName: recipientLastNameController.text,
            role: role.isNotEmpty ? role : null,
            isPerson: true,
          ),
        );
      } else if (isSelected[1]) {
        Navigator.pop(
          context,
          RecipientModel(
            id: state.personResponse?.id,
            companyName: companyNameController.text,
            supplier: supplier,
            isPerson: false,
          ),
        );
      }
    }
    if (state.status == PersonStatus.error) {
      logger.e(state.errorMessage);
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
              validator: (val) {
                if (val!.isEmpty) {
                  return "Please enter a last name";
                }
                return null;
              }),
          const SizedBox(height: 20),
          
          GroupDropdownMenu(
            groupSpace: groupSpace,
            handleChangeDropdownItem: updateRole,
            btnstyle: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
            ),
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: SecondaryColors.secondaryRed,
                  width: 1,
                ),
              ),
            ),
            leadingIcon: Icon(Icons.filter_list_alt,
                color: SMSRecipientColors.primaryColor),
            menuStyle: const MenuStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
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
                          if (
                              _personFormKey.currentState!.validate()
                              && currentSelectedGroupSpace.isNotEmpty
                              //  &&
                              // currentSelectedGroupSpace.isNotEmpty &&
                              // companyNameController.text.isNotEmpty
                            ) {
                            formHasErrors = false;
                            _createPerson();
                          }  else {
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
