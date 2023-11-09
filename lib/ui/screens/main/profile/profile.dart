import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/filled_btn.dart';

import '../../auth/auth_bloc/auth_bloc.dart';
import '../../auth/login.dart';

var sl = GetIt.instance;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var prefs = sl.get<SharedPreferenceModule>();
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
              ),
              const SizedBox(height: 10),
              // Text(
              //   "${state.schoolAdmin!.firstName} ${state.schoolAdmin!.lastName}",
              //   textAlign: TextAlign.center,
              // ),
              const Text(
                "School Name",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text("Profile Settings",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  "Profile",
                  style: TextStyle(fontSize: 14),
                ),
                trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    )),
              ),
              const SizedBox(height: 10),
              // Privacy Policy etc..
              const Text("About",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text(
                    "About",
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                      ))),
              const SizedBox(height: 10),
              ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text(
                    "Privacy Policy",
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                      ))),
              const SizedBox(height: 10),
              // Terms and Conditions
              ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text(
                    "Terms and Conditions",
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                      ))),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledBtn(
                      text: "Logout",
                      onPressed: () {
                        prefs.clear();
                        nextScreenAndRemoveAll(
                            context: context, screen: const LoginScreen());
                      },
                      btnVariant: BtnVariant.danger,
                      loading: false)
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
