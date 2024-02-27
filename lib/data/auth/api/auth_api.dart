import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';

import '../../constants/constants.dart';
import '../../constants/request_interceptor.dart';
import '../model/auth_request.dart';
import '../model/auth_response.dart';

var sl = GetIt.instance;

abstract class AuthApi {
  // Registration
  Future<TokenResponse> register(RegistrationRequest registrationRequest);
  Future<String> completeRegistration(
      PersonSpaceRegistrationRequest completeRegistrationRequest);

  // Login
  Future<TokenResponse> login(LoginRequest loginRequest);
  // Refresh
  Future<TokenResponse> refresh(RefreshRequest refreshRequest);
  // Logout
  Future logout();
}

class AuthApiImpl implements AuthApi {
  @override
  Future<TokenResponse> register(
      RegistrationRequest registrationRequest) async {
    // TODO: implement register
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    final res = await dio.post("/auth/registration",
        data: registrationRequest.toJson());
    logger.e(res.data);
    if (res.statusCode == 201) {
      return TokenResponse.fromJson(res.data);
    }
    throw Exception(res.data["message"][0] ?? res.data["message"]);
  }

  @override
  Future<String> completeRegistration(
    PersonSpaceRegistrationRequest completeRegistrationRequest,
  ) async {
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);

    final res = await dio.post("/auth/user-registration",
        data: completeRegistrationRequest.toJson());

    logger.e(res.data);
    if (res.statusCode == 201) {
      return res.data.toString();
    }
    throw Exception(res.data["message"]);
  }

  @override
  Future<TokenResponse> login(LoginRequest loginRequest) async {
    // TODO: implement login
    var interceptor = sl.get<RequestInterceptor>();
    var dio = Dio()..interceptors.add(interceptor);
    final res = await dio.post("${ApiConstants.baseAuthUrl}/auth/login",
        data: loginRequest.toJson());
    if (res.statusCode == 200) {
      return TokenResponse.fromJson(res.data);
    }
    throw Exception(res.data["message"]);
  }

  @override
  Future<TokenResponse> refresh(RefreshRequest refreshRequest) async {
    // TODO: implement refresh
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    final res = await dio.post("${ApiConstants.baseAuthUrl}/auth/refresh",
        data: refreshRequest.toJson());
    if (res.statusCode == 200) {
      return TokenResponse.fromJson(res.data);
    }
    throw Exception(res.data["message"]);
  }

  @override
  Future logout() async {
    // TODO: implement logout
    var interceptor = sl.get<RequestInterceptor>();
    var prefs = sl<SharedPreferenceModule>();
    var token = prefs.getToken();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    final res = await dio.post("/auth/logout",
        data: token?.refreshToken);
    logger.f(res.data);
    if (res.statusCode == 200) {
      return "Logged out successfully";
    }
  }
}
