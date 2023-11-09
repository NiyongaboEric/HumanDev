import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_request.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/fullpage_loader_auth.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/phone_number_field.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';

import '../../utilities/custom_colors.dart';
import '../../utilities/font_sizes.dart';
import '../../utilities/navigation.dart';
import 'auth_bloc/auth_bloc.dart';
import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  PhoneNumber? phoneNumber;
  bool handleAuth = true;
  bool handleLogin = true;

  // Register
  void register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthEventRegister(
              RegistrationRequest(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                email: emailController.text,
                password: passwordController.text,
                phoneNumber: phoneNumber!.completeNumber,
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
                emailOrPhoneNumber: emailController.text,
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
          toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
        login(context);
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
        toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
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
          toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
          toastDuration: 6);
    }
  }

  // Update Phone Number
  void _updatePhoneNumber(PhoneNumber phoneNumber) {
    setState(() {
      this.phoneNumber = phoneNumber;
    });
  }

  // TextEditingControllers
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
        _handleRegistrationStateChange(context, state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8D6),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: const Color(0xFFFFF8D6),
                expandedHeight: 100.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    "Create new account",
                    style: TextStyle(
                      color: SecondaryColors.secondaryOrange
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            CustomTextField(
                              hintText: "First Name",
                              controller: firstNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your first name";
                                }
                                return null;
                              },
                              color: SecondaryColors.secondaryOrange,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              hintText: "Last Name",
                              controller: lastNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your last name";
                                }
                                return null;
                              },
                              color: SecondaryColors.secondaryOrange,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              hintText: "Email",
                              controller: emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your email";
                                }
                                return null;
                              },
                              color: SecondaryColors.secondaryOrange,
                            ),
                            const SizedBox(height: 20),
                            CustomPhoneNumberField(
                              color: SecondaryColors.secondaryOrange,
                              controller: phoneNumberController,
                              onChanged: _updatePhoneNumber,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              hintText: "Password",
                              controller: passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your password";
                                }
                                return null;
                              },
                              color: SecondaryColors.secondaryOrange,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              hintText: "Confirm Password",
                              controller: confirmPasswordController,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your password";
                                }
                                if (value != passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                              color: SecondaryColors.secondaryOrange,
                            ),
                            const SizedBox(height: 50),
                            // FilledBtn(
                            //   loading: state.isLoading,
                            //   text: "Register",
                            //   onPressed: () {
                            //     if (_formKey.currentState!.validate() &&
                            //         phoneNumber != null &&
                            //         phoneNumber!.isValidNumber()) {
                            //       register();
                            //     }
                            //   },
                            //   btnVariant: BtnVariant.primary,
                            // ),
                            SizedBox(
                              width: 200,
                              child: FloatingActionButton.extended(
                                backgroundColor: const Color(0xFFF5E8D3),
                                onPressed: !state.isLoading
                                    ? () {
                                        if (_formKey.currentState!.validate() &&
                                            phoneNumber != null &&
                                            phoneNumber!.isValidNumber()) {
                                          register();
                                        }
                                      }
                                    : null,
                                label: !state.isLoading
                                    ? Text(
                                        "Create account",
                                        style: TextStyle(
                                          fontSize: CustomFontSize.large,
                                          color: SecondaryColors.secondaryOrange
                                        ),
                                      )
                                    : const CircularProgressIndicator(),
                              ),
                            ),
                            BlocListener<AuthBloc, AuthState>(
                              listener: (context, state) {
                                _handleLoginStateChange(context, state);
                              },
                              child: Container(),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account?',
                                    style: TextStyle(
                                      fontSize: CustomFontSize.small,
                                      fontWeight: FontWeight.w300,
                                      color: SecondaryColors.secondaryOrange
                                    )),
                                TextButton(
                                  onPressed: () {
                                    // Implement navigation to login screen
                                    nextScreenAndReplace(
                                      context: context,
                                      screen: const LoginScreen(),
                                    );
                                  },
                                  child: Text('Login',
                                      style: TextStyle(
                                        fontSize: CustomFontSize.small,
                                        color: SecondaryColors.secondaryOrange,
                                        decoration: TextDecoration.underline,
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20)
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
}
