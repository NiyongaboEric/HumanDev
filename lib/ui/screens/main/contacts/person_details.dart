import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/drop_down_menu.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/pickers/date_picker.dart';

import '../../../utilities/font_sizes.dart';

enum ScreenFunction {
  add,
  edit,
}

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
  // TextEditingControllers
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();

  // Date picker and change date handler
  DateTime selectedDate = DateTime.now();
  void _changeDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  // Gender option and change handler
  String selectedGender = "Gender";
  List<String> genders = ["Male", "Female", "Other"];
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
            _buildTextField(phoneNumberController, "Phone number"),
            const SizedBox(height: 20),
            _buildTextField(emailController, "Email"),
            const SizedBox(height: 20),
            _buildTextField(streetController, "Street"),
            const SizedBox(height: 20),
            _buildTextField(cityController, "City"),
            const SizedBox(height: 20),
            _buildTextField(stateController, "State"),
            const SizedBox(height: 20),
            _buildTextField(zipController, "Zip"),
          ]),
          _buildSection("Parents", Icons.people_alt_rounded, [
            _buildAddButton(),
          ]),
          _buildSection("Upcoming payments", Icons.attach_money_rounded, [
            _buildAddButton(),
          ]),
          _buildSection("Invoices", Icons.receipt, [
            _buildAddButton(),
          ]),
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

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return CustomTextField(
      controller: controller,
      color: SecondaryColors.secondaryPink,
      hintText: hintText,
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
      options: [
        "Gender",
        ...genders,
      ],
      value: selectedGender,
      onChanged: _changeGender,
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
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
          ],
        ),
        const SizedBox(height: 20),
        ...children,
      ],
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      height: 80,
      child: Center(
        child: FloatingActionButton.extended(
          backgroundColor: Colors.pink.shade100,
          onPressed: () {},
          label: Icon(
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
}
