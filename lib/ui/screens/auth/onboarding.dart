import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/login.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: IntroductionScreen(
        pages: pages,
        onDone: () {
          // Go to login screen
          nextScreenAndReplace(context: context, screen: const LoginScreen());
        },
        // onSkip: () {},
        showSkipButton: true,
        showNextButton: true,
        showDoneButton: true,
        skip: const Text('Skip'),
        next: const Icon(Icons.arrow_forward_ios_rounded),
        done: const Text('Get Started'),
        dotsDecorator: const DotsDecorator(
            size: Size(10, 10),
            activeSize: Size(25, 10),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(25),
            ))),
        globalBackgroundColor: Colors.white,
      ),
    );
  }
}

// Page List
List<PageViewModel> pages = [
  PageViewModel(
    title: 'Welcome to Seymo Pay',
    body:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    image: Center(
      child: Image.asset(
        'assets/images/transaction.png',
      )
    )
  ),
  PageViewModel(
    title: 'Educate Affordably and Conveniently',
    body:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    image: Center(
      child: Image.asset(
        'assets/images/education.png',
      )
    )
  )
];
