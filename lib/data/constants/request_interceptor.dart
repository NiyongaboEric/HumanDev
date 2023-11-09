import 'package:dio/dio.dart';

import '../auth/model/auth_response.dart';
import 'shared_prefs.dart';

class RequestInterceptor extends Interceptor {
  final SharedPreferenceModule pref;

  RequestInterceptor({required this.pref});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    TokenResponse? userData = pref.getToken();
    if (userData != null) {
      options.headers["Authorization"] = "Bearer ${userData.accessToken}";
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("=== Dio Error Occured ===");
    print(err.response?.data['message']);
    print("=== Dio Error Occurred ===");
    return super.onError(err, handler);
  }

}