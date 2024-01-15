import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:seymo_pay_mobile_application/data/constants/languages_countries.dart';
import 'package:seymo_pay_mobile_application/data/constants/timezones.dart';

import 'package:seymo_pay_mobile_application/ui/screens/auth/login.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/register.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/elevated_button.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/filled_btn.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';

import '../../widgets/buttons/default_btn.dart';

class SpaceRegistration extends StatelessWidget {
  const SpaceRegistration({super.key});

  void _joinSpaceAlert(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Color(0xffF5EBD8),
        // title: const Text('AlertDialog Title'),
        content: const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 2),
          child: Text(
            'Please ask the school space administrator to send you an invitation link!',
            style: TextStyle(
              color: Color(0xff512300),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xff512300),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {
            nextScreen(
              context: context,
              screen: const LoginScreen(),
            )
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Seymo',
          style: TextStyle(
            color: Color.fromRGBO(81, 35, 0, 0.80),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.check),
            ),
          ),
        ],
        backgroundColor: const Color(0xFFF5EBD8),
      ),
      backgroundColor: const Color(0xFFFFF8D6),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 140),
            const Text(
              "Welcome to Seymo!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(81, 35, 0, 0.80),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedBtn(
              handleButton: () {
                nextScreen(
                  context: context,
                  screen: SpaceRegistrationForm(),
                );
              },
              textName: 'Create a new school space',
              buttonStyle: ButtonStyle(
                elevation: MaterialStateProperty.all(6),
                backgroundColor: const MaterialStatePropertyAll<Color>(
                  Color(0xFFDAC6A1),
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
              ),
              textStyle: const TextStyle(color: Color(0xFF512300)),
            ),
            const SizedBox(height: 15),
            ElevatedBtn(
              handleButton: () => _joinSpaceAlert(context),
              textName: 'Joing existing school space',
              buttonStyle: ButtonStyle(
                elevation: MaterialStateProperty.all(6),
                backgroundColor: const MaterialStatePropertyAll<Color>(
                  Color(0xFFF5EBD8),
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
              ),
              textStyle: const TextStyle(color: Color(0xFF512300)),
            ),
          ],
        ),
      ),
    );
  }
}

class SpaceRegistrationForm extends StatefulWidget {
  SpaceRegistrationForm({Key? key}) : super(key: key);

  @override
  State<SpaceRegistrationForm> createState() => _SpaceRegistrationFormState();
}

class _SpaceRegistrationFormState extends State<SpaceRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController schoolNameController = TextEditingController();
  TextEditingController selectedCountryController = TextEditingController();
  TextEditingController selectedCurrencyController = TextEditingController();
  String dropdownValueLocalization = 'en - English';

  late String dropdownValueTimezone;

  double heightSizeSchool = 55;
  double heightSizeCountry = 55;
  double heightSizeCurrency = 55;
  double heightSizeTimeline = 55;
  double heightSizeLanguage = 55;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFFFFF8D6),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Create new school space',
        style: TextStyle(
          color: Color.fromRGBO(81, 35, 0, 0.80),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        _buildCheckButton(),
      ],
      backgroundColor: const Color(0xFFF5EBD8),
    );
  }

  IconButton _buildCheckButton() {
    return IconButton(
      onPressed: () => {},
      icon: const Icon(Icons.check),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      _buildSchoolNameField(),
                      const SizedBox(height: 10),
                      _buildCountryField(),
                      const SizedBox(height: 20),
                      _buildCurrencyField(),
                      const SizedBox(height: 20),
                      _buildTimezoneDropdown(),
                      const SizedBox(height: 20),
                      _buildLanguageDropdown(),
                      const SizedBox(height: 20),
                      _buildNextButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSchoolNameField() {
    return CustomTextField(
      heightSize: heightSizeSchool,
      hintText: "School name*",
      controller: schoolNameController,
      validator: (value) {
        if (value!.isEmpty) {
          setState(() {
            heightSizeSchool = 80;
          });
          return "Please enter your school name";
        } else {
          setState(() {
            heightSizeSchool = 55;
          });
        }
        return null;
      },
      fillColor: const Color.fromRGBO(245, 235, 216, 1),
      hintTextSize: 18,
      color: const Color.fromRGBO(77, 12, 43, 1),
    );
  }

  Widget _buildCountryField() {
    return SizedBox(
      height: heightSizeCountry,
      child: TextFormField(
        controller: selectedCountryController,
        validator: (value) {
          if (value!.isEmpty) {
            setState(() {
              heightSizeCountry = 80;
            });
            return "Select your country";
          } else {
            setState(() {
              heightSizeCountry = 50;
            });
          }
          return null;
        },
        onTap: () => _showCountryPicker(),
        showCursor: false,
        readOnly: true,
        decoration: InputDecoration(
          label: const Text("Select country"),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: const Color.fromRGBO(77, 12, 43, 1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: const Color.fromRGBO(77, 12, 43, 1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _buildCurrencyField() {
    return SizedBox(
      height: heightSizeCurrency,
      child: TextFormField(
        controller: selectedCurrencyController,
        validator: (value) {
          if (value!.isEmpty) {
            setState(() {
              heightSizeCurrency = 80;
            });
            return "Select your currency";
          } else {
            setState(() {
              heightSizeCurrency = 50;
            });
          }
          return null;
        },
        onTap: () => _showCurrencyPicker(),
        showCursor: false,
        readOnly: true,
        decoration: InputDecoration(
          hintText: selectedCurrencyController.text,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: const Color.fromRGBO(77, 12, 43, 1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: const Color.fromRGBO(77, 12, 43, 1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          label: const Text("Select currency"),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _buildTimezoneDropdown() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: const Color.fromRGBO(77, 12, 43, 1),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: const Color.fromRGBO(77, 12, 43, 1),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        // if (value!.isEmpty) {
        // return "Select your timezone";
        // }
        if (value == null) {
          return "Select your timezone";
        }
        return null;
      },
      dropdownColor: const Color(0xfffffffff),
      hint: const Text("Select timezone"),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValueTimezone = newValue!;
        });
      },
      items: availableTimezones.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildLanguageDropdown() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: const Color.fromRGBO(77, 12, 43, 1),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: const Color.fromRGBO(77, 12, 43, 1),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Select language of your choice";
        }
        return null;
      },
      dropdownColor: const Color(0xfffffffff),
      value: dropdownValueLocalization,
      onChanged: null,
      items: kSetMaterialSupportedLanguages.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: DefaultBtn(
        text: "Next",
        btnColor: const Color(0xffDAC6A1),
        onPressed: () => {_validateAndNavigate()},
      ),
    );
  }

  void _goBack() {
    nextScreen(
      context: context,
      screen: const SpaceRegistration(),
    );
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          selectedCountryController.text = country.name;
        });
      },
    );
  }

  void _showCurrencyPicker() {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        setState(() {
          selectedCurrencyController.text = currency.code;
        });
      },
    );
  }

  void _validateAndNavigate() {
    if (_formKey.currentState!.validate()) {
      String convertTimezone =
          '${availableTimezonesConversion[dropdownValueTimezone]}';

      nextScreen(
        context: context,
        screen: RegistrationScreen(
          spaceName: schoolNameController.text,
          spaceCountry: selectedCountryController.text,
          spaceCurrency: selectedCurrencyController.text,
          spaceLanguage: dropdownValueLocalization,
          spaceTimezone: convertTimezone,
          // spaceTimezone: _availableTimezones,
        ),
      );
    }
  }
}
