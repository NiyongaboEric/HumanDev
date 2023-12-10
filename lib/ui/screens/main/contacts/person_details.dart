import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
  final notesController = TextEditingController();
  final emailController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final groupController = TextEditingController();
  final countryController = TextEditingController();
  // final country = Constants.countries[0];

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
  List<String> parentList = [];
  _addToParentList() async {
    PersonModel parentData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Parents(parentSection: ParentSection.students),
      ),
    );
    parentList.add("${parentData.firstName} ${parentData.lastName1}");
    setState(() {});
  }

  _removeFromParentList(String parentName) {
    parentList.remove(parentName);
    setState(() {});
  }

  // Gender option and change handler
  String selectedGender = "Gender";
  void _changeGender(gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  // Phone Number List Options ad handler
  List<String> phoneNumbers = [];
  _addPhoneNumber(String number) {
    phoneNumbers.add(number);
  }

  _removePhoneNumber(String number) {
    phoneNumbers.remove(number);
  }

  saveData() {
    if (widget.screenFunction == ScreenFunction.add) {
      context.read<PersonBloc>().add(
            AddPersonEvent(PersonRequest(
              firstName: firstNameController.text,
              middleName: middleNameController.text,
              lastName1: lastNameController.text,
              dateOfBirth: selectedDate.toString(),
              role: widget.contactVariant == ContactVariant.student
                  ? Role.Student
                  : stringToRole(widget.role!),
              phoneNumber: phoneNumberController.text,
              isLegal: false,
            )),
          );
    } else {
      try {
        context.read<PersonBloc>().add(
              UpdatePersonEvent(UpdatePersonRequest(
                id: widget.person!.id,
                firstName: firstNameController.text,
                middleName: middleNameController.text,
                lastName1: lastNameController.text,
                // email1: emailList[0],
                // email2: emailList[1],
                // email3: emailList[2],
                dateOfBirth: selectedDate.toString(),
                // connectGroupIds: selectGroupList.map((e) => e.id!).toList(),
                // personSettings: widget.person!.personSettings,
                // groups: widget.person!.groups,
                // VATId: widget.person!.VATId,
                // tagsSettings: widget.person!.tagsSettings,
                // spaceId: widget.person!.spaceId,
                // childRelations: widget.person!.childRelations,
                // relativeRelations: widget.person!.relativeRelations,
                // deactivationDate: widget.person!.deactivationDate,
                // isActive: widget.person!.isActive,
                // createdAt: widget.person!.createdAt,
                // updatedAt: widget.person!.updatedAt,
                isDeactivated: widget.person!.isDeactivated,
                isLegal: false,
              )),
            );
      logger.d(selectGroupList[0].name);
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
    if (state.status == PersonStatus.success) {
      previousScreen(context: context);
      Navigator.pop(context);
    } else if (state.status == PersonStatus.error) {
      if (state.errorMessage!.contains("Unauthorized")) {
      } else {}
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
    nextScreenAndRemoveAll(context: context, screen: LoginScreen());
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.person != null) {
      firstNameController.text = widget.person!.firstName;
      middleNameController.text = widget.person!.middleName ?? "";
      lastNameController.text = widget.person!.lastName1;
      var personNumbers = [
        widget.person!.phoneNumber1,
        widget.person!.phoneNumber2,
        widget.person!.phoneNumber3,
      ];
      selectGroupList.addAll(widget.person!.groups!);
      logger.d(selectGroupList[0].name);
      for (var number in personNumbers) {
        if (number != null && number.isNotEmpty) {
          phoneNumbers.add(number);
        }
      }

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
    emailController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonBloc, PersonState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: _backgroundColorSelection(),
          appBar: _buildAppBar(),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              const SizedBox(height: 20),
              _buildCircleAvatar(),
              const SizedBox(height: 20),
              _buildTextField(firstNameController, "First name"),
              const SizedBox(height: 20),
              _buildTextField(middleNameController, "Middle name"),
              const SizedBox(height: 20),
              _buildTextField(lastNameController, "Last name"),
              const SizedBox(height: 20),
              _buildDatePicker(),
              const SizedBox(height: 20),
              _buildGenderDropDown(),
              const SizedBox(height: 20),
              _buildSection("Contacts", Icons.contact_page_rounded, [
                ...phoneNumbers.map((number) => ListTile(
                      title: Text(
                        number,
                        style: TextStyle(
                          color: _secondaryColorSelection(),
                          fontSize: CustomFontSize.large,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _removePhoneNumber(number);
                        },
                        icon: Icon(
                          Icons.clear_rounded,
                          color: _secondaryColorSelection(),
                        ),
                      ),
                    )),
                _buildPhoneNumberField(phoneNumberController),
                // DefaultBtn(
                //   text: "Add number",
                //   onPressed: () {
                //     if (phoneNumberController.text.isNotEmpty) {
                //       _addPhoneNumber(phoneNumberController.text);
                //       phoneNumberController.clear();
                //     }
                //   },
                //   textColor: _secondaryColorSelection(),
                //   btnColor: _primaryColorSelection(),
                // ),
                // const SizedBox(height: 30),
                _buildDropDownOptions(
                  "Email",
                  emailList,
                  _updateEmailList,
                ),
              ]),
              _buildSection("Address", Icons.home_rounded, [
                _buildTextField(streetController, "Street"),
                const SizedBox(height: 20),
                _buildTextField(cityController, "City"),
                const SizedBox(height: 20),
                _buildTextField(stateController, "State"),
                const SizedBox(height: 20),
                _buildTextField(zipController, "Zip"),
              ]),
              _buildPersonRelativeSection(),
              _buildSection(
                "Groups",
                Icons.groups_2_rounded,
                [
                  _buildGroupChip(),
                ],
                isAddButton: true,
                btnAction: _updateGroupList,
              ),
              _buildTextArea(notesController, "Notes..."),
              const SizedBox(height: 20),
              _buildSection("Invoices", Icons.receipt, []),
              _buildSection(
                  "Upcoming payments", Icons.attach_money_rounded, []),
              const SizedBox(height: 20),
              Divider(
                color: _primaryColorSelection(),
              ),
              _buildSaveButton(saveData, loading: state.isLoading),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: _secondaryColorSelection()),
      backgroundColor: _primaryColorSelection(),
      title: _buildAppBarTitle(widget.screenFunction, widget.contactVariant),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.check_rounded),
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
      child: Icon(Icons.person_add_rounded),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {TextInputType? inputType}) {
    return CustomTextField(
      controller: controller,
      color: _secondaryColorSelection(),
      hintText: hintText,
      inputType: inputType,
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

  Widget _buildPhoneNumberField(TextEditingController controller) {
    return CustomPhoneNumberField(
      controller: controller,
      color: _secondaryColorSelection(),
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
        "Gender",
        ...Constants.genders,
      ],
      value: selectedGender,
      onChanged: _changeGender,
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children,
      {bool isAddButton = false, Function()? btnAction}) {
    return Column(
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
                color: _secondaryColorSelection(),
              ),
            ),
            const Spacer(),
            if (isAddButton) _buildAddButton(onPressed: btnAction),
          ],
        ),
        const SizedBox(height: 20),
        ...children,
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

  Widget _buildSaveButton(Function()? onPressed, {bool loading = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            backgroundColor: _primaryColorSelection(),
            onPressed: loading ? null : onPressed,
            label: !loading
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
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          ...selectGroupList.map((group) => Chip(
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
              )),
        ],
      ),
    );
  }

  Widget _buildParentListTile(String parentName) {
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
                  offset: Offset(0, 5),
                  blurRadius: 5,
                )
              ]),
          child: ListTile(
            title: Text(
              parentName,
              style: TextStyle(
                color: _secondaryColorSelection(),
                fontSize: CustomFontSize.large,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                _removeFromParentList(parentName);
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
