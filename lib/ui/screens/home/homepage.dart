import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
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
      setState(() {
        updatedName = state.spaces.first.name!;
        nameUpdated = true;
      });
      GFToast.showToast(
        "Space name changed successfully",
        context,
        toastBorderRadius: 8.0,
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
            ? GFToastPosition.TOP
            : GFToastPosition.BOTTOM,
        backgroundColor: Colors.green.shade800,
      );
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
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
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
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
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
        toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
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
    return VisibilityDetector(
      key: homePage,
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.5) {
          if (mounted)
            setState(() {
              isCurrentPage = true;
            });
        } else {
          if (mounted)
            setState(() {
              isCurrentPage = false;
            });
        }
      },
      child: BlocConsumer<SpaceBloc, SpaceState>(
        listener: (context, state) {
          if (isCurrentPage) {
            _handleSpaceNameChangeState(context, state);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5E8D3),
            appBar: _buildAppBar(context, state),
            body: ListView(
              children: [
                const SizedBox(height: 30),
                ...homeSections(context).map(
                  (section) {
                    return Column(
                      children: [
                        _buildSectionContainer(
                          title: section.title,
                          sections: section.buttons,
                          textColor: SecondaryColors.secondaryOrange,
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  },
                ).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, SpaceState state) {
    return AppBar(
      iconTheme: IconThemeData(
        color: SecondaryColors.secondaryOrange,
      ),
      title: 
      
      Text(
        state.spaces.first.name!.isNotEmpty ?  "${state.spaces.first.name}" : "Seymo",
        style: TextStyle(
          color: SecondaryColors.secondaryOrange,
        ),
      ),
      
      // Text(
      //   updatedName.isNotEmpty
      //       ? updatedName
      //       : space?.name == "Your first space!"
      //           ? "Seymo"
      //           : space!.name!,
      //   style: TextStyle(
      //     color: SecondaryColors.secondaryOrange,
      //   ),
      // ),

      backgroundColor: const Color(0xFFF5E8D3),
      centerTitle: true,
      actions: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (isCurrentPage) {
              _handleRefreshStateChange(context, state);
              _handleLogoutStateChange(context, state);
            }
          },
          child: Container(),
        ),
        _buildPopupMenuButton(context, state),
      ],
    );
  }

  Widget _buildPopupMenuButton(BuildContext context, SpaceState state) {
    return PopupMenuButton(
      color: const Color(0xFFF5EBD8),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text(
              "Change school/space name",
              style: TextStyle(
                fontSize: CustomFontSize.extraSmall,
                color: SecondaryColors.secondaryChocolate,
              ),
            ),
            onTap: () {
              _showChangeSchoolNameDialog(context, state);
            },
          ),
          PopupMenuItem(
            child: Text(
              "Settings",
              style: TextStyle(
                fontSize: CustomFontSize.extraSmall,
                color: SecondaryColors.secondaryChocolate,
              ),
            ),
            onTap: () {},
          ),
          PopupMenuItem(
            child: Text(
              "Log out",
              style: TextStyle(
                fontSize: CustomFontSize.extraSmall,
                color: SecondaryColors.secondaryChocolate,
              ),
            ),
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ];
      },
      icon: const Icon(CupertinoIcons.ellipsis_circle),
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void _showChangeSchoolNameDialog(BuildContext context, SpaceState state) {
    showDialog(
      context: context,
      builder: (context) => _buildChangeSchoolNameDialog(context, state),
    );
  }

  AlertDialog _buildChangeSchoolNameDialog(
      BuildContext context, SpaceState state) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      backgroundColor: const Color(0xFFF5E8D3),
      title: Text(
        "Change school name",
        style: TextStyle(
          color: SecondaryColors.secondaryOrange,
          fontWeight: FontWeight.bold,
        ),
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
        _buildCancelButton(context),
        _buildSaveButton(context, state),
      ],
    );
  }

  TextButton _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        nameController.clear();
      },
      child: Text(
        "Cancel",
        style: TextStyle(
          fontSize: CustomFontSize.small,
          color: SecondaryColors.secondaryOrange,
        ),
      ),
    );
  }

  FloatingActionButton _buildSaveButton(
      BuildContext context, SpaceState state) {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFFF5E8D3),
      onPressed: state.isLoading ? null : () => _handleSaveButtonPress(context),
      label: _buildSaveButtonLabel(state),
    );
  }

  void _handleSaveButtonPress(BuildContext context) {
    if (formKey.currentState!.validate()) {
      updateSchoolName(nameController.text);
      !nameUpdated ? Navigator.pop(context) : null;
    }
    nameController.clear();
  }

  Widget _buildSaveButtonLabel(SpaceState state) {
    return state.isLoading
        ? const CircularProgressIndicator()
        : Text(
            "Save",
            style: TextStyle(
              fontSize: CustomFontSize.small,
              color: SecondaryColors.secondaryOrange,
            ),
          );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildLogoutConfirmationDialog(context),
    );
  }

  SizedBox _buildLogoutConfirmationDialog(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: AlertDialog(
        backgroundColor: const Color(0xFFF5E8D3),
        title: Text(
          "Are you sure?",
          style: TextStyle(
            color: SecondaryColors.secondaryOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: TextStyle(
            fontSize: CustomFontSize.small,
            color: SecondaryColors.secondaryOrange,
          ),
        ),
        actions: [
          _buildCancelButton(context),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  FloatingActionButton _buildLogoutButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFFF5E8D3),
      onPressed: () {
        prefs.clearSpaces();
        prefs.clear();
        nextScreenAndRemoveAll(
          context: context,
          screen: const LoginScreen(),
        );
      },
      label: Text(
        "Log out",
        style: TextStyle(
          fontSize: CustomFontSize.small,
          color: SecondaryColors.secondaryOrange,
        ),
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required List<HomeButton> sections,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8D6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 22.5),
          Text(
            title,
            style: TextStyle(
              fontSize: CustomFontSize.large,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 170,
              // childAspectRatio: 8 / 7.5,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: sections.length,
            itemBuilder: (context, index) => SectionCard(
              title: sections[index].title,
              icon: sections[index].icon,
              bgColor: sections[index].color,
              onPressed: sections[index].onPressed,
              textColor: textColor,
            ),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
