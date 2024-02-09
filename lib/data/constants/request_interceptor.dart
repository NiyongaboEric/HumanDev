import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/auth/api/auth_api.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_request.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';

import '../auth/model/auth_response.dart';
import 'shared_prefs.dart';

var sl = GetIt.instance;

class RequestInterceptor extends Interceptor {
  final SharedPreferenceModule pref;
  final AuthApiImpl authApiImpl;

  RequestInterceptor({
    required this.pref,
    required this.authApiImpl,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = pref.getToken()?.accessToken;
    if (accessToken != null) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      logger.e("Token expired");
      final refreshedToken = await _refreshToken(err.requestOptions);
      if (refreshedToken != null) {
        handler.resolve(await Dio().fetch(err.requestOptions));
      } else {
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  Future<TokenResponse?> _refreshToken(RequestOptions options) async {
    final token = pref.getToken();
    if (token == null) return null;

    final newToken = await authApiImpl.refresh(RefreshRequest(refresh: token.refreshToken));
    if (newToken != null) {
      pref.saveToken(newToken);
      options.headers["Authorization"] = "Bearer ${newToken.accessToken}";
      return newToken;
    }
    return null;
  }
}
