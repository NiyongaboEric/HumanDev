import 'dart:ffi';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_request.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/fullpage_loader_auth.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/space_registration.dart';
import 'package:seymo_pay_mobile_application/ui/screens/home/homepage.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/default_btn.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/filled_btn.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/cards/upload_card.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/constants/upload_card_model.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/contact_drop_down.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/group_drop_down.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/phone_number_field.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/pickers/date_picker.dart';

import '../../utilities/custom_colors.dart';
import '../../utilities/font_sizes.dart';
import '../../utilities/navigation.dart';
import 'auth_bloc/auth_bloc.dart';
import 'login.dart';

List<String> list = <String>['Male', 'Female', 'Other gender'];

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({
    super.key,
    required this.spaceCountry,
    required this.spaceCurrency,
    required this.spaceLanguage,
    required this.spaceName,
    required this.spaceTimezone,
  });

  final String spaceCountry;
  final String spaceCurrency;
  final String spaceLanguage;
  final String spaceName;
  final String spaceTimezone;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  PhoneNumber? phoneNumber;
  bool handleAuth = true;
  bool handleLogin = true;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  // DateTime? _selectedDate;
  TextEditingController dateOfBirthController = TextEditingController();

  String countryCodeOne = "";
  TextEditingController codeNumbercontrollerOne = TextEditingController();
  TextEditingController digitNumbercontrollerOne = TextEditingController();

  String countryCodeTwo = "";
  TextEditingController codeNumbercontrollerTwo = TextEditingController();
  TextEditingController digitNumbercontrollerTwo = TextEditingController();

  String countryCodeThree = "";
  TextEditingController codeNumbercontrollerThree = TextEditingController();
  TextEditingController digitNumbercontrollerThree = TextEditingController();

  TextEditingController emailOneController = TextEditingController();
  TextEditingController emailTwoController = TextEditingController();
  TextEditingController emailThreeController = TextEditingController();

  TextEditingController streetController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController selectCountryController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController genderController = TextEditingController();

  DateTime date = DateTime.now();
  String dropdownValue = list.first;

  bool showContactSection = true;
  double expandContactSectionSize = 0;
  double incrementSectionSize = 100;
  bool isVisibleContact = true;

  bool isVisibleAdress = true;
  bool showAddressSection = true;

  List<bool> extendPhonenumberSize = [true];
  List<bool> extendEmailSize = [true];
  double heightSize = 55;

  double heightSizeFirstName = 55;
  double heightSizeLastName = 55;
  double heightSizeDateOfBirth = 55;
  double heightSizeGender = 55;
  double heightSizeContacts = 55;
  double heightSizeEmail = 55;
  double heightSizePassword = 55;
  double heightSizeConfirmPassword = 55;

  final List<XFile> _images = [];
  Map<dynamic, dynamic> selectPhonenumberController(int index) {
    switch (index) {
      case 0:
        return {
          "countryCode": codeNumbercontrollerOne,
          "digit": digitNumbercontrollerOne,
        };

      case 1:
        return {
          "countryCode": codeNumbercontrollerTwo,
          "digit": digitNumbercontrollerTwo
        };

      case 2:
        return {
          "countryCode": codeNumbercontrollerThree,
          "digit": digitNumbercontrollerThree
        };

      default:
        return {
          "countryCode": codeNumbercontrollerOne,
          "digit": digitNumbercontrollerOne
        };
    }
  }

  // Update Date
  updateDate(DateTime date) {
    setState(() {
      // _selectedDate = date;
      dateOfBirthController.text = "${date.year}/${date.month}/${date.day}";
    });
  }

  // Register
  void register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthEventRegister(
              RegistrationRequest(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                email: emailOneController.text,
                password: passwordController.text,
                phoneNumber: digitNumbercontrollerOne.text,
              ),
              // CompleteRegistrationRequest(
              //   firstName: firstNameController.text,
              //   middleName: middleNameController.text,
              //   lastName1: lastNameController.text,
              //   phoneNumber1:
              //       "${codeNumbercontrollerOne.text}${digitNumbercontrollerOne.text}",
              //   phoneNumber2:
              //       "${codeNumbercontrollerTwo.text}${digitNumbercontrollerTwo.text}",
              //   phoneNumber3:
              //       "${codeNumbercontrollerThree.text}${digitNumbercontrollerThree.text}",
              //   email1: emailOneController.text,
              //   email2: emailTwoController.text,
              //   email3: emailThreeController.text,
              //   dateOfBirth: dateOfBirthController.text,
              //   address: PersonAddress(
              //       streetController.text,
              //       zipController.text,
              //       cityController.text,
              //       stateController.text,
              //       selectCountryController.text),
              // ),

              PersonSpaceRegistrationRequest(
                person: PersonCompleteRegistrationRequest(
                  middleName: middleNameController.text,
                  lastName2: lastNameController.text,
                  phoneNumber2:
                      "+${codeNumbercontrollerTwo.text}${digitNumbercontrollerTwo.text}",
                  phoneNumber3:
                      '+${codeNumbercontrollerTwo.text}${digitNumbercontrollerTwo.text}',
                  email2: emailTwoController.text,
                  email3: emailThreeController.text,
                  gender: genderController.text,
                  dateOfBirth: dateOfBirthController.text,
                  address: PersonAddress(
                    streetController.text,
                    zipController.text,
                    cityController.text,
                    stateController.text,
                    selectCountryController.text,
                  ),
                ),
                space: SpaceCompleteRegistrationRequest(
                  country: widget.spaceCountry,
                  currency: widget.spaceCurrency,
                  language: widget.spaceLanguage,
                  name: widget.spaceName,
                  timezone: widget.spaceTimezone,
                  // timezone: widget.spaceTimezone[0],
                ),
              ),
            ),
          );
    }
  }

  // Login
  void login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthEventLogin(
              LoginRequest(
                emailOrPhoneNumber: emailOneController.text,
                password: passwordController.text,
                rememberMe: true,
              ),
            ),
          );
    }
  }

  // Handle Registration State Change
  void _handleRegistrationStateChange(BuildContext context, AuthState state) {
    if (state.status == AuthStateStatus.authenticated) {
      if (handleAuth) {
        GFToast.showToast(
          state.registrationMessage,
          context,
          toastBorderRadius: 8.0,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
        nextScreen(
          context: context,
          screen: const FullPageLoaderAuth(),
        );
        setState(() {
          handleAuth = false;
        });
      }
    }
    if (state.status == AuthStateStatus.unauthenticated) {
      print("Error...: ${state.registerFailure}");
      GFToast.showToast(
        state.registerFailure,
        context,
        toastBorderRadius: 8.0,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        backgroundColor: CustomColor.red,
      );
    }
  }

  // Handle Login State Change
  void _handleLoginStateChange(BuildContext context, AuthState state) {
    if (state.status != AuthStateStatus.authenticated) {
      if (handleLogin) {
        nextScreenAndRemoveAll(
          context: context,
          screen: const FullPageLoaderAuth(),
        );
        setState(() {
          handleLogin = false;
        });
      }
    }
    if (state.status != AuthStateStatus.unauthenticated) {
      print("Error...: ${state.loginFailure}");
      GFToast.showToast(state.loginFailure, context,
          toastBorderRadius: 8.0,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
          toastDuration: 6);
    }
  }

  void _presentDatePicker() {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }
      // setState(() {
      //   // using state so that the UI will be rerendered when date is picked
      //   _selectedDate = pickedDate;
      // });
    });
  }

  _imgFromCamera() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  bool imageMatch(File imageFile) {
    return imageFile.existsSync() &&
        RegExp(r'\.(jpeg|jpg|png|gif|bmp|webp)').hasMatch(
          imageFile.path.toLowerCase(),
        );
  }

  void _handleDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.lightBlue,
            ),
            useMaterial3: true,
            textTheme: Theme.of(context).textTheme,
          ),
          child: child!,
        );
      },
    ).then(
      (value) => {
        setState(
          () {
            if (value != null) {
              var isKids = DateTime.now().year - value.year;
              if (isKids >= 5) {
                updateDate(value);
              } else {
                GFToast.showToast(
                  "User should be at least 5 years old",
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
          },
        ),
      },
    );
  }

  int displayPhoneNumberField = 1;
  int displayEmailField = 1;

  @override
  Widget build(BuildContext context) {
    StatelessWidget userImage;

    if (_images.isEmpty) {
      userImage = IconButton(
        onPressed: () => _imgFromCamera(),
        icon: const Icon(
          Icons.person_add_rounded,
          size: 40,
        ),
        color: const Color.fromRGBO(81, 35, 0, 0.80),
      );
    } else {
      userImage = InkWell(
        onTap: () {
          _imgFromCamera();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Image.file(
            fit: BoxFit.fitWidth,
            File(_images[0].path),
          ),
        ),
      );
    }

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
        _handleRegistrationStateChange(context, state);
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => {
                previousScreen(
                  context: context,
                  // screen: SpaceRegistrationForm(),
                )
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text(
              'Register new user',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                child: IconButton(
                  // onPressed: () => {},
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      register();
                    }
                  },
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
                          children: [
                            const SizedBox(height: 30),
                            FittedBox(
                              fit: BoxFit.fill,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF5EBD8),
                                ),
                                child: userImage,
                              ),
                            ),
                            const SizedBox(height: 30),
                            CustomTextField(
                              heightSize: heightSizeFirstName,
                              hintText: "First Name*",
                              controller: firstNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  setState(() {
                                    heightSizeFirstName = 80;
                                  });
                                  return "Please enter your first name";
                                }
                                setState(() {
                                  heightSizeFirstName = 55;
                                });
                                return null;
                              },
                              fillColor: const Color(0xFFF5EBD8),
                              hintTextSize: 18,
                              color: const Color.fromRGBO(81, 35, 0, 0.80),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              heightSize: 55,
                              hintText: "Middle Name",
                              controller: middleNameController,
                              fillColor: const Color(0xFFF5EBD8),
                              hintTextSize: 20,
                              color: const Color.fromRGBO(81, 35, 0, 0.80),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              heightSize: heightSizeLastName,
                              hintText: "Last Name*",
                              controller: lastNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  setState(() {
                                    heightSizeLastName = 80;
                                  });
                                  return "Please enter your last name";
                                }
                                setState(() {
                                  heightSizeLastName = 55;
                                });
                                return null;
                              },
                              fillColor: const Color(0xFFF5EBD8),
                              hintTextSize: 20,
                              color: const Color.fromRGBO(81, 35, 0, 0.80),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: heightSizeDateOfBirth,
                              child: TextFormField(
                                onTap: () => _handleDate(),
                                showCursor: false,
                                readOnly: true,
                                controller: dateOfBirthController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      heightSizeDateOfBirth = 80;
                                    });
                                    return "Specify your date of birth";
                                  } else {
                                    setState(() {
                                      heightSizeDateOfBirth = 50;
                                    });
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.calendar_month_outlined,
                                  ),
                                  labelText: 'Date of birth*',
                                  hintText: 'mm/dd/yyyy*',
                                  // labelText: _selectedDate != null
                                  //     ? "${_selectedDate?.year}/${_selectedDate?.month}/${_selectedDate?.day}"
                                  //     : 'Date of birth*',
                                  // hintText: _selectedDate != null
                                  //     ? "${_selectedDate?.year}/${_selectedDate?.month}/${_selectedDate?.day}"
                                  //     : 'mm/dd/yyyy',

                                  // hintText: 'Date of birth*',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              width: double.infinity,
                              child: RegistrationDropdown(
                                dropdownValue: dropdownValue,
                                handleChange: (dynamic value) {
                                  setState(() {
                                    dropdownValue = value!;
                                    genderController.text = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 20),
                            IconTitleSection(
                              color: const Color(0XFF512300),
                              icon1: Icons.alternate_email_outlined,
                              icon2: showContactSection
                                  ? const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    )
                                  : const Icon(
                                      Icons.keyboard_arrow_right_rounded),
                              text: " Contacts",
                              showHideSection: () {
                                setState(() {
                                  showContactSection = !showContactSection;
                                  isVisibleContact = !isVisibleContact;
                                });
                              },
                            ),
                            Visibility(
                              visible: isVisibleContact,
                              child: Column(
                                children: [
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.end,
                                  //   children: [
                                  //     RegistrationTextButton(
                                  //       handleButton: () {
                                  //         if (extendPhonenumberSize
                                  //                 .length <
                                  //             3) {
                                  //           setState(() {
                                  //             extendPhonenumberSize
                                  //                 .add(true);
                                  //           });
                                  //         }
                                  //       },
                                  //       textName: '+ Add phone number',
                                  //       style: const TextStyle(
                                  //         decoration:
                                  //             TextDecoration.underline,
                                  //         color: Color.fromRGBO(
                                  //             81, 35, 0, 0.80),
                                  //         fontSize: 18,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 10),
                                  // for (int i = 0;
                                  //     i < extendPhonenumberSize.length;
                                  //     i++)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // generateMultipleNumbers(
                                      //   // countryCodecontroller:
                                      //   //     selectPhonenumberController(
                                      //   //         i)['countryCode'],
                                      //   digitNumbercontroller:
                                      //       selectPhonenumberController(
                                      //           i)['digit'],
                                      //   heightSize: heightSize,
                                      //   onCountryChanged: (country) {
                                      //     if (i == 0) {
                                      //       setState(() {
                                      //         countryCodeOne =
                                      //             country.dialCode;
                                      //         codeNumbercontrollerOne
                                      //                 .text =
                                      //             country.dialCode;
                                      //       });
                                      //     }
                                      //     if (i == 1) {
                                      //       setState(() {
                                      //         countryCodeTwo =
                                      //             country.dialCode;
                                      //         codeNumbercontrollerTwo
                                      //                 .text =
                                      //             country.dialCode;
                                      //       });
                                      //     }
                                      //     if (i == 2) {
                                      //       setState(() {
                                      //         countryCodeThree =
                                      //             country.dialCode;
                                      //         codeNumbercontrollerThree
                                      //                 .text =
                                      //             country.dialCode;
                                      //       });
                                      //     }
                                      //   },
                                      // ),
                                      _buildPhoneNumberField(
                                          digitNumbercontrollerOne,
                                          "Primary number"),
                                      if (displayPhoneNumberField >= 2)
                                        _buildPhoneNumberField(
                                            digitNumbercontrollerTwo,
                                            "Second number"),
                                      if (displayPhoneNumberField >= 3)
                                        _buildPhoneNumberField(
                                            digitNumbercontrollerThree,
                                            "Third number"),
                                      if (displayPhoneNumberField < 3)
                                        TextButton(
                                          onPressed: () {
                                            setState(
                                              () {
                                                if (displayPhoneNumberField <
                                                    3) {
                                                  displayPhoneNumberField =
                                                      displayPhoneNumberField +
                                                          1;
                                                }
                                              },
                                            );
                                          },
                                          child: Text(
                                            "Add another number",
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      // if (i ==
                                      //     extendPhonenumberSize.length -
                                      //         1)
                                      //   RegistrationTextButton(
                                      //     handleButton: () {
                                      //       if (extendPhonenumberSize
                                      //               .length >
                                      //           1) {
                                      //         setState(
                                      //           () {
                                      //             extendPhonenumberSize
                                      //                 .removeAt(i);
                                      //           },
                                      //         );
                                      //       }
                                      //     },
                                      //     textName: 'Remove',
                                      //     style: const TextStyle(
                                      //       color: Colors.red,
                                      //       fontSize: 15,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //   ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      RegistrationTextButton(
                                        handleButton: () {
                                          if (extendEmailSize.length < 3) {
                                            setState(() {
                                              extendEmailSize.add(true);
                                            });
                                          }
                                        },
                                        textName: '+ Add email address',
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color:
                                              Color.fromRGBO(81, 35, 0, 0.80),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  for (int i = 0;
                                      i < extendEmailSize.length;
                                      i++) ...{
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox(height: 10),
                                        CustomTextField(
                                          hintText: "Email",
                                          controller: i == 0
                                              ? emailOneController
                                              : i == 1
                                                  ? emailTwoController
                                                  : i == 2
                                                      ? emailThreeController
                                                      : emailOneController,
                                          heightSize: heightSizeEmail,
                                          validator: (value) {
                                            const pattern =
                                                r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                                                r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                                                r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                                                r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                                                r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                                                r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                                                r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                                            final regex = RegExp(pattern);
                                            if (value!.isEmpty) {
                                              setState(() {
                                                heightSizeEmail = 80;
                                              });
                                              return "Please enter your email ";
                                            } else if (!regex.hasMatch(value)) {
                                              return 'Enter a valid email address';
                                            } else {
                                              setState(() {
                                                heightSizeEmail = 55;
                                              });
                                            }
                                            return null;
                                          },
                                          color: const Color.fromRGBO(
                                              81, 35, 0, 0.80),
                                          fillColor: const Color(0xFFF5EBD8),
                                          hintTextSize: 20,
                                        ),
                                        if (i == extendEmailSize.length - 1)
                                          RegistrationTextButton(
                                            handleButton: () {
                                              if (extendEmailSize.length > 1) {
                                                setState(() {
                                                  extendEmailSize.removeAt(i);
                                                });
                                              }
                                            },
                                            textName: 'Remove',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                  }
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  IconTitleSection(
                                    color: const Color(0XFF512300),
                                    icon1: Icons.alternate_email_outlined,
                                    icon2: showAddressSection
                                        ? const Icon(
                                            Icons.keyboard_arrow_down_rounded)
                                        : const Icon(
                                            Icons.keyboard_arrow_right_rounded),
                                    text: " Address",
                                    showHideSection: () {
                                      setState(() {
                                        showAddressSection =
                                            !showAddressSection;
                                        isVisibleAdress = !isVisibleAdress;
                                      });
                                    },
                                  ),
                                  Visibility(
                                    visible: isVisibleAdress,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        CustomTextField(
                                          heightSize: 55,
                                          hintText: "Street",
                                          controller: streetController,
                                          validator: (value) {
                                            // setState(() {
                                            //   heightSize = 55;
                                            // });
                                            //   if (value!.isEmpty) {
                                            //     return "Please enter your first name";
                                            //   }
                                            //   return null;
                                          },
                                          fillColor: const Color(0xFFF5EBD8),
                                          hintTextSize: 18,
                                          color: const Color.fromRGBO(
                                              81, 35, 0, 0.80),
                                        ),
                                        const SizedBox(height: 12),
                                        CustomTextField(
                                          heightSize: 55,
                                          hintText: "ZIP",
                                          controller: zipController,
                                          validator: (value) {
                                            // setState(() {
                                            //   heightSize = 80;
                                            // });
                                            //   if (value!.isEmpty) {
                                            //     return "Please enter your first name";
                                            //   }
                                            //   return null;
                                          },
                                          fillColor: const Color(0xFFF5EBD8),
                                          hintTextSize: 18,
                                          color: const Color.fromRGBO(
                                              81, 35, 0, 0.80),
                                        ),
                                        const SizedBox(height: 12),
                                        CustomTextField(
                                          heightSize: 55,
                                          hintText: "City",
                                          controller: cityController,
                                          validator: (value) {
                                            // setState(() {
                                            //   heightSize = 55;
                                            // });
                                            //   if (value!.isEmpty) {
                                            //     return "Please enter your first name";
                                            //   }
                                            //   return null;
                                          },
                                          fillColor: const Color(0xFFF5EBD8),
                                          hintTextSize: 18,
                                          color: const Color.fromRGBO(
                                              81, 35, 0, 0.80),
                                        ),
                                        const SizedBox(height: 12),
                                        CustomTextField(
                                          heightSize: 55,
                                          hintText: "State",
                                          controller: stateController,
                                          validator: (value) {
                                            setState(() {
                                              heightSize = 55;
                                            });
                                            //   if (value!.isEmpty) {
                                            //     return "Please enter your first name";
                                            //   }
                                            //   return null;
                                          },
                                          fillColor: const Color(0xFFF5EBD8),
                                          hintTextSize: 18,
                                          color: const Color.fromRGBO(
                                              81, 35, 0, 0.80),
                                        ),
                                        const SizedBox(height: 12),

                                        // CustomTextField(
                                        //   hintText: "Select Country",
                                        //   controller: selectCountryController,
                                        //   heightSize: 55,
                                        //   validator: (value) {
                                        //     // setState(() {
                                        //     //   heightSize = 55;
                                        //     // });
                                        //     //   if (value!.isEmpty) {
                                        //     //     return "Please enter your email";
                                        //     //   }
                                        //     //   return null;
                                        //   },
                                        //   color: const Color.fromRGBO(
                                        //       81, 35, 0, 0.80),
                                        //   fillColor: const Color(0xFFF5EBD8),
                                        //   hintTextSize: 18,
                                        // ),

                                        SizedBox(
                                          height: 55,
                                          child: TextFormField(
                                            controller: selectCountryController,
                                            validator: (value) {
                                              // if (value!.isEmpty) {
                                              //   setState(() {
                                              //     heightSizeCountry = 80;
                                              //   });
                                              //   return "Select your country";
                                              // } else {
                                              //   setState(() {
                                              //     heightSizeCountry = 50;
                                              //   });
                                              // }
                                              // return null;
                                            },
                                            onTap: () => {
                                              showCountryPicker(
                                                context: context,
                                                showPhoneCode: false,
                                                onSelect: (Country country) {
                                                  setState(
                                                    () {
                                                      selectCountryController
                                                          .text = country.name;
                                                    },
                                                  );
                                                },
                                              ),
                                            },
                                            showCursor: false,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              label:
                                                  const Text("Select Country"),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFF5EBD8),
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFF5EBD8),
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              alignLabelWithHint: true,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 20),
                                        const Divider()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              heightSize: heightSizePassword,
                              hintText: "Password",
                              controller: passwordController,
                              obscureText: true,
                              validator: (value) {
                                const pattern =
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                                final regex = RegExp(pattern);

                                if (value!.isEmpty) {
                                  setState(() {
                                    heightSizePassword = 80;
                                  });
                                  return "Please enter your password";
                                } else if (!regex.hasMatch(value)) {
                                  return 'Password should have a minimum of eight characters, \nat least one uppercase letter, lowercase letter, number \nand special character';
                                } else {
                                  setState(() {
                                    heightSizePassword = 55;
                                  });
                                }
                                return null;
                              },
                              fillColor: const Color(0xFFF5EBD8),
                              hintTextSize: 18,
                              color: const Color.fromRGBO(81, 35, 0, 0.80),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              heightSize: heightSizeConfirmPassword,
                              hintText: "Confirm Password",
                              controller: confirmPasswordController,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  setState(() {
                                    heightSizeConfirmPassword = 80;
                                  });
                                  return "Please enter your password";
                                }
                                if (value != passwordController.text) {
                                  setState(() {
                                    heightSizeConfirmPassword = 80;
                                  });
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                              fillColor: const Color(0xFFF5EBD8),
                              hintTextSize: 18,
                              color: const Color.fromRGBO(81, 35, 0, 0.80),
                            ),
                            const SizedBox(height: 50),
                            DefaultBtn(
                              isLoading: state.isLoading,
                              text: "Save",
                              // color: Colors.grey,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  register();
                                }
                              },
                            ),
                            const SizedBox(height: 20),
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
      },
    );
  }

  Widget _buildPhoneNumberField(TextEditingController controller, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(
                color: SecondaryColors.secondaryOrange,
                fontSize: CustomFontSize.extraSmall,
              ),
            ),
            Spacer(),
            if (text.toLowerCase() != "primary number")
              TextButton(
                onPressed: () {
                  setState(
                    () {
                      if (displayPhoneNumberField > 1) {
                        displayPhoneNumberField = displayPhoneNumberField - 1;
                      }
                    },
                  );
                },
                child: Text(
                  "Remove number",
                  // style: TextStyle(color: _secondaryColorSelection(),),
                ),
              ),
          ],
        ),
        const SizedBox(height: 5),
        // CustomPhoneNumberField(
        //   initialValue: controller.text,
        //   controller: controller,
        //   color: SecondaryColors.secondaryOrange,
        //   onChanged: (number) {
        //     print(
        //         '  onChanged  )))))))))))))))))))))))0000   number: ${number.countryCode} ))))) ${number.completeNumber} )))))))))))))))');
        //     controller.text = number.completeNumber;
        //   },
        //   // onCountryChanged: (value) {
        //   //   print('  onCountryChanged  ............. value: ${value}.........');
        //   //   // controller.text = value.countryCode;
        //   // },
        // ),

        // IntlPhoneField(
        //   decoration: const InputDecoration(
        //     contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        //     labelText: 'Phone Number',
        //     border: OutlineInputBorder(
        //       borderSide: BorderSide(),
        //     ),
        //   ),
        //   initialValue: controller.text,
        //   onChanged: (phone) {
        //     controller.text = phone.completeNumber;
        //   },
        // )

        GenericPhoneNumberField(
          initialValue: controller.text,
          onChanged: (phone) {
            controller.text = phone.completeNumber;
          },
          fillColor: const Color(0xFFF5EBD8),
          color: const Color.fromRGBO(81, 35, 0, 0.80),
          isDense: false,
        )
      ],
    );
  }
}

