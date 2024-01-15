import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_response.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/data/groups/model/group_request.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/group_bloc/groups_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/login.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';

import '../../../../data/auth/model/auth_request.dart';
import '../../../../data/groups/model/group_model.dart';
import '../../../utilities/custom_colors.dart';
import '../../../utilities/font_sizes.dart';
import '../../../widgets/buttons/default_btn.dart';

var sl = GetIt.instance;

enum ContactSelection {
  students,
  allContacts,
}

class GroupsScreen extends StatefulWidget {
  final ContactSelection contactSelection;
  const GroupsScreen({super.key, required this.contactSelection});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  var pref = sl<SharedPreferenceModule>();
  // Text Editing Controllers
  TextEditingController groupNameController = TextEditingController();

  // Groups
  List<Group> groups = [];

  // Get Groups
  _getGroups() {
    sl<GroupsBloc>().add(const GroupsEventGetGroups());
  }

  // Create Group
  _createGroup() {
    sl<GroupsBloc>().add(GroupsEventCreateGroup(GroupRequest(name: groupNameController.text)));
  }

  // Refresh Tokens
  _refreshTokens() {
    TokenResponse? tokenResponse = pref.getToken();
    if (tokenResponse != null) {
      sl<AuthBloc>().add(AuthEventRefresh(
        RefreshRequest(refresh: tokenResponse.refreshToken),
      ));
    }
  }

  // Logout
  _logout() {
    sl<AuthBloc>().add(const AuthEventLogout());
  }

  // Handle Groups State Change
  void _handleGroupsStateChange(BuildContext context, GroupsState state) {
    if (state.status == GroupStateStatus.success) {
      setState(() {
        groups = state.groups!;
      });
    }
    if (state.status == GroupStateStatus.createSuccess) {
      setState(() {
        groups.add(state.groupResponse!);
      });
    }
    if (state.status == GroupStateStatus.error ||
        state.status == GroupStateStatus.createError) {
      if (state.errorMessage == "Unauthorized" ||
          state.errorMessage == "Invalid token") {
        _refreshTokens();
      } else {
        GFToast.showToast(
          state.errorMessage,
          context,
          toastBorderRadius: 8.0,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.BOTTOM
              : GFToastPosition.TOP,
          backgroundColor: CustomColor.red,
          toastDuration: 6,
        );
      }
    }
  }

  // Handle Refresh State Change
  void _handleRefreshStateChange(BuildContext context, AuthState state) {
    if (state.status == AuthStateStatus.authenticated) {
      _getGroups();
    }
    if (state.status == AuthStateStatus.unauthenticated) {
      _logout();
    }
  }

  // Handle Logout State Change
  void _handleLogoutStateChange(BuildContext context, AuthState state) {
    pref.clear();
    nextScreenAndRemoveAll(context: context, screen: const LoginScreen());
  }


  // Primary Color Selection
  Color _primaryColorSelection() {
    if (widget.contactSelection == ContactSelection.students) {
      return PrimaryColors.primaryPink;
    } else {
      return PrimaryColors.primaryLightGreen;
    }
  }

  // Secondary Color Selection
  Color _secondaryColorSelection() {
    if (widget.contactSelection == ContactSelection.students) {
      return SecondaryColors.secondaryPink;
    } else {
      return SecondaryColors.secondaryLightGreen;
    }
  }

  // Background Color Selection
  Color _backgroundColorSelection() {
    if (widget.contactSelection == ContactSelection.students) {
      return BackgroundColors.bgPink;
    } else {
      return BackgroundColors.bgLightGreen;
    }
  }

  // Tertiary Color Selection
  Color _tertiaryColorSelection() {
    if (widget.contactSelection == ContactSelection.students) {
      return TertiaryColors.tertiaryPink;
    } else {
      return TertiaryColors.tertiaryLightGreen;
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    // Get Groups form Shared Preferences
    var value = pref.getGroups();
    if (value.isNotEmpty) {
      groups.addAll(value);
    }
    _getGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsBloc, GroupsState>(listener: (context, state) {
      _handleGroupsStateChange(context, state);
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: _backgroundColorSelection(),
        appBar: _buildAppBar(),
        body: _buildListView(state),
      );
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
        iconTheme: IconThemeData(color: _secondaryColorSelection()),
        backgroundColor: _primaryColorSelection(),
        title: const Text("Groups"),
        centerTitle: true,
        actions: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              _handleRefreshStateChange(context, state);
              _handleLogoutStateChange(context, state);
            },
            child: Container(),
          ),
          IconButton(
            onPressed: () {
              _buildDialog();
            },
            icon: const Icon(Icons.add_rounded),
          )
        ]);
  }

  // void _addGroup(Group group) {
  //   setState(() {
  //     groups.add(group);
  //   });
  // }

  Color primaryColorSelection(ContactSelection contactSelection) {
    switch (contactSelection) {
      case ContactSelection.students:
        return Colors.pink.shade50;
      case ContactSelection.allContacts:
        return Colors.greenAccent.shade100;
    }
  }

  Color secondaryColorSelection(ContactSelection contactSelection) {
    switch (contactSelection) {
      case ContactSelection.students:
        return SecondaryColors.secondaryPink;
      case ContactSelection.allContacts:
        return Colors.greenAccent;
    }
  }

  ListView _buildListView(GroupsState state) {
    return ListView(
      children: [
        for (var group in groups) _buildGroupListTile(group),
        state.isLoading
            ? const Center(child: GFLoader(type: GFLoaderType.ios,))
            : Container(),        
      ],
    );
  }

  Widget _buildGroupListTile(Group group) {
    return ListTile(
      onTap: () {
        Navigator.pop(context, group);
      },
      title: Text(
        group.name!,
        style: TextStyle(
          color: _secondaryColorSelection(),
          fontSize: CustomFontSize.medium,
        ),
      ),
    );
  }

  void _buildDialog (){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: Colors.pink.shade50,
        title: const Text("Add new group"),
        content: CustomTextField(
          controller: groupNameController,
          hintText: "Group name",
          inputType: TextInputType.text,
          color: SecondaryColors.secondaryPink,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: SecondaryColors.secondaryPink,
                fontSize: CustomFontSize.large,
              ),
            ),
          ),
          DefaultBtn(
            btnColor: primaryColorSelection(widget.contactSelection),
            textColor: secondaryColorSelection(widget.contactSelection),
            text: "Create",
            onPressed: () {
              if (groupNameController.text.isNotEmpty) {
                _createGroup();
              }
            }
          ),
        ],
        
      ),
    );
  }
}
