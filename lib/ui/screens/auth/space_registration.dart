import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:seymo_pay_mobile_application/data/constants/languages_countries.dart';

import 'package:seymo_pay_mobile_application/ui/screens/auth/login.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/register.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/elevated_button.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/filled_btn.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';

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
  SpaceRegistrationForm({super.key});

  @override
  State<SpaceRegistrationForm> createState() => _SpaceRegistrationFormState();
}

class _SpaceRegistrationFormState extends State<SpaceRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController schoolNameController = TextEditingController();
  // TextEditingController countryNameController = TextEditingController();

  // late String selectedCountry = "";
  TextEditingController selectedCountryController = TextEditingController();

  // late String selectedCurrency = "";
  TextEditingController selectedCurrencyController = TextEditingController();

  String _timezone = 'Unknown';
  List<String> _availableTimezones = <String>[];
  late String dropdownValueTimezone;

  String dropdownValueLocalization = 'en - English';

  double heightSizeSchool = 55;
  double heightSizeCountry = 55;
  double heightSizeCurrency = 55;
  double heightSizeTimeline = 55;
  double heightSizeLanguage = 55;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      _timezone = await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezonee');
    }
    try {
      _availableTimezones = await FlutterTimezone.getAvailableTimezones();
      _availableTimezones.sort();
      dropdownValueTimezone = _availableTimezones.first;
    } catch (e) {
      print('Could not get available timezones');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {
            nextScreen(
              context: context,
              screen: const SpaceRegistration(),
            )
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
      body: CustomScrollView(
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
                        CustomTextField(
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
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
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
                            onTap: () => {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: false,
                                onSelect: (Country country) {
                                  setState(
                                    () {
                                      selectedCountryController.text =
                                          country.name;
                                    },
                                  );
                                },
                              ),
                            },
                            showCursor: false,
                            readOnly: true,
                            decoration: InputDecoration(
                              label: const Text("Select Country"),
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
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: heightSizeCurrency,
                          child: TextFormField(
                            controller: selectedCurrencyController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  heightSizeCurrency = 80;
                                });
                                return "Select your Currency";
                              } else {
                                setState(() {
                                  heightSizeCurrency = 50;
                                });
                              }
                              return null;
                            },
                            onTap: () => {
                              showCurrencyPicker(
                                context: context,
                                showFlag: true,
                                showCurrencyName: true,
                                showCurrencyCode: true,
                                onSelect: (Currency currency) {
                                  setState(() {
                                    print(
                                        " ...  currency.code ${currency.code}......");
                                    selectedCurrencyController.text =
                                        currency.code;
                                  });
                                },
                              ),
                            },
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
                              label: const Text("Select Currency"),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField(
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
                              return "Select your timezone";
                            }
                            return null;
                          },
                          dropdownColor: const Color(0xfffffffff),
                          value: _timezone.isNotEmpty
                              ? _timezone
                              : _availableTimezones.first,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValueTimezone = newValue!;
                            });
                          },
                          items:
                              _availableTimezones.map<DropdownMenuItem<String>>(
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
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField(
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
                              return "Select laguage of your choice";
                            }
                            return null;
                          },
                          dropdownColor: const Color(0xfffffffff),
                          value: dropdownValueLocalization,
                          // onChanged: (String? newValue) {
                          //   setState(() {
                          //     dropdownValueLocalization = newValue!;
                          //   });
                          // },
                          onChanged: null,
                          items: kSetMaterialSupportedLanguages
                              .map<DropdownMenuItem<String>>(
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
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledBtn(
                            btnSize: BtnSize.md,
                            loading: false,
                            text: "Next",
                            color: Color(0xffDAC6A1),
                            // color: _formKey.currentState!.validate()
                            //     ? Color(0xffDAC6A1)
                            //     : Colors.grey,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                nextScreen(
                                  context: context,
                                  screen: RegistrationScreen(
                                    spaceName: schoolNameController.text,
                                    spaceCountry:
                                        selectedCountryController.text,
                                    spaceCurrency:
                                        selectedCurrencyController.text,
                                    spaceLanguage: dropdownValueLocalization,
                                    spaceTimezone: _availableTimezones,
                                  ),
                                );
                              }
                            },
                            btnVariant: BtnVariant.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
