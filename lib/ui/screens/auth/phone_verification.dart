import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:pinput/pinput.dart';
import 'package:seymo_pay_mobile_application/data/verify_phone_numbers/model/verify_phone_number_request.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/fullpage_loader_auth.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/verify_phone_number_bloc/verify_phone_number_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/custom_colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';

class PhoneVerification extends StatefulWidget {
  PhoneVerification({ super.key, required this.phoneNumber });

  String phoneNumber;

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {

  final _formKey = GlobalKey<FormState>();

  // 5 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  // This is the entered code
  // It will be displayed in a Text widget
  late String _otp;

  void sendCode() {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _otp = 
          _fieldOne.text +
          _fieldTwo.text +
          _fieldThree.text +
          _fieldFour.text +
          _fieldFive.text +
          _fieldSix.text;
      });
    context.read<VerifyPhoneNumberBloc>().add(
      ValidateVerifyPhoneNumberEvent(
        VerifyPhoneNumberRequest(
          phoneNumber: widget.phoneNumber,
          verificationCode: _otp
        )
      )
    );
    }
  }

  //  // Handle Registration State Change
  void _handlePhoneNumberVerificationStateChange(BuildContext context, VerifyPhoneNumberState state) {
    print("********** ${state.status} **********");
    if (state.status == VerifyPhoneNumberStatus.verified) {
      GFToast.showToast(
          state.verifyPhoneNumberMessage,
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
    } if (state.status == VerifyPhoneNumberStatus.unverified) {
      GFToast.showToast(
        state.verifyPhoneNumberFailure,
        context,
        toastBorderRadius: 8.0,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        backgroundColor: CustomColor.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyPhoneNumberBloc, VerifyPhoneNumberState>(
      listener: (context, state) {
        _handlePhoneNumberVerificationStateChange(context, state);
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0XFFF5EBD8),
              automaticallyImplyLeading: false,
              title: Text(
                'Code verification',
                style: TextStyle(
                  fontSize: 25,  
                  fontWeight: FontWeight.bold,
                  color: SecondaryColors.secondaryOrange,
                ),
              ),
            ),
            backgroundColor: const Color(0XFFFFF8D6),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height:100),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Please enter the short code sent on your registered phone number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 21,
                          color: SecondaryColors.secondaryOrange,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OtpInput(_fieldOne, true), // auto focus
                          OtpInput(_fieldTwo, false),
                          OtpInput(_fieldThree, false),
                          OtpInput(_fieldFour, false),
                          OtpInput(_fieldFive, false),
                          OtpInput(_fieldSix, false)
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: const Color(0XFFDAC6A1),
                          padding: EdgeInsets.symmetric(vertical: 15)
                        ),
                        onPressed: () {
                          sendCode();
                        },
                        child: Text(
                          'Verify code', 
                          style: TextStyle(
                            color: SecondaryColors.secondaryOrange,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              )
            )
          );
      }
    );
  }
}

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 55,
      child: TextFormField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: SecondaryColors.secondaryOrange
            )
          ),
          border: const OutlineInputBorder(),
          counterText: '',
          hintStyle: TextStyle(
            color: SecondaryColors.secondaryOrange,
            fontWeight: FontWeight.bold,
            fontSize: 20.0
          )
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "?";
          }
          return null;
        },
      ),
    );
  }
}