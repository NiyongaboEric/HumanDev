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
      logger.e(err.response?.data['message']);
      if (err.response?.data['message'] == "Invalid refresh token.") {
        logger.wtf("Invalid refresh token");
        return handler.next(err);
      }
      try {
        final refreshedToken = await _refreshToken(err.requestOptions);
        logger.e("Token refresh");
        // if (refreshedToken != null) {
        handler.resolve(await sl<Dio>().fetch(
          err.requestOptions
            ..headers["Authorization"] = "Bearer ${refreshedToken.accessToken}",
        ));
        // } else {
        //   logger.e("Token refresh failed");
        //   handler.next(err);
        // }
      } catch (error) {
        logger.e("Token refresh failed");
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  Future<TokenResponse> _refreshToken(RequestOptions options) async {
    final token = pref.getToken();
    if (token == null) throw Exception("Token is null");
    try {
      final newToken = await authApiImpl
          .refresh(RefreshRequest(refresh: token.refreshToken));
      pref.saveToken(newToken);
      // options.headers["Authorization"] = "Bearer ${newToken.accessToken}";
      return newToken;
    } catch (e) {
      throw Exception(e);
    }
  }
}
