
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_request.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/group_bloc/groups_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/login.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/space_bloc/space_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/tags_bloc/tags_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/screens/home/homepage.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../data/auth/model/auth_response.dart';
import '../../../data/constants/shared_prefs.dart';
import '../../utilities/custom_colors.dart';
import '../main/person/bloc/person_bloc.dart';
import 'accounts_bloc/accounts_bloc.dart';
import 'auth_bloc/auth_bloc.dart';

var sl = GetIt.instance;

class FullPageLoaderAuth extends StatefulWidget {
  const FullPageLoaderAuth({super.key});

  @override
  State<FullPageLoaderAuth> createState() => _FullPageLoaderAuthState();
}

class _FullPageLoaderAuthState extends State<FullPageLoaderAuth> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool hasSpace = false;
  bool logout = false;
  final Connectivity _connectivity = Connectivity();
  bool refreshSuccess = false;
  var prefs = sl<SharedPreferences>();
  Key startLoader = const Key("start-loader");
  bool isCurrentPage = true;

  // Get User Data
  void _getSpaces() {
    context.read<SpaceBloc>().add(const SpaceEventGetSpaces());
  }

  // Get Accounts
  void _getAccounts() {
    context.read<AccountsBloc>().add(const AccountsEventGetAccounts());
  }

  // Get Tags
  void _getTags() {
    context.read<TagsBloc>().add(const TagsEventGetTags());
  }

  // Logout
  void _logout() {
    context.read<AuthBloc>().add(const AuthEventLogout());
  }

  // Get Groups
  void _getGroups() {
    context.read<GroupsBloc>().add(const GroupsEventGetGroups());
  }

  // Get Admin
  void _getAdmin() {
    context.read<PersonBloc>().add(const GetAdminEvent());
  }

  // Refresh Tokens
  void _refreshTokens() {
    var prefs = sl<SharedPreferenceModule>();
    TokenResponse? token = prefs.getToken();
    if (token != null) {
      context.read<AuthBloc>().add(
            AuthEventRefresh(
              RefreshRequest(refresh: token.refreshToken),
            ),
          );
    }
  }

  // Handle Get User Data State Change
  void _handleRefreshStateChange(BuildContext context, AuthState state) {
    // var prefs = sl<SharedPreferenceModule>();
    if (logout) {
      return;
    }
    if (state.status == AuthStateStatus.authenticated) {
      // Check network connectivity
      if (_connectivityResult != ConnectivityResult.none) {
        Future.delayed(const Duration(seconds: 5), () {
          logger.d("Internet Connection Available");
        });
        _getSpaces();
      } else {
        logger.d("Internet Connection Not Available");
        nextScreenAndRemoveAll(context: context, screen: const HomePage());
      }

      if (state.refreshFailure != null) {
        GFToast.showToast(
          state.refreshFailure,
          context,
          toastBorderRadius: 8.0,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
        );
      }
    }
    if (state.status == AuthStateStatus.unauthenticated) {
      print("Error...: ${state.refreshFailure}");
      if (_connectivityResult != ConnectivityResult.none) {
        if (state.refreshFailure != null &&
            state.refreshFailure!.contains("Invalid refresh token")) {
          logger.w("Invalid refresh token");
          setState(() {
            logout = true;
          });
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
      } else {
        GFToast.showToast(
          "No Internet Connection",
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
  }

  // Handle Logout State Change
  void _handleLogoutStateChange(BuildContext context, AuthState state) {
    if (!logout) {
      return;
    }
    if (state.logoutMessage != null) {
      nextScreenAndRemoveAll(context: context, screen: const LoginScreen());
    }
    if (state.logoutFailure != null) {
      var prefs = sl<SharedPreferenceModule>();
      prefs.clear();
      nextScreenAndRemoveAll(context: context, screen: const LoginScreen());
    }
  }

  // Handle Space State Change
  void _handleSpaceStateChange(BuildContext context, SpaceState state) {
    var prefs = sl<SharedPreferenceModule>();
    if (state.status == SpaceStateStatus.success) {
      // setState(() {
      //   navigate = true;
      // });
      logger.i(prefs.getSpaces().first.id);
      if (prefs.getSpaces().isNotEmpty) {
        _getAccounts();
        // nextScreenAndRemoveAll(context: context, screen: const HomePage());
      }
    }
    if (state.status == SpaceStateStatus.error) {
      if (state.errorMessage == "Unauthorized" ||
          state.errorMessage == "Exception: Unauthorized") {
        _refreshTokens();
      }
    }
  }

  // Handle Accounts State Change
  void _handleAccountStateChange(BuildContext context, AccountsState state) {
    if (state.status == AccountsStateStatus.success) {
      _getAdmin();
    }
    if (state.status == AccountsStateStatus.error) {
      if (state.errorMessage == "Unauthorized" ||
          state.errorMessage == "Exception: Unauthorized") {
        _refreshTokens();
      } else {
        GFToast.showToast(
          state.errorMessage,
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

  // Handle Admin State Change
  void _handleAdminStateChange(BuildContext context, PersonState state) {
    if (state.status == PersonStatus.success) {
      _getGroups();
    }
    if (state.status == PersonStatus.error) {
      if (state.errorMessage == "Unauthorized" ||
          state.errorMessage == "Exception: Unauthorized") {
        _refreshTokens();
      } else {
        logger.w(state.errorMessage);
        GFToast.showToast(
          state.errorMessage,
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

  // Handle Groups State Change
  void _handleGroupsStateChange(BuildContext context, GroupsState state) {
    if (state.status == GroupStateStatus.success) {
      nextScreenAndRemoveAll(context: context, screen: const HomePage());
    }
    if (state.status == GroupStateStatus.error) {
      if (state.errorMessage == "Unauthorized" ||
          state.errorMessage == "Exception: Unauthorized") {
        _refreshTokens();
      } else {
        GFToast.showToast(
          state.errorMessage,
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

  @override
  void initState() {
    // TODO: implement initState
    _connectivity.onConnectivityChanged.listen((result) {
      _connectivityResult = result;
    });
    _getSpaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: startLoader,
      onVisibilityChanged: (visibilityInfo) {
        if (mounted) {
          if (visibilityInfo.visibleFraction > 0.5) {
            setState(() {
              isCurrentPage = true;
            });
          } else {
            setState(() {
              isCurrentPage = false;
            });
          }
        }
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (context, state) {
              return true;
            },
            listener: (context, state) {
              // TODO: implement refresh listener
              if (mounted) {
                if (isCurrentPage) {
                  _handleRefreshStateChange(context, state);
                  _handleLogoutStateChange(context, state);
                }
              }
            },
          ),
          BlocListener<SpaceBloc, SpaceState>(
            listenWhen: (context, state) {
              return true;
            },
            listener: (context, state) {
              // TODO: implement space listener
              if (mounted) {
                if (isCurrentPage) {
                  _handleSpaceStateChange(context, state);
                }
              }
            },
          ),
          BlocListener<AccountsBloc, AccountsState>(
              listenWhen: (context, state) {
            return true;
          }, listener: (context, state) {
            // TODO: implement accounts listener
            if (mounted) {
              if (isCurrentPage) {
                _handleAccountStateChange(context, state);
              }
            }
          }),
          BlocListener<PersonBloc, PersonState>(listenWhen: (context, state) {
            return true;
          }, listener: (context, state) {
            // TODO: implement admin listener
            if (mounted) {
              if (isCurrentPage) {
                _handleAdminStateChange(context, state);
              }
            }
          }),
          BlocListener<GroupsBloc, GroupsState>(listenWhen: (context, state) {
            return true;
          }, listener: (context, state) {
            // TODO: implement groups listener
            if (mounted) {
              if (isCurrentPage) {
                _handleGroupsStateChange(context, state);
              }
            }
          }),
        ],
        child: const Scaffold(
          body: Center(
            child: GFLoader(type: GFLoaderType.ios),
          ),
        ),
      ),
    );
  }
}
