import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_request.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/login.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/contacts/groups.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/parent.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/constants.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/default_btn.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/contact_drop_down.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/drop_down_menu.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/phone_number_field.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_area.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/pickers/date_picker.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../data/constants/shared_prefs.dart';
import '../../../../data/groups/model/group_model.dart';
import '../../../utilities/font_sizes.dart';
import '../person/bloc/person_bloc.dart';

enum ScreenFunction {
  add,
  edit,
}

enum ContactVariant { student, others }

var sl = GetIt.instance;

class PersonDetails extends StatefulWidget {
  final ScreenFunction screenFunction;
  final ContactVariant contactVariant;
  final PersonModel? person;
  final String? role;
  const PersonDetails({
    Key? key,
    required this.screenFunction,
    required this.contactVariant,
    this.person,
    this.role,
  }) : super(key: key);

  @override
  State<PersonDetails> createState() => _PersonDetailsState();
}

class _PersonDetailsState extends State<PersonDetails> {
  var prefs = sl<SharedPreferenceModule>();

  // TextEditingControllers
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final phoneNumberController2 = TextEditingController();
  final phoneNumberController3 = TextEditingController();
  final notesController = TextEditingController();
  final emailController = TextEditingController();
  final emailController2 = TextEditingController();
  final emailController3 = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final groupController = TextEditingController();
  final countryController = TextEditingController();
  // final country = Constants.countries[0];

  bool isCurrentPage = true;

  // Collapse Sections
  bool collapseContacts = false;
  bool collapseAddress = false;
  bool collapseGroups = false;
  bool collapseInvoices = false;
  bool collapsePendingPayments = false;

  // Date picker and change date handler
  DateTime selectedDate = DateTime.now();
  void _changeDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  // Email List and update handler
  List<String> emailList = [];
  _updateEmailList(email) async {
    if (email == "Add new email") {
      await _buildDialog(
        context,
        email,
        emailController,
        onPressed: () {
          emailList.add(emailController.text);
        },
      );
    }
  }

