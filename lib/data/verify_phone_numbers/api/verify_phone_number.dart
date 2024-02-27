import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
// import 'package:seymo_pay_mobile_application/data/constants/constants.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/constants/request_interceptor.dart';
import 'package:seymo_pay_mobile_application/data/verify_phone_numbers/model/verify_phone_number_request.dart';

var sl = GetIt.instance;

abstract class VerifyPhoneNumberApi {
  Future<String> verifyPhoneNumber(VerifyPhoneNumberRequest verifyPhoneNumberRequest);
}

class VerifyPhoneNumberImpl implements VerifyPhoneNumberApi {
  @override
  Future<String> verifyPhoneNumber(
    VerifyPhoneNumberRequest verifyPhoneNumberRequest,
  ) async {
    var interceptor = sl.get<RequestInterceptor>();
    var dio = sl.get<Dio>()..interceptors.add(interceptor);
    final res = await dio.post(
      "/auth/verify-phone-number/verify",
      data: verifyPhoneNumberRequest.toJson()
    );
    logger.e(res.data);
  
  if (res.statusCode == 200) {
    return "Phone number was verified";
  }
    throw Exception(res.data["message"][0] ?? res.data["message"]);
  }
}
