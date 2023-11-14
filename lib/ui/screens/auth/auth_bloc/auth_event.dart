part of 'auth_bloc.dart';

// enum AuthEventType {
//   getUser,
//   login,
//   register,
//   refresh,
// }

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthEventGetSpaces extends AuthEvent {
  const AuthEventGetSpaces();
}

class AuthEventLogin extends AuthEvent {
  final LoginRequest loginRequest;

  const AuthEventLogin(this.loginRequest);
}

class AuthEventRegister extends AuthEvent {
  final RegistrationRequest registrationRequest;

  const AuthEventRegister(this.registrationRequest);
}

class AuthEventRefresh extends AuthEvent {
  final RefreshRequest refreshRequest;

  const AuthEventRefresh(this.refreshRequest);
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}
