import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/parent.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/reminder/reminder_types/sms_reminder/sms_reminder.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/custom_colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/constants/home_sections_model.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/section_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../data/auth/model/auth_request.dart';
import '../../../data/auth/model/auth_response.dart';
import '../../../data/constants/shared_prefs.dart';
import '../../../data/space/model/space_model.dart';
import '../../widgets/inputs/text_field.dart';
import '../auth/auth_bloc/auth_bloc.dart';
import '../auth/login.dart';
import '../auth/space_bloc/space_bloc.dart';
import '../main/transaction_records/paid_money/payment.dart';
import '../main/transaction_records/recieved_money/received_money.dart';

GetIt sl = GetIt.instance;

var prefs = sl<SharedPreferenceModule>();

Space? space = prefs.getSpaces().first;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  bool nameUpdated = false;
  bool listenRefresh = false;
  bool logout = false;
  String updatedName = "";
  Key homePage = const Key("home-page");
  bool isCurrentPage = false;

  // Refresh Tokens
  void _refreshTokens() {
    setState(() {
      listenRefresh = true;
    });
    TokenResponse? token = prefs.getToken();
    if (token != null) {
      logger.d(token.refreshToken);
      context.read<AuthBloc>().add(
            AuthEventRefresh(
              RefreshRequest(refresh: token.refreshToken),
            ),
          );
    }
  }

  // Logout
  void _logout() {
    context.read<AuthBloc>().add(const AuthEventLogout());
  }

  // Update School Name
  void updateSchoolName(String name) {
    context.read<SpaceBloc>().add(SpaceEventUpdateSpaceName(name));
  }

  // Handle Space Name Change State
  void _handleSpaceNameChangeState(BuildContext context, SpaceState state) {
    if (state.status == SpaceStateStatus.success) {
      GFToast.showToast(
        "Space name changed successfully",
        context,
        toastBorderRadius: 8.0,
        toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
        backgroundColor: Colors.green.shade800,
      );
      setState(() {
        updatedName = state.spaces.first.name!;
        nameUpdated = true;
      });
      logger.f(state.spaces.first.name);
    }
    if (state.status == SpaceStateStatus.error) {
      if (state.errorMessage == "Unauthorized" ||
          state.errorMessage == "Exception: Unauthorized") {
        _refreshTokens();
      } else {
        GFToast.showToast(
          state.errorMessage ?? "Unable to change space name",
          context,
          toastBorderRadius: 8.0,
          toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
        );
      }
    }
  }

  // Handle Refresh Tokens State Change
  void _handleRefreshStateChange(BuildContext context, AuthState state) {
    if (!listenRefresh || logout) {
      return;
    }
    if (state.refreshFailure != null) {
      if (state.refreshFailure!.contains("Invalid refresh token")) {
        _logout();
      } else {
        GFToast.showToast(
          state.refreshFailure,
          context,
          toastBorderRadius: 8.0,
          toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
          toastDuration: 6,
        );
      }
    }
    if (state.refreshFailure == null) {
      updateSchoolName(nameController.text);
      setState(() {
        listenRefresh = false;
      });
    }
  }

  void _handleLogoutStateChange(BuildContext context, AuthState state) {
    if (!logout) {
      return;
    }
    if (state.logoutMessage != null) {
      nextScreenAndRemoveAll(context: context, screen: const LoginScreen());
    }
    if (state.logoutFailure != null) {
      GFToast.showToast(
        state.logoutFailure,
        context,
        toastBorderRadius: 8.0,
        toastPosition:  MediaQuery.of(context).viewInsets.bottom != 0 
                                ? GFToastPosition.TOP
                                : GFToastPosition.BOTTOM,
        backgroundColor: CustomColor.red,
        toastDuration: 6,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<HomeSection> logTransactions = [
      HomeSection(
        title: "Received money",
        color: const Color(0xFF0BBA74),
        icon: const Icon(
          Icons.file_download_outlined,
          color: Colors.white,
          size: 54,
        ),
        onPressed: () {
          nextScreen(context: context, screen: const ReceivedMoney());
        },
      ),
      HomeSection(
        title: "Paid money",
        color: const Color(0xFFF56359),
        icon: const Icon(
          Icons.file_upload_outlined,
          color: Colors.white,
          size: 54,
        ),
        onPressed: () {
          nextScreen(context: context, screen: const Payment());
        },
      )
    ];

    List<HomeSection> reminders = [
      HomeSection(
        title: "SMS",
        color: const Color(0xFFFF8D3A),
        icon: const Icon(
          CupertinoIcons.text_bubble_fill,
          color: Colors.white,
          size: 54,
        ),
        onPressed: () {
          nextScreen(context: context, screen: const SMSReminder());
        },
      ),
      HomeSection(
        title: "Letter",
        color: const Color(0xFF00ADEF),
        icon: const Icon(
          CupertinoIcons.mail_solid,
          color: Colors.white,
          size: 54,
        ),
        onPressed: () {
          nextScreen(
              context: context,
              screen: const Parents(
                parentSection: ParentSection.letter,
              ));
        },
      ),
      HomeSection(
        title: "Conversation",
        color: const Color(0xFFFAD215),
        icon: const Icon(
          CupertinoIcons.person_2_alt,
          color: Colors.white,
          size: 54,
        ),
        onPressed: () {
          nextScreen(
              context: context,
              screen: const Parents(
                parentSection: ParentSection.conversation,
              ));
        },
      ),
      HomeSection(
        title: "To-Do",
        color: const Color(0xFFF9977E),
        icon: Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset(
            "assets/icons/todo.png",
            color: Colors.white,
          ),
        ),
        onPressed: () {},
      )
    ];

    List<HomeSection> parents = [
      HomeSection(
        title: "Send SMS",
        color: const Color(0xFF1877F2),
        icon: const Icon(
          // Icons.telegram_outlined,
          CupertinoIcons.paperplane_fill,
          color: Colors.white,
          size: 54,
        ),
        onPressed: () {},
      ),
      HomeSection(
        title: "Family profile",
        color: const Color(0xFFF09EC5),
        icon: const Icon(
          Icons.family_restroom_rounded,
          color: Colors.white,
          size: 54,
        ),
        onPressed: () {},
      )
    ];

    List<HomeSection> reports = [
      HomeSection(
        title: "Transaction log",
        color: const Color(0xFF9747FF),
        icon: const Icon(
          Icons.compare_arrows_rounded,
          color: Colors.white,
          size: 54,
        ),
        onPressed: () {},
      ),
      HomeSection(
        title: "Fee status",
        color: const Color(0xFF0D9252),
        icon: const Icon(
          Icons.checklist_rounded,
          color: Colors.white,
          size: 54,
        ),
        onPressed: () {},
      )
    ];

    return VisibilityDetector(
      key: homePage,
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.5) {
          setState(() {
            isCurrentPage = true;
          });
        } else {
          setState(() {
            isCurrentPage = false;
          });
        }
      },
      child: BlocConsumer<SpaceBloc, SpaceState>(
        listener: (context, state) {
          // TODO: implement listener
          if (isCurrentPage) {            
            _handleSpaceNameChangeState(context, state);
          }
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: const Color(0xFFF5E8D3),
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: SecondaryColors.secondaryOrange,
                ),
                title: Text(
                    updatedName.isNotEmpty
                        ? updatedName
                        : space?.name == "Your first space!"
                            ? "Seymo"
                            : space!.name!,
                    style: TextStyle(
                      color: SecondaryColors.secondaryOrange,
                    )),
                backgroundColor: const Color(0xFFF5E8D3),
                centerTitle: true,
                actions: [
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      // TODO: implement listener
                      if (isCurrentPage) {
                        _handleRefreshStateChange(context, state);
                        _handleLogoutStateChange(context, state);                        
                      }
                    },
                    child: Container(),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                            child: Text(
                              "Change school/space name",
                              style: TextStyle(
                                fontSize: CustomFontSize.extraSmall,
                                color: SecondaryColors.secondaryOrange,
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                    builder: (context, dialogState) {
                                  // var loader = false;
                                  return AlertDialog(
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      backgroundColor: const Color(0xFFF5E8D3),
                                      title: Text(
                                        "Change school name",
                                        style: TextStyle(
                                            color:
                                                SecondaryColors.secondaryOrange,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Form(
                                        key: formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomTextField(
                                              color: SecondaryColors.secondaryOrange,
                                              controller: nameController,
                                              hintText: "New school name",
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "School name is required";
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            nameController.clear();
                                          },
                                          child: Text("Cancel",
                                              style: TextStyle(
                                                fontSize: CustomFontSize.small,
                                                color: SecondaryColors
                                                    .secondaryOrange,
                                              )),
                                        ),
                                        FloatingActionButton.extended(
                                          backgroundColor: const Color(0xFFF5E8D3),
                                          onPressed: state.isLoading
                                              ? null
                                              : () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    updateSchoolName(
                                                        nameController.text);
                                                    !nameUpdated
                                                        ? Navigator.pop(context)
                                                        : null;
                                                  }
                                                  nameController.clear();
                                                },
                                          label: state.isLoading
                                              ? const CircularProgressIndicator()
                                              : Text("Save",
                                                  style: TextStyle(
                                                    fontSize:
                                                        CustomFontSize.small,
                                                    color: SecondaryColors
                                                        .secondaryOrange,
                                                  )),
                                        )
                                      ]);
                                }),
                              );
                            }),
                        PopupMenuItem(
                          child: Text(
                            "Log out",
                            style: TextStyle(
                              fontSize: CustomFontSize.extraSmall,
                              color: SecondaryColors.secondaryOrange,
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: AlertDialog(
                                    backgroundColor: const Color(0xFFF5E8D3),
                                    title: Text("Are you sure?",
                                        style: TextStyle(
                                            color:
                                                SecondaryColors.secondaryOrange,
                                            fontWeight: FontWeight.bold)),
                                    content: Text(
                                        "Are you sure you want to log out?",
                                        style: TextStyle(
                                          fontSize: CustomFontSize.small,
                                          color: SecondaryColors.secondaryOrange,
                                        )),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel",
                                            style: TextStyle(
                                              fontSize: CustomFontSize.small,
                                              color:
                                                  SecondaryColors.secondaryOrange,
                                            )),
                                      ),
                                      FloatingActionButton.extended(
                                        backgroundColor: const Color(0xFFF5E8D3),
                                        onPressed: () {
                                          prefs.clearSpaces();
                                          prefs.clear();
                                          nextScreenAndRemoveAll(
                                              context: context,
                                              screen: const LoginScreen());
                                        },
                                        label: Text("Log out",
                                            style: TextStyle(
                                              fontSize: CustomFontSize.small,
                                              color:
                                                  SecondaryColors.secondaryOrange,
                                            )),
                                      )
                                    ]),
                              ),
                            );
                          },
                        ),
                      ];
                    },
                    icon: const Icon(CupertinoIcons.ellipsis_circle),
                    offset: const Offset(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                ],
              ),
              body: ListView(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFF8D6),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset:
                                const Offset(0, 5), // changes position of shadow
                          ),
                        ]),
                    child: Column(
                      children: [
                        const SizedBox(height: 22.5),
                        Text(
                          "Log transaction",
                          style: TextStyle(
                              fontSize: CustomFontSize.large,
                              color: SecondaryColors.secondaryOrange,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 8 / 8,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: logTransactions.length,
                          itemBuilder: (context, index) => SectionCard(
                            title: logTransactions[index].title,
                            icon: logTransactions[index].icon,
                            bgColor: logTransactions[index].color,
                            onPressed: logTransactions[index].onPressed,
                            textColor: SecondaryColors.secondaryOrange,
                          ),
                        ),
                        // const SizedBox(height: 22),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFF8D6),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset:
                                const Offset(0, 5), // changes position of shadow
                          ),
                        ]),
                    child: Column(
                      children: [
                        const SizedBox(height: 22.5),
                        Text(
                          "Reminders",
                          style: TextStyle(
                              fontSize: CustomFontSize.large,
                              fontWeight: FontWeight.w500,
                              color: SecondaryColors.secondaryOrange),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 8 / 7.5,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: reminders.length,
                          itemBuilder: (context, index) => SectionCard(
                            title: reminders[index].title,
                            icon: reminders[index].icon,
                            bgColor: reminders[index].color,
                            onPressed: reminders[index].onPressed,
                            textColor: SecondaryColors.secondaryOrange,
                          ),
                        ),
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFF8D6),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset:
                                const Offset(0, 5), // changes position of shadow
                          ),
                        ]),
                    child: Column(
                      children: [
                        const SizedBox(height: 22.5),
                        Text(
                          "Parents",
                          style: TextStyle(
                              fontSize: CustomFontSize.large,
                              color: SecondaryColors.secondaryOrange,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 8 / 7.5,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: parents.length,
                          itemBuilder: (context, index) => SectionCard(
                            title: parents[index].title,
                            icon: parents[index].icon,
                            bgColor: parents[index].color,
                            onPressed: parents[index].onPressed,
                            textColor: SecondaryColors.secondaryOrange,
                          ),
                        ),
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFF8D6),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset:
                                const Offset(0, 5), // changes position of shadow
                          ),
                        ]),
                    child: Column(
                      children: [
                        const SizedBox(height: 22),
                        Text(
                          "Reports",
                          style: TextStyle(
                              fontSize: CustomFontSize.large,
                              color: SecondaryColors.secondaryOrange,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 8 / 7.5,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: reports.length,
                          itemBuilder: (context, index) => SectionCard(
                            title: reports[index].title,
                            icon: reports[index].icon,
                            bgColor: reports[index].color,
                            onPressed: reports[index].onPressed,
                            textColor: SecondaryColors.secondaryOrange,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ));
        },
      ),
    );
  }
}
