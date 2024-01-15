import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_request.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/fullpage_loader_auth.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/space_registration.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/custom_colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';

import 'auth_bloc/auth_bloc.dart';
import 'register.dart';

var sl = GetIt.instance;

var prefs = sl<SharedPreferenceModule>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailOrPhoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool handleAuth = true;

  // Login
  void login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthEventLogin(
              LoginRequest(
                emailOrPhoneNumber: emailOrPhoneNumberController.text,
                password: passwordController.text,
                rememberMe: true,
              ),
            ),
          );
    }
  }

  // Handle Login State Change
  void _handleLoginStateChange(BuildContext context, AuthState state) {
    if (state.status == AuthStateStatus.authenticated) {
      if (handleAuth) {
        nextScreenAndRemoveAll(
          context: context,
          screen: const FullPageLoaderAuth(),
        );
        setState(() {
          handleAuth = false;
        });
        return;
      }
    } else if (state.status == AuthStateStatus.unauthenticated) {
      GFToast.showToast(state.loginFailure, context,
          toastBorderRadius: 8.0,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
          toastDuration: 6);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    logger.w(prefs.getSpaces());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailOrPhoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
        _handleLoginStateChange(context, state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8D6),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80),
                    Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: SecondaryColors.secondaryOrange,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Good to see you again!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: CustomFontSize.small,
                        color: SecondaryColors.secondaryOrange,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 35),
                    CustomTextField(
                      hintText: "Email or Phone number",
                      controller: emailOrPhoneNumberController,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your email or phone number";
                        }
                        return null;
                      },
                      color: SecondaryColors.secondaryOrange,
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: 200,
                        child: FloatingActionButton.extended(
                          backgroundColor: const Color(0xFFF5E8D3),
                          onPressed: !state.isLoading
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    login(context);
                                  }
                                }
                              : null,
                          label: !state.isLoading
                              ? Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: CustomFontSize.large,
                                      color: SecondaryColors.secondaryOrange),
                                )
                              : const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 75),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                              fontSize: CustomFontSize.small,
                              fontWeight: FontWeight.w300,
                              color: SecondaryColors.secondaryOrange),
                        ),
                        TextButton(
                          onPressed: () {
                            nextScreenAndReplace(
                              context: context,
                              // screen: const RegistrationScreen(),
                              screen: const SpaceRegistration(),
                            );
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: CustomFontSize.small,
                              color: SecondaryColors.secondaryOrange,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