  // Group list and add new group
  List<Group> groupList = [];
  List<Group> selectGroupList = [];
  List<Group> disconnectedGroupList = [];
  _updateGroupList() async {
    Group groupData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupsScreen(
            contactSelection: widget.contactVariant == ContactVariant.student
                ? ContactSelection.students
                : ContactSelection.allContacts),
      ),
    );
    groupList.add(groupData);
    selectGroupList.add(groupData);
    disconnectedGroupList.remove(groupData);
    setState(() {});
  }

  // Country option and change handler
  String selectedCountry = "Country";
  void _changeCountry(country) {
    setState(() {
      selectedCountry = country;
    });
  }

  // Parent List and update handler
  List<ParentObject> parentList = [];
  _addToParentList() async{
    try {
      setState(() {
        isCurrentPage = false;
      });
        PersonModel parentData = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const Parents(parentSection: ParentSection.students),
          ),
        );
        parentList.add(ParentObject(
          name: parentData.firstName + " " + parentData.lastName1,
          relation: PersonChildRelation(
            relativePersonId: parentData.id,
            relation: "PARENT",
          ),
        ));
        setState(() {
          isCurrentPage = true;
        });
      setState(() {});
    } catch (e) {
      logger.e(e);
    }
  }

  _removeFromParentList(ParentObject parentName) {
    parentList.remove(parentName);
    setState(() {});
  }

  // Gender option and change handler
  String selectedGender = "Gender*";
  void _changeGender(gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  saveData() {
    if (widget.screenFunction == ScreenFunction.add) {
      context.read<PersonBloc>().add(
            AddPersonEvent(PersonRequest(
              firstName: firstNameController.text,
              middleName: middleNameController.text,
              lastName1: lastNameController.text,
              gender: selectedGender == "Gender*" ? null : selectedGender,
              phoneNumber1: phoneNumberController.text,
              phoneNumber2: phoneNumberController2.text,
              phoneNumber3: phoneNumberController3.text,
              email1: emailController.text,
              email2: emailController2.text,
              email3: emailController3.text,
              dateOfBirth: selectedDate.toString(),
              groupIds: selectGroupList.map((e) => e.id!).toList().toSet().toList(),
              personChildRelations: parentList
                  .map((e) => e.relation)
                  .toList(),
              isLegal: false,
            )),
          );
    } else {
      try {
        if (widget.screenFunction == ScreenFunction.edit) {
          context.read<PersonBloc>().add(
                UpdatePersonEvent(
                  UpdatePersonRequest(
                    id: widget.person!.id,
                    firstName: firstNameController.text,
                    middleName: middleNameController.text,
                    lastName1: lastNameController.text,
                    gender: selectedGender != "Gender*" ? selectedGender : null,
                    phoneNumber1: phoneNumberController.text,
                    phoneNumber2: phoneNumberController2.text,
                    phoneNumber3: phoneNumberController3.text,
                    email1: emailController.text,
                    email2: emailController2.text,
                    email3: emailController3.text,
                    dateOfBirth: selectedDate.toString(),
                    connectGroupIds: selectGroupList
                        .where((element) => !widget.person!.groups!
                            .map((e) => e.id)
                            .toList()
                            .contains(element.id))
                        .map((e) => e.id!)
                        .toList(),
                    disconnectGroupIds: widget.person!.groups!
                        .where((element) => !selectGroupList.contains(element))
                        .map((e) => e.id!)
                        .toList(),
                    isLegal: widget.person!.isLegal,
                    VATId: widget.person!.VATId,
                    taxId: widget.person!.taxId,
                    address: Address(
                      street: streetController.text,
                      city: cityController.text,
                      state: stateController.text,
                      zip: zipController.text,
                    ),
                    isDeactivated: widget.person!.isDeactivated,
                  )
                ),
              );
        }
      } catch (e) {
        logger.e(e);
      }
    }
  }

  // Primary Color Selection
  Color _primaryColorSelection() {
    if (widget.contactVariant == ContactVariant.student) {
      return PrimaryColors.primaryPink;
    } else {
      return PrimaryColors.primaryLightGreen;
    }
  }

  // Secondary Color Selection
  Color _secondaryColorSelection() {
    if (widget.contactVariant == ContactVariant.student) {
      return SecondaryColors.secondaryPink;
    } else {
      return SecondaryColors.secondaryLightGreen;
    }
  }

  // Background Color Selection
  Color _backgroundColorSelection() {
    if (widget.contactVariant == ContactVariant.student) {
      return BackgroundColors.bgPink;
    } else {
      return BackgroundColors.bgLightGreen;
    }
  }

  // Tertiary Color Selection
  Color _tertiaryColorSelection() {
    if (widget.contactVariant == ContactVariant.student) {
      return TertiaryColors.tertiaryPink;
    } else {
      return TertiaryColors.tertiaryLightGreen;
    }
  }

  // Handle Person State Change
  void _onPersonStateChange(PersonState state) {
    if (state.status == PersonStatus.success  && state.successMessage != null) {
      GFToast.showToast(
        state.successMessage,
        context,
        toastDuration: 5,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        backgroundColor: Colors.green,
        toastBorderRadius: 12.0,
      );
      if(state.personResponse != null) Navigator.pop(context, true);
    } else if (state.status == PersonStatus.error) {
      if (state.errorMessage!.contains("Unauthorized")) {
      } else {
        GFToast.showToast(
          state.errorMessage!,
          context,
          toastDuration: 5,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          backgroundColor: Colors.red,
          toastBorderRadius: 12.0,
        );
      }
    }
  }

  // Handle Refresh State Change
  void _onRefreshStateChange(AuthState state) {
    if (state.status == AuthStateStatus.authenticated) {
      saveData();
    } else if (state.status == AuthStateStatus.unauthenticated) {
      // logout
      _onLogoutStateChange();
    }
  }

  // Handle Logout State Change
  void _onLogoutStateChange() {
    prefs.clear();
    nextScreenAndRemoveAll(context: context, screen: const LoginScreen());
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.person != null) {
      firstNameController.text = widget.person!.firstName;
      middleNameController.text = widget.person!.middleName ?? "";
      lastNameController.text = widget.person!.lastName1;
      phoneNumberController.text = widget.person!.phoneNumber1 ?? "";
      phoneNumberController2.text = widget.person!.phoneNumber2 ?? "";
      phoneNumberController3.text = widget.person!.phoneNumber3 ?? "";
      emailController.text = widget.person!.email1 ?? "";
      emailController2.text = widget.person!.email2 ?? "";
      emailController3.text = widget.person!.email3 ?? "";
      selectGroupList.addAll(widget.person!.groups!);
      selectedGender = widget.person?.gender ?? "Gender*";
      parentList.addAll(widget.person!.childRelations!
          .where((element) => element.relation == "PARENT")
          .map((e) => ParentObject(
                name: "${e.firstName!} ${e.lastName1!}",
                relation: PersonChildRelation(
                  relativePersonId: e.id,
                  relation: "PARENT",
                ),
              ))
          .toList());
      // logger.d(selectGroupList[0].name);
      streetController.text = widget.person!.address?.street ?? "";
      cityController.text = widget.person!.address?.city ?? "";
      stateController.text = widget.person!.address?.state ?? "";
      zipController.text = widget.person!.address?.zip ?? "";
      selectedDate = widget.person!.dateOfBirth != null
          ? DateTime.parse(widget.person!.dateOfBirth!)
          : DateTime.now();
    }
    List<Group> groups = prefs.getGroups();
    for (var group in groups) {
      groupList.add(group);
    }
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    phoneNumberController2.dispose();
    phoneNumberController3.dispose();
    emailController.dispose();
    emailController2.dispose();
    emailController3.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.dispose();
  }

  int displayPhoneNumberField = 1;
  int displayEmailField = 1;

  // Form Key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("person_details"),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 1) {
          isCurrentPage = true;
        } else {
          isCurrentPage = false;
        }
      },
      child: BlocConsumer<PersonBloc, PersonState>(
        listener: (context, state) {
          // TODO: implement listener
          if (isCurrentPage && mounted) {
            _onPersonStateChange(state);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: _backgroundColorSelection(),
            appBar: _buildAppBar(),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  const SizedBox(height: 20),
                  _buildCircleAvatar(),
                  const SizedBox(height: 20),
                  _buildTextField(firstNameController, "First name*"),
                  _buildTextField(middleNameController, "Middle name"),
                  _buildTextField(lastNameController, "Last name*"),
                  _buildDatePicker(),
                  const SizedBox(height: 20),
                  _buildGenderDropDown(),
                  const SizedBox(height: 20),
                  _buildSection(
                      "Contacts",
                      Icons.contact_page_rounded,
                      [
                        _buildPhoneNumberField(
                            phoneNumberController, "Primary number"),
                        if (displayPhoneNumberField >= 2)
                          _buildPhoneNumberField(
                              phoneNumberController2, "Second number"),
                        if (displayPhoneNumberField >= 3)
                          _buildPhoneNumberField(
                              phoneNumberController3, "Third number"),
                        // SizedBox(height: 5),
                        if (displayPhoneNumberField < 3)
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  if (displayPhoneNumberField < 3) {
                                    displayPhoneNumberField =
                                        displayPhoneNumberField + 1;
                                  }
                                });
                              },
                              child: Text(
                                "Add another number",
                                style: TextStyle(
                                    color: _secondaryColorSelection()),
                              )),
                        _buildEmailField(emailController, "Primary email"),
                        if (displayEmailField >= 2)
                          _buildEmailField(emailController2, "Second email"),
                        if (displayEmailField >= 3)
                          _buildEmailField(emailController3, "Third email"),
                        if (displayEmailField < 3)
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  if (displayEmailField < 3) {
                                    displayEmailField = displayEmailField + 1;
                                  }
                                });
                              },
                              child: Text(
                                "Add another email",
                                style: TextStyle(
                                  color: _secondaryColorSelection(),
                                  decoration: TextDecoration.underline,
                                ),
                              )),
                      ],
                      collapse: collapseContacts),
                  _buildSection(
                      "Address",
                      Icons.home_rounded,
                      [
                        _buildTextField(streetController, "Street"),
                        _buildTextField(cityController, "City"),
                        _buildTextField(stateController, "State"),
                        _buildTextField(zipController, "Zip"),
                      ],
                      collapse: collapseAddress),
                  _buildPersonRelativeSection(),
                  _buildSection(
                    "Groups *",
                    Icons.groups_2_rounded,
                    [
                      _buildGroupChip(),
                    ],
                    isAddButton: true,
                    btnAction: _updateGroupList,
                    collapse: collapseGroups,
                  ),
                  _buildTextArea(notesController, "Notes..."),
                  const SizedBox(height: 20),
                  _buildSection("Invoices", Icons.receipt, [],
                      collapse: collapseInvoices),
                  _buildSection(
                      "Pending payments", Icons.attach_money_rounded, [],
                      collapse: collapsePendingPayments),
                  const SizedBox(height: 20),
                  Divider(
                    color: _primaryColorSelection(),
                  ),
                  _buildSaveButton(saveData),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: _secondaryColorSelection()),
      backgroundColor: _primaryColorSelection(),
      title: _buildAppBarTitle(widget.screenFunction, widget.contactVariant),
      actions: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            _onRefreshStateChange(state);
          },
          child: Container(),
        ),
        IconButton(
          onPressed: () {
            if (firstNameController.text.isNotEmpty &&
                lastNameController.text.isNotEmpty &&
                selectGroupList.isNotEmpty) {
              saveData();
            } else {
              GFToast.showToast(
                "Please fill all required fields",
                context,
                toastDuration: 5,
                toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
                    ? GFToastPosition.TOP
                    : GFToastPosition.BOTTOM,
                backgroundColor: Colors.red,
                toastBorderRadius: 12.0,
              );
            }
          },
          icon: const Icon(Icons.check_rounded),
        ),
      ],
    );
  }

  Text _buildAppBarTitle(
      ScreenFunction screenFunction, ContactVariant contactVariant) {
    if (screenFunction == ScreenFunction.add) {
      if (contactVariant == ContactVariant.student) {
        return Text("Add student",
            style: TextStyle(color: _secondaryColorSelection()));
      } else {
        return Text("Add contact",
            style: TextStyle(color: _secondaryColorSelection()));
      }
    } else {
      if (contactVariant == ContactVariant.student) {
        return Text("Edit student",
            style: TextStyle(color: _secondaryColorSelection()));
      } else {
        return Text("Edit contact",
            style: TextStyle(color: _secondaryColorSelection()));
      }
    }
  }

  Widget _buildCircleAvatar() {
    return CircleAvatar(
      radius: 25,
      backgroundColor: _primaryColorSelection(),
      child: const Icon(Icons.person_add_rounded),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {TextInputType? inputType}) {
    return CustomTextField(
      controller: controller,
      color: _secondaryColorSelection(),
      hintText: hintText,
      inputType: inputType,
      // validator: (value) {
      //   // if (value != null && value.endsWith("*")) return null;
      //   if ((value == null || value.isEmpty) && hintText.endsWith("*")) {
      //     return "This field is required";
      //   }
      //   return null;
      // },
    );
  }

  Widget _buildTextArea(TextEditingController controller, String hintText) {
    return Column(
      children: [
        Divider(
          color: _primaryColorSelection(),
        ),
        const SizedBox(height: 20),
        CustomTextArea(
          hintText: hintText,
          controller: controller,
          color: _secondaryColorSelection(),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField(TextEditingController controller, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(text,
                style: TextStyle(
                  color: _secondaryColorSelection(),
                  fontSize: CustomFontSize.extraSmall,
                )),
            Spacer(),
            if (text.toLowerCase() != "primary number")
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (displayPhoneNumberField > 1) {
                        displayPhoneNumberField = displayPhoneNumberField - 1;
                      }
                    });
                  },
                  child: Text(
                    "Remove number",
                    style: TextStyle(color: _secondaryColorSelection()),
                  )),
          ],
        ),
        const SizedBox(height: 5),
        CustomPhoneNumberField(
          initialValue: controller.text,
          controller: controller,
          color: _secondaryColorSelection(),
          onChanged: (value) {
            controller.text = value.completeNumber;
          },
        ),
      ],
    );
  }

  // Build Email Field
  Widget _buildEmailField(TextEditingController controller, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(text,
                style: TextStyle(
                  color: _secondaryColorSelection(),
                  fontSize: CustomFontSize.extraSmall,
                )),
            Spacer(),
            if (text.toLowerCase() != "primary email")
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (displayEmailField > 1) {
                        displayEmailField = displayEmailField - 1;
                      }
                    });
                  },
                  child: Text(
                    "Remove email",
                    style: TextStyle(color: _secondaryColorSelection()),
                  )),
          ],
        ),
        const SizedBox(height: 5),
        CustomTextField(
          controller: controller,
          color: _secondaryColorSelection(),
          hintText: text,
          inputType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    // convert tertiary Color to Material Color
    var tertiaryColor = MaterialColor(
      _tertiaryColorSelection().value,
      <int, Color>{
        50: _tertiaryColorSelection(),
        100: _tertiaryColorSelection(),
        200: _tertiaryColorSelection(),
        300: _tertiaryColorSelection(),
        400: _tertiaryColorSelection(),
        500: _tertiaryColorSelection(),
        600: _tertiaryColorSelection(),
        700: _tertiaryColorSelection(),
        800: _tertiaryColorSelection(),
        900: _tertiaryColorSelection(),
      },
    );

    return DatePicker(
      pickerTimeLime: PickerTimeLime.past,
      bgColor: Colors.white.withOpacity(0.3),
      date: selectedDate,
      onSelect: _changeDate,
      pickerColor: tertiaryColor,
      borderColor: _secondaryColorSelection(),
    );
  }

  Widget _buildGenderDropDown() {
    return CustomDropDownMenu(
      color: _secondaryColorSelection(),
      options: const [
        "Gender*",
        ...Constants.genders,
      ],
      value: selectedGender,
      onChanged: _changeGender,
    );
  }

  Widget _buildSection(
    String title, 
    IconData icon,
    List<Widget> children,
      {
        bool isAddButton = false,
        Function()? btnAction,
        bool collapse = false
      }
    ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Divider(
          color: _primaryColorSelection(),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(icon, color: _secondaryColorSelection()),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: CustomFontSize.large,
                fontWeight: FontWeight.w600,
                color: _secondaryColorSelection(),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
                onPressed: () {
                  setState(() {
                    logger.d(collapse);
                    // Update the state variable based on the provided collapse parameter
                    if (title == "Contacts") {
                      collapseContacts = !collapseContacts;
                    } else if (title == "Address") {
                      collapseAddress = !collapseAddress;
                    } else if (title == "Groups") {
                      collapseGroups = !collapseGroups;
                    } else if (title == "Invoices") {
                      collapseInvoices = !collapseInvoices;
                    } else if (title == "Pending Payments") {
                      collapsePendingPayments = !collapsePendingPayments;
                    }
                  });
                },
                icon: Icon(
                  collapse
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 30,
                  color: _secondaryColorSelection(),
                )),
            const Spacer(),
            if (isAddButton) _buildAddButton(onPressed: btnAction),
          ],
        ),
        const SizedBox(height: 20),
        if (!collapse) ...children,
      ],
    );
  }

  Widget _buildAddButton({Function()? onPressed}) {
    return SizedBox(
      height: 80,
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColorSelection(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            elevation: 5,
          ),
          onPressed: onPressed,
          child: Icon(
            Icons.add,
            color: _secondaryColorSelection(),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(Function()? onPressed) {
    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                backgroundColor: _primaryColorSelection(),
                onPressed: state.isLoading
                    ? null
                    : () {
                        if (firstNameController.text.isNotEmpty  &&
                            lastNameController.text.isNotEmpty  &&
                            selectGroupList.isNotEmpty) {
                          onPressed!();
                        } else {
                          GFToast.showToast(
                            "Please fill all required fields",
                            context,
                            toastDuration: 5,
                            toastPosition:
                                MediaQuery.of(context).viewInsets.bottom != 0
                                    ? GFToastPosition.TOP
                                    : GFToastPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            toastBorderRadius: 12.0,
                          );
                        }
                      },
                label: !state.isLoading
                    ? Text(
                        "Save",
                        style: TextStyle(
                          color: _secondaryColorSelection(),
                          fontSize: CustomFontSize.large,
                        ),
                      )
                    : CircularProgressIndicator(
                        color: _secondaryColorSelection(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropDownOptions(
    String value,
    List<String> options,
    Function(dynamic)? onChanged,
  ) {
    return ContactDropDownOptions(
      value: value,
      options: ["Email", ...options, "Add new email"],
      color: _secondaryColorSelection(),
      onChanged: onChanged,
    );
  }

  Widget _buildGroupChip() {
    List<String> filterGroups = [];
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          ...selectGroupList.map((group)  {            
            if (filterGroups.contains(group.name)) {
              return Container();
            } else {
              filterGroups.add("${group.name}");
              return Chip(
                    label: Text(
                      group.name!,
                      style: TextStyle(
                        color: _secondaryColorSelection(),
                        fontSize: CustomFontSize.medium,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    backgroundColor: _primaryColorSelection(),
                    deleteIconColor: _secondaryColorSelection(),
                    onDeleted: () {
                      setState(() {
                        selectGroupList.remove(group);
                        disconnectedGroupList.add(group);
                      });
                    },
                  );
            }


          }
            ),
        ],
      ),
    );
  }

  Widget _buildParentListTile(ParentObject parent) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: _primaryColorSelection(),
              borderRadius: BorderRadius.circular(12),
              // Shadow
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: const Offset(0, 5),
                  blurRadius: 5,
                )
              ]),
          child: ListTile(
            title: Text(
              parent.name,
              style: TextStyle(
                color: _secondaryColorSelection(),
                fontSize: CustomFontSize.large,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                _removeFromParentList(parent);
              },
              icon: Icon(
                Icons.clear_rounded,
                color: _secondaryColorSelection(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPersonRelativeSection() {
    if (widget.contactVariant == ContactVariant.student ||
        widget.person != null && widget.person!.role == "Student") {
      return _buildSection(
        "Parents",
        Icons.people_alt_rounded,
        parentList.map((parent) => _buildParentListTile(parent)).toList(),
        isAddButton: true,
        btnAction: _addToParentList,
      );
    } else {
      return Container();
    }
  }

  _buildDialog(
    BuildContext context,
    String title,
    TextEditingController controller, {
    Function()? onPressed,
  }) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: _primaryColorSelection(),
              title: Text(title),
              content: _buildTextField(
                controller,
                title,
                inputType: TextInputType.emailAddress,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: _secondaryColorSelection(),
                      fontSize: CustomFontSize.large,
                    ),
                  ),
                ),
                DefaultBtn(
                  text: "Save",
                  onPressed: () {
                    Navigator.pop(context);
                    if (onPressed != null) onPressed();
                  },
                  textColor: _secondaryColorSelection(),
                  btnColor: _primaryColorSelection(),
                )
              ]);
        });
  }
}


class ParentObject {
  final String name;
  final PersonChildRelation relation;

  ParentObject({
    required this.name,
    required this.relation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'relation': relation,
    };
  }  
}