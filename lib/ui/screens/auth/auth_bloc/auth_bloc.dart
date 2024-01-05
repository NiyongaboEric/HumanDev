import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/auth/api/auth_api.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/data/space/model/space_model.dart';

import '../../../../data/auth/model/auth_request.dart';
import '../../../../data/auth/model/auth_response.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferenceModule sharedPreferenceModule;
  final AuthApiImpl authApiImpl;

  AuthBloc(this.sharedPreferenceModule, this.authApiImpl)
      : super(const AuthState(status: AuthStateStatus.initial)) {
    on<AuthEventLogin>(_login);
    on<AuthEventRegister>(_register);
    on<AuthEventRefresh>(_refresh);
    on<AuthEventLogout>(_logout);
  }

  Future<void> _login(AuthEventLogin event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final tokenResponse = await authApiImpl.login(event.loginRequest);
      sharedPreferenceModule.saveToken(tokenResponse);
      emit(state.copyWith(
        status: AuthStateStatus.authenticated,
        tokenResponse: tokenResponse,
        isLoading: false,
      ));
      emit(state.copyWith(
        status: AuthStateStatus.initial,
        loginFailure: null,
      ));
    } on DioException catch (error) {
      emit(state.copyWith(
        status: AuthStateStatus.unauthenticated,
        loginFailure: error.response?.data['message'] ?? "Network Error",
        isLoading: false,
      ));
      emit(state.copyWith(
        status: AuthStateStatus.initial,
        loginFailure: null,
      ));
    }
  }

  Future<void> _register(
      AuthEventRegister event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final TokenResponse message =
          await authApiImpl.register(event.registrationRequest);

      sharedPreferenceModule.saveToken(message);

      final registerUser = await authApiImpl
          .completeRegistration(event.personSpaceRegistrationRequest);

      // print('....pre last step... ${message} ... ${message.accessToken}');
      print('....last step... $registerUser');

      emit(state.copyWith(
        status: AuthStateStatus.authenticated,
        registrationMessage: 'Account space created successfully',
        isLoading: false,
      ));
      emit(state.copyWith(
        status: AuthStateStatus.initial,
      ));
    } on DioException catch (error) {
      print('....... Error step:  $error,  ... ${error.response}');
      emit(state.copyWith(
        status: AuthStateStatus.unauthenticated,
        registerFailure: error
            .response!.data['message'], //error.response!.data['message'][0],
        isLoading: false,
      ));
      emit(state.copyWith(
        status: AuthStateStatus.initial,
        registerFailure: null,
      ));
    }
  }

  Future<void> _refresh(AuthEventRefresh event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final tokenResponse = await authApiImpl.refresh(event.refreshRequest);
      sharedPreferenceModule.saveToken(tokenResponse);
      emit(state.copyWith(
        tokenResponse: tokenResponse,
        status: AuthStateStatus.authenticated,
        isLoading: false,
      ));
    } on DioException catch (error) {
      emit(state.copyWith(
        status: AuthStateStatus.unauthenticated,
        refreshFailure: error.response?.data['message'] ?? "Network Error",
        isLoading: false,
      ));
    } finally {
      emit(state.copyWith(
          status: AuthStateStatus.initial,
          isLoading: false,
          refreshFailure: null,
          loginFailure: null,
          tokenResponse: null));
    }
  }

  // Logout
  Future<void> _logout(AuthEventLogout event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await authApiImpl.logout();
      sharedPreferenceModule.clear();
      emit(state.copyWith(
        tokenResponse: null,
        logoutMessage: "User successfully logged out",
        status: AuthStateStatus.unauthenticated,
        isLoading: false,
      ));
    } on DioException catch (error) {
      emit(state.copyWith(
        isLoading: false,
        logoutFailure: error.response?.data['message'] ?? "Network Error",
      ));
    }
  }
}
