part of 'auth_bloc.dart';

enum AuthStateStatus {
  initial,
  authenticated,
  unauthenticated,
  registrationFailure,
  loginFailure,
  refreshFailure,
}

class AuthState {
  final AuthStateStatus status;
  final List<Space>? spaces;
  final bool isLoading;
  final String? registrationMessage;
  final String? loginMessage;
  final String? logoutMessage;
  final String? loginFailure;
  final String? registerFailure;
  final String? refreshFailure;
  final String? getUserFailure;
  final String? logoutFailure;
  final TokenResponse? tokenResponse;

  const AuthState({
    this.status = AuthStateStatus.initial,
    this.isLoading = false,
    this.spaces,
    this.registrationMessage,
    this.loginMessage,
    this.logoutMessage,
    this.logoutFailure,
    this.loginFailure,
    this.refreshFailure,
    this.registerFailure,
    this.tokenResponse,
    this.getUserFailure,
  });

  AuthState copyWith({
    AuthStateStatus? status,
    bool? isLoading,
    List<Space>? spaces,
    String? registrationMessage,
    String? loginMessage,
    String? logoutMessage,
    String? loginFailure,
    String? refreshFailure,
    String? registerFailure,
    String? logoutFailure,
    TokenResponse? tokenResponse,
    String? getUserFailure,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      spaces: spaces ?? this.spaces,
      registrationMessage: registrationMessage ?? this.registrationMessage,
      loginMessage: loginMessage ?? this.loginMessage,
      logoutMessage: logoutMessage ?? this.logoutMessage,
      loginFailure: loginFailure ?? this.loginFailure,
      refreshFailure: refreshFailure ?? this.refreshFailure,
      tokenResponse: tokenResponse ?? this.tokenResponse,
      getUserFailure: getUserFailure ?? this.getUserFailure,
      logoutFailure: logoutFailure ?? this.logoutFailure,
      registerFailure: registerFailure ?? this.registerFailure,
    );
  }
}
