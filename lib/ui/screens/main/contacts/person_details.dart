import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/parent.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/constants.dart';
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

enum ScreenFunction {
  add,
  edit,
}

var sl = GetIt.instance;

class PersonDetails extends StatefulWidget {
  final ScreenFunction screenFunction;
  final PersonModel? person;

  const PersonDetails({
    Key? key,
    required this.screenFunction,
    this.person,
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
  List<String> groupList = [];
  List<String> selectGroupList = [];
  _updateGroupList(group) async {
    if (group == "Add new group") {
      await _buildDialog(
        context,
        group,
        groupController,
        onPressed: () {
          groupList.add(groupController.text);
          selectGroupList.add(groupController.text);
        },
      );
    }
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
  _updateParentList() async {
    PersonModel parentData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Parents(parentSection: ParentSection.students),
      ),
    );
    parentList.add("${parentData.firstName!} ${parentData.lastName1!}");
    }

  // Gender option and change handler
  String selectedGender = "Gender";
  void _changeGender(gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.person != null) {
      firstNameController.text = widget.person!.firstName ?? "";
      middleNameController.text = widget.person!.middleName ?? "";
      lastNameController.text = widget.person!.lastName1 ?? "";
      phoneNumberController.text = widget.person!.phoneNumber ?? "";
      // emailController.text = widget.person!.email;
      // streetController.text = widget.person!.street;
      // cityController.text = widget.person!.city;
      // stateController.text = widget.person!.state;
      // zipController.text = widget.person!.zip;
      selectedDate = widget.person!.dateOfBirth != null
          ? DateTime.parse(widget.person!.dateOfBirth!)
          : DateTime.now();
    }
    List<Group> groups = prefs.getGroups();
    for (var group in groups) {
      groupList.add(group.name!);
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
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: _buildAppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
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
            _buildPhoneNumberField(phoneNumberController),
            const SizedBox(height: 20),
            _buildTextField(streetController, "Street"),
          ]),
          _buildSection("Address", Icons.home_rounded, [
            _buildDropDownOptions("Email", emailList, _updateEmailList),
            // const SizedBox(height: 20),
            const SizedBox(height: 20),
            _buildTextField(cityController, "City"),
            const SizedBox(height: 20),
            _buildTextField(stateController, "State"),
            const SizedBox(height: 20),
            _buildTextField(zipController, "Zip"),
          ]),
          _buildSection("Parents", Icons.people_alt_rounded, [],
              isAddButton: true, btnAction: _updateParentList),
          _buildSection(
              "Groups",
              Icons.groups_2_rounded,
              [
                _buildGroupChip(),
              ],
              isAddButton: true),
          _buildTextArea(notesController, "Notes..."),
          const SizedBox(height: 20),
          _buildSection("Invoices", Icons.receipt, [], isAddButton: true),
          _buildSection("Upcoming payments", Icons.attach_money_rounded, []),
          const SizedBox(height: 20),
          Divider(
            color: Colors.pink.shade100,
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: SecondaryColors.secondaryPink),
      backgroundColor: Colors.pink.shade100,
      title: Text(
        widget.screenFunction == ScreenFunction.add
            ? "Add contact"
            : "Edit contact",
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.check_rounded),
        ),
      ],
    );
  }

  Widget _buildCircleAvatar() {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.pink.shade100,
      child: Icon(Icons.person_add_rounded),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {TextInputType? inputType}) {
    return CustomTextField(
      controller: controller,
      color: SecondaryColors.secondaryPink,
      hintText: hintText,
      inputType: inputType,
    );
  }

  Widget _buildTextArea(TextEditingController controller, String hintText) {
    return Column(
      children: [
        Divider(
          color: Colors.pink.shade100,
        ),
        const SizedBox(height: 20),
        CustomTextArea(
          hintText: hintText,
          controller: controller,
          color: SecondaryColors.secondaryPink,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField(TextEditingController controller) {
    return CustomPhoneNumberField(
      controller: controller,
      color: SecondaryColors.secondaryPink,
    );
  }

  Widget _buildDatePicker() {
    return DatePicker(
      pickerTimeLime: PickerTimeLime.past,
      bgColor: Colors.white.withOpacity(0.3),
      date: selectedDate,
      onSelect: _changeDate,
      pickerColor: Colors.pink,
      borderColor: SecondaryColors.secondaryPink,
    );
  }

  Widget _buildGenderDropDown() {
    return CustomDropDownMenu(
      color: SecondaryColors.secondaryPink,
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
          color: Colors.pink.shade100,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(icon, color: SecondaryColors.secondaryPink),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: CustomFontSize.large,
                color: SecondaryColors.secondaryPink,
              ),
            ),
            const Spacer(),
            if (isAddButton && title == "Parents") _buildAddButton(onPressed: btnAction),
            if (isAddButton && title == "Groups") _buildPopupMenu(),
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
            backgroundColor: Colors.pink.shade100,
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
            color: SecondaryColors.secondaryPink,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            backgroundColor: Colors.pink.shade100,
            onPressed: () {},
            label: Text(
              "Save",
              style: TextStyle(
                color: SecondaryColors.secondaryPink,
                fontSize: CustomFontSize.large,
              ),
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
      color: Colors.pink,
      onChanged: onChanged,
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.pink.shade100,
      child: Container(
          height: 40,
          width: 70,
          decoration: BoxDecoration(
              color: Colors.pink.shade100,
              borderRadius: BorderRadius.circular(12),
              // Shadow
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(0, 5),
                  blurRadius: 5,
                )
              ]),
          child: Center(
            child: Icon(
              Icons.add,
              color: SecondaryColors.secondaryPink,
            ),
          )),
      itemBuilder: (context) => [
        ...groupList.map((group) => PopupMenuItem(
            child: Text(group,
                style: TextStyle(
                    color: SecondaryColors.secondaryPink,
                    fontSize: CustomFontSize.medium,
                    fontWeight: FontWeight.normal)),
            onTap: () {
              setState(() {
                selectGroupList.add(group);
              });
            })),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.add, color: SecondaryColors.secondaryPink),
              const SizedBox(width: 10),
              Text("Add new group",
                  style: TextStyle(
                      color: SecondaryColors.secondaryPink,
                      fontSize: CustomFontSize.medium,
                      fontWeight: FontWeight.normal)),
            ],
          ),
          onTap: () => _updateGroupList("Add new group"),
        ),
      ],
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
                  group,
                  style: TextStyle(
                    color: SecondaryColors.secondaryPink,
                    fontSize: CustomFontSize.medium,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                backgroundColor: Colors.pink.shade100,
                deleteIconColor: SecondaryColors.secondaryPink,
                onDeleted: () {
                  setState(() {
                    selectGroupList.remove(group);
                  });
                },
              )),
        ],
      ),
    );
  }

  Widget _buildParentListTile() {
    return ListTile(
      title: Text(
        "Parent",
        style: TextStyle(
          color: SecondaryColors.secondaryPink,
          fontSize: CustomFontSize.large,
        ),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.clear_rounded,
          color: SecondaryColors.secondaryPink,
        ),
      ),
    );
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
              backgroundColor: Colors.pink.shade100,
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
                      color: SecondaryColors.secondaryPink,
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
                  textColor: SecondaryColors.secondaryPink,
                  btnColor: Colors.pink.shade100,
                )
              ]);
        });
  }
}