class RegistrationDropdown extends StatelessWidget {
  RegistrationDropdown(
      {super.key, required this.dropdownValue, required this.handleChange});

  String dropdownValue;
  Function(dynamic) handleChange;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text("Gender *"),
      isExpanded: true,
      dropdownColor: const Color(0xFFF5EBD8),
      value: dropdownValue,
      elevation: 4,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 0,
      ),
      onChanged: handleChange,
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(fontSize: 15)),
        );
      }).toList(),
    );
  }
}

class IconTitleSection extends StatelessWidget {
  IconTitleSection({
    super.key,
    required this.icon1,
    required this.icon2,
    required this.text,
    required this.color,
    required this.showHideSection,
  });

  IconData icon1;
  Icon icon2;
  String text;
  Color color;
  Function() showHideSection;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon1,
          color: color,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        IconButton(
          onPressed: showHideSection,
          icon: icon2,
          color: color,
        ),
      ],
    );
  }
}

class generateMultipleNumbers extends StatelessWidget {
  Function(PhoneNumber)? onChanged;
  // final TextEditingController countryCodecontroller;
  final TextEditingController digitNumbercontroller;
  final Function(dynamic)? onCountryChanged;
  double? heightSize;

  generateMultipleNumbers({
    super.key,
    this.onChanged,
    // required this.countryCodecontroller,
    required this.digitNumbercontroller,
    this.heightSize,
    this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    // TextEditingController nullTextEditingController = TextEditingController();
    return CustomPhoneNumberField(
      heightSize: heightSize,
      isDense: true,
      fontSize: 20,
      color: const Color.fromRGBO(81, 35, 0, 0.80),
      fillColor: const Color(0xFFF5EBD8),
      controller: digitNumbercontroller,
      onChanged: onChanged,
      onCountryChanged: onCountryChanged,
    );
  }
}

class RegistrationTextButton extends StatelessWidget {
  RegistrationTextButton({
    super.key,
    required this.handleButton,
    required this.textName,
    this.style,
  });

  void Function() handleButton;
  final String textName;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleButton,
      child: Text(
        textName,
        style: style,
      ),
    );
  }
}
